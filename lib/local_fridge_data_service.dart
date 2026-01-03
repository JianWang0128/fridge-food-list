import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  final String userId;
  late SharedPreferences _prefs;
  bool _initialized = false;

  LocalFridgeDataService(this.userId);

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  String _getKey() => 'fridge_items_$userId';

  Future<List<FridgeItem>> _getFridgeItemsAsync() async {
    await _ensureInitialized();
    final jsonString = _prefs.getString(_getKey()) ?? '[]';
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final items = jsonList
        .map((item) => FridgeItem.fromMap(item as Map<String, dynamic>))
        .toList();
    // Sort by createdAt descending
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Stream<List<FridgeItem>> getFridgeItems() async* {
    while (true) {
      yield await _getFridgeItemsAsync();
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> addFridgeItem(
    String name, {
    String type = 'refrigerated',
    String quantity = '1',
  }) async {
    await _ensureInitialized();
    final itemId = DateTime.now().millisecondsSinceEpoch.toString();
    final item = FridgeItem(
      id: itemId,
      name: name,
      type: type,
      quantity: quantity,
      createdAt: DateTime.now(),
    );

    final items = await _getFridgeItemsAsync();
    items.add(item);

    final jsonList = items.map((item) => item.toMap()).toList();
    await _prefs.setString(_getKey(), jsonEncode(jsonList));
  }

  Future<void> removeFridgeItem(String itemId) async {
    await _ensureInitialized();
    final items = await _getFridgeItemsAsync();
    items.removeWhere((item) => item.id == itemId);

    final jsonList = items.map((item) => item.toMap()).toList();
    await _prefs.setString(_getKey(), jsonEncode(jsonList));
  }

  Future<void> clearAllItems() async {
    await _ensureInitialized();
    await _prefs.remove(_getKey());
  }
}
