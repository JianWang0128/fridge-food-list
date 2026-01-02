#!/bin/bash
echo "启动冰箱食物清单Web服务器..."
echo "访问地址: http://localhost:8080"
echo "按 Ctrl+C 停止服务器"
echo ""

cd "$(dirname "$0")/build/web"
python3 -m http.server 8080