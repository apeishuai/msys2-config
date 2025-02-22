#!/bin/bash

# Set the system environment variable list
SYS_ENV_VARS=(
	""
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

# Call the system batch file
cmd /c update_sys_env.bat
Remove the tmp files
rm update_sys_env.bat

# Set the user environment variable list
USER_ENV_VARS=(
  "MSYS2_PATH_TYPE=inherit"
  "EMACS_SERVER_FILE=C:\msys64\home\dell\.emacs.d\server\server"
  "NODE_PATH=D:\softwares\msys64\home\whens\node_modules"
  "PATH=D:\softwares-work\qt6\Tools\QtDesignStudio\qt6_design_studio_reduced_version\bin"
  "PATH=D:\softwares\msys64\home\whens"
  "PATH=D:\softwares\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.42.34433\bin\Hostx64\x64"
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

# Call the batch file with cmd.exe
cmd.exe /c update_user_env.bat

# Remove the tmp files
rm update_user_env.bat
