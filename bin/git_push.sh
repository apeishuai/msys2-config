#!/bin/bash
# 脚本名称：git_push.sh
# 用途：定时执行git push操作

cd ~

if ! git diff-index --quiet HEAD --; then
    git add .
    git commit -m "auto_push time: $(date +'%Y-%m-%d %H:%M:%S')"
fi

git push origin master
