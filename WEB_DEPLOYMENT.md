# 冰箱食物清单 - Web版本部署指南

## 🌐 网页版优势

- **零成本发布**：无需应用商店费用
- **即时更新**：修改后立即生效
- **跨平台兼容**：支持所有现代浏览器
- **桌面快捷方式**：用户可以添加到桌面

## 📁 部署文件

构建好的Web应用位于：`build/web/`

主要文件：
- `index.html` - 主页面
- `manifest.json` - PWA配置
- `flutter.js` - Flutter运行时
- `main.dart.js` - 编译后的Dart代码
- `assets/` - 静态资源
- `icons/` - 应用图标

## 🚀 部署选项

### 选项1：免费静态网站托管

#### GitHub Pages（推荐）
1. 创建GitHub仓库
2. 上传 `build/web/` 文件夹内容到仓库
3. 在仓库设置中启用GitHub Pages
4. 访问：`https://你的用户名.github.io/仓库名`

#### Netlify（推荐）
1. 注册 [Netlify](https://netlify.com)
2. 拖拽 `build/web` 文件夹到Netlify界面
3. 自动部署完成
4. 获取免费域名

#### Vercel
1. 注册 [Vercel](https://vercel.com)
2. 上传 `build/web` 文件夹
3. 自动部署

### 选项2：本地测试

运行本地服务器测试：
```bash
cd build/web
python3 -m http.server 8000
# 或使用Node.js
npx serve .
```

访问：`http://localhost:8000`

## 📱 添加桌面快捷方式

用户可以通过以下方式添加：

### Chrome/Edge浏览器
1. 打开网页版应用
2. 点击地址栏右侧的"安装"图标或菜单中的"安装应用"
3. 确认安装

### Safari浏览器（iOS）
1. 打开网页版应用
2. 点击分享按钮
3. 选择"添加到主屏幕"

### Firefox浏览器
1. 打开网页版应用
2. 点击菜单 → "安装此应用"

## 🔧 自定义设置

### 修改应用信息
编辑 `web/manifest.json`：
- `name`: 应用全名
- `short_name`: 桌面快捷方式名称
- `theme_color`: 主题颜色

### 更新图标
替换 `web/icons/` 中的PNG文件：
- `Icon-192.png`: 192x192像素
- `Icon-512.png`: 512x512像素

## 📊 功能特性

- ✅ 完全离线工作
- ✅ 本地数据存储
- ✅ 响应式设计
- ✅ PWA支持
- ✅ 桌面快捷方式
- ✅ 智能emoji图标

## 🔒 隐私与安全

- 所有数据存储在用户本地浏览器中
- 不收集任何个人数据
- 无需服务器后端
- 支持HTTPS（托管平台自动提供）

---

**部署后，用户就可以通过浏览器访问并添加到桌面使用了！** 🎉