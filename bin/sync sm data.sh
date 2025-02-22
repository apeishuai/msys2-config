#!/bin/bash

# 设置 UTF-8 编码
export LANG="en_US.UTF-8"

# 原始版本路径
original_versions_path="G:/config and meta_data/sm data version"

# 获取当前日期和时间，作为版本信息
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

# 子目录名为版本信息
subdirectory="${timestamp}"

# 修改后的版本路径，追加子目录
versions_path="${original_versions_path}/${subdirectory}"

# 从参数中获取文件夹路径
folder_path="E:\\sm18-lazy-package-main\\sm18\\systems"

# 首先确保需要存储文件的目录存在
output_path="${versions_path}"
mkdir -p "$output_path" || exit 1

# 检查目标文件是否正在被使用
if lsof +D "${versions_path}" >/dev/null 2>&1; then
  echo "目标文件正在被使用，无法复制文件。"
  exit 1
fi

# 递归复制文件夹中的所有文件和文件夹到目标文件夹
cp -R "$folder_path" "$versions_path"