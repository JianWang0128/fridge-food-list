#!/bin/bash
echo "========================================"
echo "推送冰箱食物清单到GitHub"
echo "========================================"
echo ""

# 检查参数
if [ $# -lt 2 ]; then
    echo "用法: $0 <GitHub用户名> <仓库名>"
    echo ""
    echo "示例:"
    echo "  $0 janedoe 冰箱清单"
    echo "  $0 janedoe fridge-app"
    echo ""
    echo "这会将代码推送到: https://github.com/用户名/仓库名"
    exit 1
fi

USERNAME=$1
REPO_NAME=$2
REPO_URL="https://github.com/$USERNAME/$REPO_NAME.git"

echo "GitHub用户名: $USERNAME"
echo "仓库名: $REPO_NAME"
echo "仓库URL: $REPO_URL"
echo ""

# 检查是否已经有远程仓库
if git remote get-url origin >/dev/null 2>&1; then
    echo "🔄 更新现有远程仓库..."
    git remote set-url origin $REPO_URL
else
    echo "🔗 添加远程仓库..."
    git remote add origin $REPO_URL
fi

# 设置分支
echo "📍 设置主分支..."
git branch -M main

# 推送代码
echo "📤 推送代码到GitHub..."
if git push -u origin main; then
    echo ""
    echo "✅ 推送成功！"
    echo ""
    echo "🌐 仓库地址: https://github.com/$USERNAME/$REPO_NAME"
    echo ""
    echo "📋 接下来的步骤："
    echo "1. 打开上面的仓库链接"
    echo "2. 点击 Settings → Pages"
    echo "3. Source 选择 'Deploy from a branch'"
    echo "4. Branch 选择 'main'，文件夹选择 '/docs'"
    echo "5. 点击 Save"
    echo ""
    echo "⏱️ 等待几分钟，你的网站就会在以下地址可用："
    echo "   🌐 https://$USERNAME.github.io/$REPO_NAME"
    echo ""
    echo "📱 测试网站："
    echo "   - 电脑: https://$USERNAME.github.io/$REPO_NAME"
    echo "   - 手机: 在浏览器中打开上面的地址"
    echo ""
    echo "🔄 更新代码时，运行："
    echo "   ./deploy_github.sh $USERNAME $REPO_NAME"
else
    echo ""
    echo "❌ 推送失败！可能的原因："
    echo "1. 仓库不存在 - 请先在GitHub上创建仓库"
    echo "2. 权限问题 - 检查仓库是否为公开的"
    echo "3. 网络问题 - 检查网络连接"
    echo ""
    echo "💡 解决方案："
    echo "1. 确认仓库存在: https://github.com/$USERNAME/$REPO_NAME"
    echo "2. 确认仓库是公开的 (Public)"
    echo "3. 重试命令: $0 $USERNAME $REPO_NAME"
fi