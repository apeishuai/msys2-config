#!/bin/bash

# 设置默认文件夹路径
default_folder="F:/wxf/vedio"

# 获取输入的 Bilibili 视频 URL
read -p "请输入要下载的 Bilibili 视频 URL：" url

# 使用 yt-dlp 下载视频并保存到默认文件夹中
yt-dlp -o "$default_folder/%(title)s.%(ext)s" "$url"
