import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FridgeItem {
  final String id;
  final String name;
  final DateTime createdAt;

  FridgeItem({required this.id, required this.name, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'createdAt': createdAt.toIso8601String()};
  }

  factory FridgeItem.fromMap(Map<String, dynamic> map) {
    return FridgeItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class FridgeDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  // 获取用户的冰箱食物列表
  Stream<List<FridgeItem>> getFridgeItems() {
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('fridge_items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return FridgeItem.fromMap(doc.data());
          }).toList();
        });
  }

  // 添加食物项目
  Future<void> addFridgeItem(String name) async {
    if (userId == null) return;

    final itemId = DateTime.now().millisecondsSinceEpoch.toString();
    final item = FridgeItem(id: itemId, name: name, createdAt: DateTime.now());

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('fridge_items')
        .doc(itemId)
        .set(item.toMap());
  }

  // 删除食物项目
  Future<void> removeFridgeItem(String itemId) async {
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('fridge_items')
        .doc(itemId)
        .delete();
  }

  // 清空所有食物项目
  Future<void> clearAllItems() async {
    if (userId == null) return;

    final batch = _firestore.batch();
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('fridge_items')
        .get();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
