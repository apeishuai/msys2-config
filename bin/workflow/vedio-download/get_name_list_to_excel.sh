#!/bin/bash

# 要重命名的文件夹路径
directory="C:/Users/dell/Desktop/2"


# 获取文件夹下所有文件名
filenames=$(ls "$directory")

# 将文件名列表转换为CSV格式
csv=""
for filename in $filenames
do
  csv="$csv$filename\n"
done

# 将CSV格式保存为Excel表格
echo -e "$csv" | tr '\n' '\r' | awk '{print $0}' RS='\r' ORS='\r\n' >  "C:/Users/dell/Desktop/xx.xlsx"
