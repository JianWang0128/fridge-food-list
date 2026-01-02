# 冰箱食物清单 - 自定义域名设置指南

## 🎯 目标：拥有自己的域名

从 `https://用户名.github.io/仓库名` 升级到 `https://冰箱.app` 或 `https://fridge-food.com`

## 💰 域名购买

### 推荐域名注册商：

| 注册商              | 价格      | 推荐指数 | 特点                |
| ------------------- | --------- | -------- | ------------------- |
| **Namecheap** ⭐⭐⭐⭐⭐ | $8.88/年  | 最推荐   | 便宜 + 免费隐私保护 |
| **Porkbun**         | $6.88/年  | 很好     | 最便宜的 .com       |
| **GoDaddy**         | $11.99/年 | 一般     | 知名但较贵          |
| **Cloudflare**      | $8.00/年  | 很好     | 集成CDN             |

### 域名建议：

**首选域名**（按优先级）：
1. `bingxiang.app` - 中文简洁
2. `fridge-food.com` - 英文专业
3. `冰箱清单.com` - 中文完整
4. `fridge-list.app` - 英文简洁

**检查域名可用性**：
- [Namecheap域名检查](https://www.namecheap.com/domains/registration/)
- [Porkbun域名检查](https://porkbun.com/)

## 🚀 设置步骤

### 方案1：GitHub Pages + 自定义域名（推荐）

#### 步骤1：购买域名
1. 在Namecheap购买域名（如 `bingxiang.app`）
2. 完成注册和支付

#### 步骤2：配置DNS
1. 登录Namecheap账户
2. 找到你的域名 → "Domain List" → "Manage"
3. 点击 "Advanced DNS"
4. 删除所有现有记录
5. 添加以下记录：

**A记录**（指向GitHub Pages）：
```
Type: A
Host: @
Value: 185.199.108.153

Type: A
Host: @
Value: 185.199.109.153

Type: A
Host: @
Value: 185.199.110.153

Type: A
Host: @
Value: 185.199.111.153
```

**CNAME记录**（www子域名，可选）：
```
Type: CNAME
Host: www
Value: 用户名.github.io
```

#### 步骤3：配置GitHub Pages
1. 打开你的GitHub仓库
2. Settings → Pages
3. **Custom domain** 输入你的域名（如 `bingxiang.app`）
4. 勾选 "Enforce HTTPS"
5. 保存

#### 步骤4：验证
等待5-10分钟，访问 `https://你的域名` 应该能看到网站

### 方案2：Netlify + 自定义域名

#### 优点：
- 更快的全球CDN
- 自动HTTPS
- 更好的性能

#### 设置步骤：
1. 注册 [netlify.com](https://netlify.com)
2. 上传 `web_deployment.tar.gz`
3. 在Site settings → Domain management
4. 添加自定义域名
5. 按照Netlify的DNS配置指南设置

### 方案3：Vercel + 自定义域名

#### 优点：
- 极快的前端性能
- 全球边缘网络

#### 设置步骤：
1. 注册 [vercel.com](https://vercel.com)
2. 导入GitHub仓库或上传文件
3. 在Settings → Domains添加自定义域名
4. 按照Vercel的DNS配置设置

## 🔧 DNS配置详解

### 基本概念：
- **A记录**: 将域名指向IP地址
- **CNAME记录**: 将子域名指向另一个域名
- **TTL**: DNS缓存时间（建议300秒）

### GitHub Pages DNS配置：

```
类型: A     主机: @     值: 185.199.108.153  TTL: 300
类型: A     主机: @     值: 185.199.109.153  TTL: 300
类型: A     主机: @     值: 185.199.110.153  TTL: 300
类型: A     主机: @     值: 185.199.111.153  TTL: 300
```

### 验证DNS设置：

使用在线工具检查：
- [DNS Checker](https://dnschecker.org/)
- [What's My DNS](https://www.whatsmydns.net/)

## 📱 移动端优化

### 添加到主屏幕：
1. 在手机浏览器打开你的域名
2. Safari: 分享 → 添加到主屏幕
3. Chrome: 菜单 → 添加到主屏幕

### PWA设置：
你的应用已经配置了PWA，支持：
- 离线访问
- 桌面快捷方式
- 推送通知（未来扩展）

## 🔒 SSL证书

所有方案都提供自动HTTPS：
- GitHub Pages: 自动Let's Encrypt
- Netlify: 自动HTTPS
- Vercel: 自动HTTPS

## 📊 监控和分析

### 访问统计：
- **GitHub Pages**: GitHub Insights
- **Netlify**: 内置分析
- **Vercel**: 内置分析 + Google Analytics

### 性能监控：
- [Google PageSpeed Insights](https://pagespeed.web.dev/)
- [WebPageTest](https://www.webpagetest.org/)

## 💡 高级功能

### CDN加速：
- Cloudflare免费CDN（推荐）
- 配置方法：将域名NS记录指向Cloudflare

### 自定义404页面：
在 `docs/404.html` 创建自定义404页面

### 重定向：
- `docs/_redirects` (Netlify)
- `vercel.json` (Vercel)

## 🆘 故障排除

### 常见问题：

**域名不生效**：
- 等待DNS传播（可能需要24小时）
- 检查DNS设置是否正确
- 清除浏览器缓存

**HTTPS不工作**：
- 确保DNS完全生效
- 检查GitHub Pages的"Enforce HTTPS"设置

**网站加载慢**：
- 使用CDN加速
- 优化图片大小
- 启用压缩

## 🎉 完成后的URL：

- `https://冰箱.app`
- `https://fridge-food.com`
- `https://bingxiang.app`

---

**🚀 拥有自定义域名后，你的应用看起来更加专业和可信！**