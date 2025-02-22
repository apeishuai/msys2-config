#!/bin/bash

# 指定视频文件夹路径
video_dir="F:/wxf/vedio"

# 遍历视频文件夹中的所有视频文件
for video_file in "$video_dir"/*.mp4; do
  # 获取视频文件名（不包括扩展名）
  video_name=$(basename "$video_file" .mp4)

  # 创建输出图片文件夹
  output_dir="$video_dir/$video_name"
  mkdir -p "$output_dir"

  # 将视频输出为每秒 60 张图片
  ffmpeg -i "$video_file" -vf  "thumbnail,scale=1920:1080" -q:v 1 -frame_pts 1 -r 60/60 -ss 00:00:00 -to 00:10:00 "$output_dir/image-%04d.jpg"
done
