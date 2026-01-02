#!/bin/bash
echo "🔍 检查域名可用性"
echo "=================="
echo ""

# 检查参数
if [ $# -eq 0 ]; then
    echo "用法: $0 <域名>"
    echo "示例: $0 bingxiang.app"
    echo ""
    echo "建议域名："
    echo "  bingxiang.app"
    echo "  fridge-food.com"
    echo "  冰箱清单.com"
    echo "  fridge-list.app"
    exit 1
fi

DOMAIN=$1

echo "检查域名: $DOMAIN"
echo ""

# 使用whois检查域名状态
echo "📡 查询域名状态..."
whois $DOMAIN | grep -E "(Domain Status|Creation Date|Registry Domain ID|Name Server)" | head -10

echo ""
echo "💡 如何购买域名："
echo "   1. Namecheap: https://www.namecheap.com"
echo "   2. Porkbun: https://porkbun.com"
echo "   3. GoDaddy: https://www.godaddy.com"
echo ""

echo "💰 预期价格："
echo "   .com: \$10-15/年"
echo "   .app: \$8-12/年"
echo "   .中国: 约¥50/年"
echo ""

echo "⚡ 快速设置："
echo "   购买后运行: ./setup_custom_domain.sh $DOMAIN 你的GitHub用户名 仓库名"