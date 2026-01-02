# Firebase 设置指南

## 📋 步骤1：创建Firebase项目

1. 访问 [Firebase Console](https://console.firebase.google.com/)
2. 点击 **"创建项目"** 或 **"Create a project"**
3. 项目名称：`冰箱食物清单` 或 `fridge-food-list`
4. 启用 Google Analytics（可选）
5. 选择 Google Analytics 账户
6. 点击 **"创建项目"**

## 🔧 步骤2：启用认证

1. 在Firebase控制台左侧菜单点击 **"Authentication"**
2. 点击 **"开始使用"**
3. 选择 **"邮箱/密码"** 登录方式
4. 点击启用
5. 保存设置

## 🗄️ 步骤3：启用Firestore数据库

1. 在左侧菜单点击 **"Firestore Database"**
2. 点击 **"创建数据库"**
3. 选择 **"以测试模式开始"**（生产环境需要设置安全规则）
4. 选择数据库位置（建议选择离用户最近的地区）
5. 点击 **"完成"**

## 🌐 步骤4：添加Web应用

1. 点击项目概览页面的 **"</>"** 图标（添加Web应用）
2. 应用昵称：`冰箱食物清单 Web`
3. 勾选 **"同时设置Firebase Hosting"**
4. 点击 **"注册应用"**
5. **复制配置信息**（后面需要用到）

## 📝 步骤5：更新配置文件

1. 打开 `lib/firebase_options.dart` 文件
2. 替换 `web` 配置中的值：

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: '你的-apiKey',
  appId: '你的-appId',
  messagingSenderId: '你的-messagingSenderId',
  projectId: '你的-projectId',
  authDomain: '你的-projectId.firebaseapp.com',
  storageBucket: '你的-projectId.appspot.com',
  measurementId: '你的-measurementId', // 如果没有可以删除这行
);
```

## 🚀 步骤6：测试应用

1. 运行应用：
```bash
flutter run -d chrome
```

2. 测试功能：
   - 注册新账户
   - 添加食物项目
   - 刷新页面确认数据保存
   - 登出并重新登录确认数据同步

## 🔒 生产环境安全设置

当应用准备发布时，需要设置Firestore安全规则：

1. 在Firebase控制台 → Firestore → 规则
2. 替换为：

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 用户只能访问自己的数据
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📊 监控使用情况

- **Authentication**: 查看用户注册/登录统计
- **Firestore**: 监控数据库使用量
- **Analytics**: 查看用户行为数据

## 💰 Firebase免费额度

- **Authentication**: 每月50,000活跃用户
- **Firestore**: 每月50,000次读取，20,000次写入
- **Hosting**: 每月10GB存储，360MB传输

## 🆘 常见问题

### 应用无法启动
- 检查 `firebase_options.dart` 配置是否正确
- 确认Firebase项目已启用相应服务

### 数据不同步
- 检查Firestore安全规则
- 确认用户已登录

### 登录失败
- 检查Authentication设置
- 确认邮箱/密码正确

---

**🎉 配置完成后，你的冰箱食物清单就有完整的用户系统和云端数据同步了！**