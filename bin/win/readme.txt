#该脚本切换WLAN适配器的ipv4手动分配ip和自动分配ip模式

1 管理员身份打开powershell，执行set_ipv4_xxx.ps1
2 set_ipv4_manual和set_ipv4_auto交替，即执行完manual后执行auto，同时执行两个manual不起效
3 auto执行完后断开wifi连接重连

netsh winsock reset
