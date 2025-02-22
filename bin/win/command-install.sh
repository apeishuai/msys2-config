#!/bin/bash

# 定义软件包名称列表
packages=(
          "vim"
	  "mingw-w64-x86_64-ffmpeg"
	  "dialog"
	  "mingw-w64-x86_64-spdlog"
	  "mingw-w64-x86_64-emacs"
	  "git"
	  "rga"
  )

# 循环遍历软件包列表中的每个软件包名称
for package in "${packages[@]}"; do
    # 检查软件包是否已经安装
    if pacman -Qq $package > /dev/null 2>&1; then
        echo "$package is already installed, skipping..."
    else
        # 安装软件包
        echo "Installing $package..."
        pacman -S --noconfirm $package

        # 检查软件包是否成功安装
        if [ $? -ne 0 ]; then
            echo "Error: Failed to install $package"
            exit 1
        fi
    fi
done
