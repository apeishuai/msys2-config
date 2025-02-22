@echo off
setlocal enabledelayedexpansion

REM 获取当前目录路径
set "folder=%CD%"

REM 遍历当前文件夹下的所有 XHTML 文件并打开
for %%F in ("%folder%\*.xhtml") do (
    set "file=%%~fF"
    echo !file!
    start "" iexplore.exe "!file!"
    timeout /t 1 /nobreak >nul
)

endlocal