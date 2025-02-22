#!/bin/bash

# 列出所有可用指令，并统计数量
commands=$(compgen -c)
count=$(echo "$commands" | wc -l)

# 筛选出 MSYS2 自带的指令
msys_commands=$(pacman -Ql msys2-runtime | grep "/bin/" | awk '{print $2}' | xargs basename -a)
msys_count=$(echo "$msys_commands" | wc -l)

# 输出指令数量和列表
echo "There are $count commands available in the MSYS2 environment:"
echo "$commands"

# 输出 MSYS2 自带的指令数量和列表
echo "Among them, $msys_count commands are provided by MSYS2:"
echo "$msys_commands"

# 输出非 MSYS2 自带的指令到 1.txt 文件
echo "Non-MSYS2 commands:" > 1.txt
echo "$commands" | grep -vFxf <(echo "$msys_commands") >> 1.txt
