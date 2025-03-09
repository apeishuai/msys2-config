#!/bin/bash

# Set the system environment variable list
SYS_ENV_VARS=(
	"INCLUDE=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.43.34808\include"
	"DLL=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.43.34808\lib\x64"
)

# Create the system batch file
cat > update_sys_env.bat << EOF
@echo off
REM Update system environment variables
EOF

for env_var in "${SYS_ENV_VARS[@]}"
do
  var_name="${env_var%=*}"
  var_value="${env_var#*=}"
  echo "setx $var_name \"$var_value\" /M" >> update_sys_env.bat
done
echo "exit" >> update_sys_env.bat

if [ -f update_sys_env.bat ]; then
	start update_sys_env.bat
fi

if [$? -eq 0];then
	rm update_sys_env.bat
fi


# Set the user environment variable list
USER_ENV_VARS=(
  "MSYS2_PATH_TYPE=inherit"
  "EMACS_SERVER_FILE=C:\msys64\home\dell\.emacs.d\server\server"
  "DEEPSEEK_API_KEY=sk-b7e87905e33b4bc28d2de1f790f7ad2c"
  "EMACS_SERVER_FILE=C:\msys64\home\dell\.emacs.d\server\server"
  "SCOOP=D:\Softwares\scoop"
  "USERSCOOP=D:\softwares\scoop"
  "NODE_PATH=D:\softwares\msys64\home\whens\node_modules"
  "PATH=D:\softwares-work\qt6\Tools\QtDesignStudio\qt6_design_studio_reduced_version\bin;D:\softwares\msys64\home\whens;D:\softwares\msys64\home\whens\bin;D:\softwares\scoop\shims;D:\softwares\IDA_Pro\IDA Pro 8.3 (x86, x86_64);D:\softwares\Microsoft VS Code;D:\qt6.8.2\6.8.2\mingw_64\bin;D:\qt6.8.2\6.8.2\mingw_64;D:\qt6.8.2\Tools\mingw1310_64\bin;D:\qt6.8.2\Tools\CMake_64\bin;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.43.34808\bin\Hostx64\x86;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools"
)

# Create the batch file
cat > update_user_env.bat << EOF
@echo off

REM Get the user profile path for the main computer user
for /f "tokens=2 delims==" %%a in ('wmic useraccount where name="%username%" get sid /value') do set sid=%%a
set "sid=%sid:~0,-18%"
set "userprofile=C:\Users\%username%"

REM Update environment variables
EOF

for env_var in "${USER_ENV_VARS[@]}"
do
  var_name="${env_var%=*}"
  var_value="${env_var#*=}"
  echo "setx $var_name \"$var_value\"" >> update_user_env.bat
done
echo "exit" >> update_user_env.bat

if [ -f update_user_env.bat ]; then
	start update_user_env.bat
fi

if [$? -eq 0];then
	rm update_user_env.bat
fi
