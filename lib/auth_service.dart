import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  FirebaseAuth get _authInstance {
    _auth ??= FirebaseAuth.instance;
    return _auth!;
  }

  FirebaseFirestore get _firestoreInstance {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!;
  }

  User? get currentUser => _authInstance.currentUser;
  bool get isSignedIn => currentUser != null;

  Stream<User?> get authStateChanges => _authInstance.authStateChanges();

  // 注册新用户
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential result = await _authInstance
          .createUserWithEmailAndPassword(email: email, password: password);
      // 创建用户数据文档
      await _firestoreInstance.collection('users').doc(result.user!.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
      notifyListeners();
      return result;
    } catch (e) {
      print('注册失败: $e');
      return null;
    }
  }

  // 用户登录
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential result = await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 更新最后登录时间
      await _firestoreInstance.collection('users').doc(result.user!.uid).update(
        {'lastLogin': FieldValue.serverTimestamp()},
      );
      notifyListeners();
      return result;
    } catch (e) {
      print('登录失败: $e');
      return null;
    }
  }

  // 用户登出
  Future<void> signOut() async {
    await _authInstance.signOut();
    notifyListeners();
  }

  // 重置密码
  Future<void> resetPassword(String email) async {
    await _authInstance.sendPasswordResetEmail(email: email);
  }
}
