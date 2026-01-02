#!/bin/bash
echo "========================================"
echo "冰箱食物清单 - GitHub Pages 部署脚本"
echo "========================================"
echo ""

# 检查参数
if [ $# -lt 2 ]; then
    echo "用法: $0 <GitHub用户名> <仓库名>"
    echo "例如: $0 myusername fridge-app"
    echo ""
    echo "这将创建URL: https://myusername.github.io/fridge-app"
    exit 1
fi

USERNAME=$1
REPO_NAME=$2
REPO_URL="https://github.com/$USERNAME/$REPO_NAME.git"

echo "GitHub用户名: $USERNAME"
echo "仓库名: $REPO_NAME"
echo "仓库URL: $REPO_URL"
echo "最终URL: https://$USERNAME.github.io/$REPO_NAME"
echo ""

# 重新构建Web版本
echo "🔄 重新构建Web版本..."
flutter build web --release --base-href="/$REPO_NAME/"

# 复制到docs文件夹
echo "📁 更新docs文件夹..."
rm -rf docs/*
cp -r build/web/* docs/

# 添加到git
echo "📝 提交更改..."
git add docs/
git commit -m "Update web build $(date)"

# 检查远程仓库
if git remote get-url origin >/dev/null 2>&1; then
    echo "🔄 推送到现有仓库..."
    git push origin main
else
    echo "🔗 添加远程仓库..."
    git remote add origin $REPO_URL
    git branch -M main
    git push -u origin main
fi

echo ""
echo "✅ 部署完成！"
echo "🌐 访问地址: https://$USERNAME.github.io/$REPO_NAME"
echo ""
echo "📋 接下来的步骤："
echo "1. 打开 https://github.com/$USERNAME/$REPO_NAME"
echo "2. 点击 Settings → Pages"
echo "3. Source 选择 'Deploy from a branch'"
echo "4. Branch 选择 'main'，文件夹选择 '/docs'"
echo "5. 保存设置"
echo ""
echo "⏱️ 等待几分钟，网站就会在上面显示的URL上可用！"