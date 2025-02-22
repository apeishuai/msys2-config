查看代理
netsh winhttp show proxy 1
curl --proxy http://127.0.0.1:7890 www.google.com
检测端口是否打开
curl -v 127.0.0.1:22
查看当前ip
curl ip.gs
查看全局环境变量
set | gerp abc

检查服务是否启用\nsystemctl list-unit-files | grep enable | grep ssh

# download youtube vedio and subtitle
yt_down url

# dot编译思维导图
dot xx.dot -Tpng -o a.png && start a.png



# 转码webm为mp4
ffmpeg -i video.webm -crf 17 -c:v libx264 video.mp4



# 网站管理
workflow/url_mang 管理url地址
workflow/open_site 打开具体的url地址
