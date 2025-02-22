#!/bin/bash

# 设置包含DLL文件的目录路径
directoryPath="G:/ET-5"

# 检查rcedit是否存在
if ! command -v rcedit-x64 &> /dev/null
then
    echo "rcedit could not be found, please install it first."
    exit
fi

# 遍历目录下的所有DLL文件
find "$directoryPath" -type f -name "*.dll" | while read -r file; do
    echo "Processing file: $file"
    # 使用rcedit修改DLL文件中的资源字符串
    rcedit-x64 "$file" --set-version-string "VSCAN" "test"
done

echo "All DLL files have been processed."
