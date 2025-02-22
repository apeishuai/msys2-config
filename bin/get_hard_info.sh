#!/bin/bash

# 获取操作系统信息
os_name=$(uname -s)
os_version=$(uname -r)
os_architecture=$(uname -m)

echo "操作系统信息:"
echo "名称: $os_name"
echo "版本: $os_version"
echo "架构: $os_architecture"

# 获取操作系统型号
os_model=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d "=" -f 2 | tr -d '"')

echo -e "\n操作系统型号:"
echo "$os_model"

# 获取CPU信息
cpu_info=$(lscpu | grep "Model name" | awk -F': ' '{print $2}')
cpu_cores=$(lscpu | grep "Core(s) per socket" | awk -F': ' '{print $2}')
cpu_threads=$(lscpu | grep "Thread(s) per core" | awk -F': ' '{print $2}')

echo -e "\nCPU信息:"
echo "处理器: $cpu_info"
echo "物理核心数: $cpu_cores"
echo "线程数: $cpu_threads"

# 获取内存信息
mem_info=$(free -h | grep "Mem" | awk '{print $2,$3,$4}')
mem_usage=$(free -h | grep "Mem" | awk '{print $3/$2 * 100}')

echo -e "\n内存信息:"
echo "总内存: $mem_info"
echo "内存使用率: $mem_usage%"

# 获取磁盘信息
disk_info=$(df -h | awk '$NF=="/"{print $2,$3,$4,$5}')
disk_usage=$(df -h | awk '$NF=="/"{print $5}')

echo -e "\n磁盘信息:"
echo "总磁盘空间: $disk_info"
echo "磁盘使用率: $disk_usage"
