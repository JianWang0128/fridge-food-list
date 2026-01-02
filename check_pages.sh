#!/bin/bash
echo "========================================"
echo "检查GitHub Pages设置"
echo "========================================"
echo ""

echo "🔍 请按以下步骤检查和配置GitHub Pages："
echo ""

echo "1️⃣ 打开仓库设置："
echo "   访问: https://github.com/JianWang0128/fridge-food-list/settings/pages"
echo ""

echo "2️⃣ 检查当前设置："
echo "   - Source 应该是: 'Deploy from a branch'"
echo "   - Branch 应该是: 'main' /docs"
echo ""

echo "3️⃣ 如果设置不正确，请修改为："
echo "   - Source: Deploy from a branch"
echo "   - Branch: main"
echo "   - Folder: /docs"
echo "   - 勾选: Enforce HTTPS"
echo ""

echo "4️⃣ 保存设置"
echo ""

echo "5️⃣ 等待部署（2-3分钟）"
echo ""

echo "6️⃣ 测试网站："
echo "   🌐 https://jianwang0128.github.io/fridge-food-list"
echo ""

echo "💡 如果还是显示README："
echo "   - 确认docs文件夹有正确的index.html文件"
echo "   - 检查GitHub Pages状态（绿色勾选）"
echo "   - 尝试刷新浏览器（Ctrl+F5）"
echo ""

echo "🔧 如果需要重新部署，运行："
echo "   ./deploy_github.sh JianWang0128 fridge-food-list"
echo ""

echo "📞 如果仍有问题，请截图GitHub Pages设置页面给我看"