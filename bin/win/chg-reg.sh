#!/bin/bash

# 使用 cmd 执行 reg add 命令
cmd /c "reg add HKEY_CLASSES_ROOT\org-protocol\shell\open /v \"command\" /t REG_SZ /d \"\\\"C:\\msys64\\mingw64\\bin\\emacsclientw.exe\\\" \\\"%1\\\"\" /f"
