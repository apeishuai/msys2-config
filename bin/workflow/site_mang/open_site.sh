#!/bin/bash

# 硬编码 Chrome 浏览器的路径（Windows 示例）
CHROME_PATH="C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"

# 显示帮助信息的函数
show_help() {
    echo "Usage: $0"
    echo "This script opens a URL in Google Chrome."
    echo "The URL should be provided through stdin using a pipe."
    echo "Example: echo 'http://www.example.com' | $0"
    echo ""
    echo "Chrome Path: $CHROME_PATH"
    exit 1
}

# 检查 Chrome 路径是否存在
if [ ! -f "$CHROME_PATH" ]; then
    echo "Error: Chrome browser not found at $CHROME_PATH."
    show_help
fi

# 从标准输入读取 URL
if [ -p /dev/stdin ]; then
    read -r url
    # 检查 URL 是否包含 "Error" 字符串
    if [[ "$url" == *"Error"* ]]; then
        echo "Error: The provided string contains 'Error', which is not allowed."
    elif [ -z "$url" ]; then
        echo "Error: No URL provided through stdin."
        show_help
    else
        # 使用 Chrome 打开网站
        "$CHROME_PATH" "$url"
    fi
else
    echo "Error: Stdin is not a pipe. Please provide a URL through a pipe."
    show_help
fi
