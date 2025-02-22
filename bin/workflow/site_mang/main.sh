#!/bin/bash

# 定义 hello 变量的默认值
url_name="autohotkey"

# 显示帮助信息的函数
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "This script open the url give using chrome"
    echo "Options:"
    echo "Example:"
    echo "  $0 google"
    exit 1
}

# 检查是否提供了参数
if [ $# -eq 0 ]; then
    show_help
fi

# 检查是否提供了除帮助参数之外的其他参数
if [ $# -gt 1 ]; then
    echo "Error: Too many arguments."
    show_help
fi

# 如果提供了参数，将其赋值给 hello 变量
if [ $# -eq 1 ]; then
    url_name="$1"
fi

# 打印 hello 变量的内容
eval "./url_mang.sh -G $url_name | ./open_site.sh"
