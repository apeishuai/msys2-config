#!/bin/bash

packages=(
          "vim"
	  "mingw-w64-x86_64-ffmpeg"
	  "mingw-w64-x86_64-spdlog"
	  "git"
	  "emacs"
  )
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



software_list=(
	"autohotkey"
	"croc"
	"graphviz"
	"keyviz"
	"nodejs"
	"ollydbg"
	"pandoc"
	"rga"
	"ripgrep"
	"wireshark"
	"yt-dlp"
	"anaconda3"
)
for app in "${software_list[@]}"; do
    scoop install "$app"
done
