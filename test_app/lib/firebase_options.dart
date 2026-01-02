// Firebase 配置
// 请在 https://console.firebase.google.com/ 创建项目后替换以下配置

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macOS;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: 替换为你的Firebase项目配置
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCSSST-Zw2C8D7tywZL_W9BcoR-fy-OTpA',
    appId: '1:954407963626:web:868304497d36ce19bd8093',
    messagingSenderId: '954407963626',
    projectId: 'fridge-food-list',
    authDomain: 'fridge-food-list.firebaseapp.com',
    storageBucket: 'fridge-food-list.firebasestorage.app',
    measurementId: 'G-N2P9LMEY0W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSSST-Zw2C8D7tywZL_W9BcoR-fy-OTpA',
    appId: '1:954407963626:web:868304497d36ce19bd8093',
    messagingSenderId: '954407963626',
    projectId: 'fridge-food-list',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSSST-Zw2C8D7tywZL_W9BcoR-fy-OTpA',
    appId: '1:954407963626:web:868304497d36ce19bd8093',
    messagingSenderId: '954407963626',
    projectId: 'fridge-food-list',
  );

  static const FirebaseOptions macOS = FirebaseOptions(
    apiKey: 'AIzaSyCSSST-Zw2C8D7tywZL_W9BcoR-fy-OTpA',
    appId: '1:954407963626:web:868304497d36ce19bd8093',
    messagingSenderId: '954407963626',
    projectId: 'fridge-food-list',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCSSST-Zw2C8D7tywZL_W9BcoR-fy-OTpA',
    appId: '1:954407963626:web:868304497d36ce19bd8093',
    messagingSenderId: '954407963626',
    projectId: 'fridge-food-list',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyCSSST-Zw2C8D7tywZL_W9BcoR-fy-OTpA',
    appId: '1:954407963626:web:868304497d36ce19bd8093',
    messagingSenderId: '954407963626',
    projectId: 'fridge-food-list',
  );
}
