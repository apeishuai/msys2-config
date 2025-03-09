@echo off

REM Get the user profile path for the main computer user
for /f "tokens=2 delims==" %%a in ('wmic useraccount where name="%username%" get sid /value') do set sid=%%a
set "sid=%sid:~0,-18%"
set "userprofile=C:\Users\%username%"

REM Update environment variables
setx MSYS2_PATH_TYPE "inherit"
setx EMACS_SERVER_FILE "C:\msys64\home\dell\.emacs.d\server\server"
setx DEEPSEEK_API_KEY "sk-b7e87905e33b4bc28d2de1f790f7ad2c"
setx EMACS_SERVER_FILE "C:\msys64\home\dell\.emacs.d\server\server"
setx SCOOP "D:\Softwares\scoop"
setx USERSCOOP "D:\softwares\scoop"
setx NODE_PATH "D:\softwares\msys64\home\whens\node_modules"
setx PATH "D:\softwares-work\qt6\Tools\QtDesignStudio\qt6_design_studio_reduced_version\bin;D:\softwares\msys64\home\whens;D:\softwares\msys64\home\whens\bin;D:\softwares\scoop\shims;D:\softwares\IDA_Pro\IDA Pro 8.3 (x86, x86_64);D:\softwares\Microsoft VS Code;D:\qt6.8.2\6.8.2\mingw_64\bin;D:\qt6.8.2\6.8.2\mingw_64;D:\qt6.8.2\Tools\mingw1310_64\bin;D:\qt6.8.2\Tools\CMake_64\bin;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.43.34808\bin\Hostx64\x86;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools"
exit
