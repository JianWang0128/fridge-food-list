# 冰箱食物清单 - 固定域名部署指南

## 🎯 目标：创建固定自定义域名

最终获得类似这样的URL：
- `https://你的用户名.github.io/冰箱清单`
- `https://冰箱清单.netlify.app`
- `https://冰箱清单.vercel.app`

## 📋 方案对比

| 平台                   | 自定义程度 | 域名格式                  | 免费额度 | 推荐指数 |
| ---------------------- | ---------- | ------------------------- | -------- | -------- |
| **GitHub Pages** ⭐⭐⭐⭐⭐ | 高         | `用户名.github.io/仓库名` | 无限     | 最推荐   |
| Netlify                | 高         | `随机名.netlify.app`      | 100GB/月 | 很好     |
| Vercel                 | 高         | `随机名.vercel.app`       | 100GB/月 | 很好     |

## 🚀 GitHub Pages 部署（推荐）

### 步骤1：创建GitHub账户
1. 访问 [github.com](https://github.com)
2. 注册新账户（如果没有）
3. 验证邮箱

### 步骤2：创建仓库
1. 点击右上角 "+" → "New repository"
2. **Repository name**: `冰箱清单` 或 `fridge-food-list`
3. **Description**: "冰箱食物清单 - Flutter Web应用"
4. **Visibility**: Public（公开）
5. **不要**勾选 "Add a README file"
6. 点击 "Create repository"

### 步骤3：上传代码
```bash
# 在终端中运行（替换为你的信息）
./deploy_github.sh 你的GitHub用户名 仓库名

# 例如：
./deploy_github.sh johnsmith 冰箱清单
```

### 步骤4：启用GitHub Pages
1. 打开你的仓库：`https://github.com/用户名/仓库名`
2. 点击 **Settings** 标签
3. 在左侧菜单中找到 **Pages**
4. **Source** 选择 "Deploy from a branch"
5. **Branch** 选择 "main"，**Folder** 选择 "/docs"
6. 点击 **Save**

### 步骤5：访问网站
等待2-3分钟，网站就会在以下地址可用：
```
https://你的用户名.github.io/仓库名
```

## 🔄 更新网站

当你修改应用后，重新部署：
```bash
./deploy_github.sh 你的用户名 仓库名
```

## 🌐 其他平台选项

### Netlify（如果需要更短域名）
1. 注册 [netlify.com](https://netlify.com)
2. 拖拽 `web_deployment.tar.gz` 到Netlify界面
3. 自动获得 `https://random-name.netlify.app`

### Vercel（如果需要更短域名）
1. 注册 [vercel.com](https://vercel.com)
2. 上传 `docs/` 文件夹
3. 自动获得 `https://random-name.vercel.app`

## 📱 添加桌面快捷方式

用户可以通过以下方式添加：

### Chrome浏览器
1. 打开你的网站URL
2. 点击地址栏的"安装"图标
3. 应用出现在桌面

### 移动浏览器
- **iOS Safari**: 分享 → 添加到主屏幕
- **Android Chrome**: 菜单 → 添加到主屏幕

## 🔒 自定义域名（可选）

如果需要自己的域名（如 `冰箱.app`）：
1. 购买域名（Namecheap, GoDaddy等）
2. 在GitHub Pages设置中添加自定义域名
3. 配置DNS记录

## 📊 访问统计

- **GitHub Pages**: 在仓库的 "Insights" → "Traffic" 查看
- **Netlify/Vercel**: 在控制台查看详细统计

## 💡 最佳实践

1. **仓库名**: 用中文或英文，方便记忆
2. **定期更新**: 保持应用最新版本
3. **备份**: 定期备份代码
4. **监控**: 关注访问量和错误

---

**🎉 完成这些步骤后，你就拥有了一个永久的、自定义域名的冰箱食物清单网站！**