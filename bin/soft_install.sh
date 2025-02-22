#rm -rf $HOME/.config/fcitx
#sudo apt install fcitx-rime librime-*

#1 系统初始化
#换源，常用的服务


#pdf阅读器 zathura


#2 软件包管理策略
#维护一张列表，列表中包含常用的软件
#basic: ibus-rime google-chrome emacs vim ledger 
#special: 

#3 开发环境搭建
#gcc g++ link 《深入理解计算机系统》实现一遍


#4 以上三者的脚本编写


#shurufa

#程序包管理工具
#sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak



#sudo echo -ne "# See https://www.kali.org/docs/general-use/kali-linux-sources-list-repositories/  6 ⚙
#deb http://http.kali.org/kali kali-rolling main contrib non-free
# Additional line for source packages
# deb-src http://http.kali.org/kali kali-rolling main contrib non-free
#deb https://mirrors.aliyun.com/kali kali-rolling main non-free contrib
#deb-src https://mirrors.aliyun.com/kali kali-rolling main non-free contrib
#deb http://http.kali.org/kali kali-rolling main non-free contrib
#deb-src http://http.kali.org/kali kali-rolling main non-free contrib
#deb https://apt.atzlinux.com/atzlinux buster main contrib non-free
#" > /etc/apt/sources.list


#sudo apt update

#dependy install and other
#sudo apt autoremove



#---------------------------
#install 输入法rime
#sudo apt-get install ibus-rime -y

#remove rime
#sudo remove ibus
#sudo purge ibus
#sudo autoremove --purge ibus
#---------------------------

#---------------------------
#install Google-chrome
#sudo apt-get purge google-chrome-stable 
#sudo rm -rf ~/.config/google-chrome/

#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#dpkg -i google-xxx
#apt-get -f install
#vim .bashrc  /home/root
#export PATH=/opt/google/chrome:$PATH
#source .bashrc
#google-chrome --no-sandbox
#---------------------------


#-----------------------------
#account ledger
#sudo apt-get install ledger
#-----------------------------

#文献 jabref
#sudo apt --fix-broken install
#sudo apt-get install jabref

#pdf工具 pdftk
#sudo apt-get install pdftk -y

#工具 google搜索文本版
#sudo apt-get install googler

#邮件 mu
#安装依赖项
#sudo apt-get install libgmime-3.0-dev libxapian-dev -y
#sudo apt install build-essential
#sudo apt install meson ninja-build

#安装 mu
#cd ~/shuai-files/softwares/ && git clone git://github.com/djcb/mu.git && cd mu && ./autogen.sh && make

#安装mbsync
#sudo apt-get install isync

#tldr too long don`t read
#sudo pip install tldr
