import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FridgeItem {
  final String id;
  final String name;
  final String type; // 'frozen' 或 'refrigerated'
  final String quantity;
  final DateTime createdAt;

  FridgeItem({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FridgeItem.fromMap(Map<String, dynamic> map) {
    return FridgeItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'refrigerated',
      quantity: map['quantity'] ?? '1',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class LocalFridgeDataService {
  Database? _database;
  final String userId;

  LocalFridgeDataService(this.userId);

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fridge_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE IF NOT EXISTS fridge_items(
            id TEXT PRIMARY KEY,
            userId TEXT NOT NULL,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            quantity TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
          ''',
        );
      },
    );
  }

  Future<List<FridgeItem>> getFridgeItems() async {
    final db = await database;
    final maps = await db.query(
      'fridge_items',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => FridgeItem.fromMap(maps[i]));
  }

  Stream<List<FridgeItem>> getFridgeItemsStream() async* {
    while (true) {
      yield await getFridgeItems();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> addFridgeItem(
    String name, {
    String type = 'refrigerated',
    String quantity = '1',
  }) async {
    final db = await database;
    final itemId = DateTime.now().millisecondsSinceEpoch.toString();
    final item = FridgeItem(
      id: itemId,
      name: name,
      type: type,
      quantity: quantity,
      createdAt: DateTime.now(),
    );

    final map = item.toMap();
    map['userId'] = userId;

    await db.insert('fridge_items', map);
  }

  Future<void> removeFridgeItem(String itemId) async {
    final db = await database;
    await db.delete(
      'fridge_items',
      where: 'id = ? AND userId = ?',
      whereArgs: [itemId, userId],
    );
  }

  Future<void> clearAllItems() async {
    final db = await database;
    await db.delete(
      'fridge_items',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
