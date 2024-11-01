if [ "$(uname)" == "Linux" ]; then
    home=~
    source ~/.bashrc_comm
    source ~/.bashrc_linux
elif [ -n "$MSYSTEM" ] && [ "$MSYSTEM" == "MSYS" ]; then
    home=D:/softwares/msys64/home/whens
    source ~/.bashrc_comm
    source ~/.bashrc_win
fi
