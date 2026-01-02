#!/bin/bash
echo "========================================"
echo "冰箱食物清单 - 自定义域名设置助手"
echo "========================================"
echo ""

# 检查参数
if [ $# -lt 1 ]; then
    echo "用法: $0 <你的域名> [GitHub用户名] [仓库名]"
    echo ""
    echo "示例:"
    echo "  $0 bingxiang.app janedoe 冰箱清单"
    echo "  $0 fridge-food.com"
    echo ""
    echo "这将为你配置自定义域名"
    exit 1
fi

DOMAIN=$1
GITHUB_USER=${2:-"yourusername"}
GITHUB_REPO=${3:-"fridge-food-list"}

echo "域名: $DOMAIN"
echo "GitHub用户: $GITHUB_USER"
echo "GitHub仓库: $GITHUB_REPO"
echo ""

echo "📋 请按以下步骤操作："
echo ""

echo "1️⃣ 购买域名："
echo "   推荐: https://www.namecheap.com"
echo "   搜索域名: $DOMAIN"
echo "   价格约: \$8-12/年"
echo ""

echo "2️⃣ 配置DNS记录："
echo "   登录域名注册商，设置以下A记录："
echo ""
echo "   类型: A     主机: @     值: 185.199.108.153"
echo "   类型: A     主机: @     值: 185.199.109.153"
echo "   类型: A     主机: @     值: 185.199.110.153"
echo "   类型: A     主机: @     值: 185.199.111.153"
echo ""

echo "3️⃣ 配置GitHub Pages："
echo "   打开: https://github.com/$GITHUB_USER/$GITHUB_REPO/settings/pages"
echo "   Custom domain: $DOMAIN"
echo "   勾选: Enforce HTTPS"
echo "   保存"
echo ""

echo "4️⃣ 验证设置："
echo "   等待5-10分钟"
echo "   访问: https://$DOMAIN"
echo ""

echo "✅ 完成！你的自定义域名将是："
echo "   🌐 https://$DOMAIN"
echo ""

echo "🔄 更新应用时，运行："
echo "   ./deploy_github.sh $GITHUB_USER $GITHUB_REPO"
echo ""

echo "📱 移动端访问："
echo "   iOS Safari: 分享 → 添加到主屏幕"
echo "   Android Chrome: 菜单 → 添加到主屏幕"
echo ""

echo "💡 提示："
echo "   - DNS传播可能需要24小时"
echo "   - 如果域名不生效，检查DNS设置"
echo "   - 可以使用 https://dnschecker.org 验证DNS"