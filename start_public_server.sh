#!/bin/bash
echo "启动冰箱食物清单Web服务器和公网tunnel..."
echo "这将创建一个可从任何设备访问的公网址"
echo ""

# 启动Web服务器
echo "启动本地Web服务器..."
cd "$(dirname "$0")/build/web"
npx serve -l 3000 -s &
SERVER_PID=$!

# 等待服务器启动
sleep 3

# 启动localtunnel
echo "创建公网tunnel..."
lt --port 3000 &
TUNNEL_PID=$!

echo ""
echo "服务器正在运行！"
echo "本地访问: http://localhost:3000"
echo "公网访问: 等待tunnel URL..."
echo ""
echo "按 Ctrl+C 停止所有服务"

# 等待用户中断
trap "kill $SERVER_PID $TUNNEL_PID 2>/dev/null; exit" INT
wait