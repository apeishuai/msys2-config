if [ "$(uname)" == "Linux" ]; then
    root=/home/shuai
    source ~/.bashrc_comm
    source ~/.bashrc_linux
elif [ -n "$MSYSTEM" ] && [ "$MSYSTEM" == "MSYS" ]; then
    root=/g/area
    serv_root=/d/main/serve
    source ~/.bashrc_comm
    source ~/.bashrc_win
fi
