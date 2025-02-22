; main.ahk - 主脚本，激活不同软件的快捷键配置，并增加注册表的增删改查及打印操作

; 初始化注册表
config := map()
config["plc"] := map("path", "C:\\Path\\To\\PLC_Editor.exe", "hotkeys", "PLC_Editor.ahk")

; 打印注册表内容
!r::PrintConfig()

; 列出所有软件并提供选择运行的快捷键
#h:: {
    global config
    output := "已注册的软件:`n"
    for key in config {
        output .= "Alt+" SubStr(key, 1, 2) ": 运行 " key "`n"
    }
    MsgBox output
}

; 打印注册表
PrintConfig() {
    global config
    output := "当前注册表内容:`n"
    for key, value in config {
        output .= key ": 路径 = " value.path ", 快捷键表 = " value.hotkeys "`n"
    }
    MsgBox output
}

/*
; 定义激活配置的函数
ActivateConfig(type) {
    global config
    if config.Has(type) {
        hotkeysFile := config[type].hotkeys
        if FileExist(hotkeysFile) {
            fileContent := FileRead(hotkeysFile)
            loadHotkeys(fileContent)
            MsgBox "激活配置: " type
        } else {
            MsgBox "无法打开快捷键文件: " hotkeysFile
        }
    } else {
        MsgBox "无效的配置类型: " type
    }
}

; 运行软件并激活其快捷键表
RunSoftware(type) {
    global config
    if config.Has(type) {
        Run config[type].path
        Sleep 1000  ; 等待软件启动
        ActivateConfig(type)
    } else {
        MsgBox "无效的软件类型: " type
    }
}


; 增加注册表条目
AddConfig(key, path, hotkeys) {
    global config
    if config.Has(key) {
        MsgBox "配置键 " key " 已存在。"
    } else {
        config[key] := {path: path, hotkeys: hotkeys}
        MsgBox "已增加配置键 " key "，路径为 " path "，快捷键表为 " hotkeys "。"
    }
}

; 删除注册表条目
DeleteConfig(key) {
    global config
    if config.Has(key) {
        config.Delete(key)
        MsgBox "已删除配置键 " key "。"
    } else {
        MsgBox "配置键 " key " 不存在。"
    }
}

; 修改注册表条目
ModifyConfig(key, newPath, newHotkeys) {
    global config
    if config.Has(key) {
        config[key] := {path: newPath, hotkeys: newHotkeys}
        MsgBox "已修改配置键 " key "，新路径为 " newPath "，新快捷键表为 " newHotkeys "。"
    } else {
        MsgBox "配置键 " key " 不存在。"
    }
}


; 查询注册表条目
QueryConfig(key) {
    global config
    if config.Has(key) {
        MsgBox "配置键 " key " 的路径为 " config[key].path "，快捷键表为 " config[key].hotkeys "。"
    } else {
        MsgBox "配置键 " key " 不存在。"
    }
}


; 打印注册表
PrintConfig() {
    global config
    output := "当前注册表内容:`n"
    for key, value in config {
        output .= key ": 路径 = " value.path ", 快捷键表 = " value.hotkeys "`n"
    }
    MsgBox output
}

; 打印帮助内容
PrintHelp() {
    global config
    output := "以下是所有正在运行脚本的快捷键及其说明:`n`n"
    output .= "Alt+P: 增加注册表条目`n"
    output .= "Alt+D: 删除注册表条目`n"
    output .= "Alt+M: 修改注册表条目`n"
    output .= "Alt+Q: 查询注册表条目`n"
    output .= "Alt+R: 打印注册表内容`n"
    output .= "Win+H: 列出所有软件并提供选择运行的快捷键`n`n"
    output .= "已注册的软件:`n"
    for key in config {
        output .= "Alt+" SubStr(key, 1, 2) ": 运行 " key "`n"
    }
    MsgBox output
}


; 加载并执行热键配置文件
loadHotkeys(fileContent) {
    Eval(fileContent)
}

; 处理参数
if (A_Args.Length() = 0) {
    PrintHelp()
}

; 定义快捷键

; 增加注册表条目
!p:: {
    key := InputBox("请输入配置键：")
    if key {
        path := InputBox("请输入软件路径：")
        if path {
            hotkeys := InputBox("请输入快捷键表路径：")
            if hotkeys
                AddConfig(key, path, hotkeys)
        }
    }
}

; 删除注册表条目
!d:: {
    key := InputBox("请输入要删除的配置键：")
    if key
        DeleteConfig(key)
}

; 修改注册表条目
!m:: {
    key := InputBox("请输入要修改的配置键：")
    if key {
        newPath := InputBox("请输入新的软件路径：")
        if newPath {
            newHotkeys := InputBox("请输入新的快捷键表路径：")
            if newHotkeys
                ModifyConfig(key, newPath, newHotkeys)
        }
    }
}

; 查询注册表条目
!q:: {
    key := InputBox("请输入要查询的配置键：")
    if key
        QueryConfig(key)
}

; 打印注册表内容
!r::PrintConfig()

; 列出所有软件并提供选择运行的快捷键
#h:: {
    global config
    output := "已注册的软件:`n"
    for key in config {
        output .= "Alt+" SubStr(key, 1, 2) ": 运行 " key "`n"
    }
    MsgBox output
}

; 动态生成 Alt+XX 快捷键运行软件
for key, value in config {
    hotkey := "!" . SubStr(key, 1, 2)
    Hotkey(hotkey, Func("RunSoftware").Bind(key))
}
*/
