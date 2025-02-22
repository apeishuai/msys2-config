#!/bin/bash

# 文件名常量
WEBSITE_FILE="websites.txt"
GROUP_FILE="groups.txt"

# 网站 URL 字典和网站分组数组
declare -A website_urls
declare -gA groups

# 显示帮助信息的函数
show_help() {
    echo "Usage: $0 {-a|-u|-d|-l|-g|-A|-D|-L|-I|-G} [options]"
    echo "  -a name url [group]   Add or update a website, optionally specify a group"
    echo "  -u name               Remove a website"
    echo "  -d name url           Update a website's URL"
    echo "  -l                    List all websites"
    echo "  -g group              Remove a group"
    echo "  -A name group         Add a website to a group"
    echo "  -D name group         Remove a website from a group"
    echo "  -L                    List all groups"
    echo "  -I                    Initialize or reset the data files"
    echo "  -G                    Get the url of website"
    exit 1
}

# 函数：初始化数据
initialize_data() {
    if [ ! -f "$WEBSITE_FILE" ] || [ ! -f "$GROUP_FILE" ]; then
        touch "$WEBSITE_FILE" "$GROUP_FILE"
    fi
    load_websites
    load_groups
}

# 函数：加载网站信息
load_websites() {
    if [ -f "$WEBSITE_FILE" ]; then
        while IFS='=' read -r name url; do
            website_urls["$name"]="$url"
        done < "$WEBSITE_FILE"
    fi
}

# 函数：加载分组信息
load_groups() {
    if [ -f "$GROUP_FILE" ]; then
        while IFS='=' read -r group names; do
            groups["$group"]="$names"
        done < "$GROUP_FILE"
    fi
}

# 函数：添加或更新网站，并可选地指定分组
add_or_update_website() {
    local name=$1
    local url=$2
    local group=${3:-inbox} # 如果没有提供分组，则默认为 'inbox'

    website_urls["$name"]="$url"

    if [[ -z "${groups[$group]}" ]]; then
        groups["$group"]="$name"
    else
        groups["$group"]="${groups[$group]} $name"
    fi

    save_websites
    save_groups
}

# 函数：移除网站
remove_website() {
    local name=$1
    unset website_urls["$name"]
    for group_name in "${!groups[@]}"; do
        groups["$group_name"]=${groups["$group_name"]// $name}
    done
    save_websites
    save_groups
}

# 函数：更新网站 URL
update_website() {
    local name=$1
    local url=$2
    add_or_update_website "$name" "$url"
}

# 函数：列出所有网站
list_websites() {
    for name in "${!website_urls[@]}"; do
        echo "${name}: ${website_urls[$name]}"
    done
    echo
}

# 函数：添加网站到分组
add_to_group() {
    local name=$1
    local group=$2
    if [[ -n "${website_urls[$name]}" ]] && [[ -n "${groups[$group]}" ]]; then
        groups["$group"]="${groups[$group]} ${name}"
        save_groups
    else
        echo "Error: Website '$name' or group '$group' not found."
    fi
}

# 函数：从分组中移除网站
remove_from_group() {
    local name=$1
    local group=$2
    if [[ -n "${groups[$group]}" ]]; then
        groups["$group"]=${groups["$group"]// $name}
        save_groups
    else
        echo "Error: Group '$group' not found."
    fi
}

# 函数：列出所有分组
list_groups() {
    for group in "${!groups[@]}"; do
        echo "Group: $group"
        for name in ${groups[$group]}; do
            if [[ -n "${website_urls[$name]}" ]]; then
                echo " - $name: ${website_urls[$name]}"
            fi
        done
        echo
    done
}

# 函数：保存网站到文件
save_websites() {
    > "$WEBSITE_FILE"
    for name in "${!website_urls[@]}"; do
        echo "${name}=${website_urls[$name]}" >> "$WEBSITE_FILE"
    done
}

# 函数：保存分组到文件
save_groups() {
    > "$GROUP_FILE"
    for group in "${!groups[@]}"; do
        echo "${group}=${groups[$group]}" >> "$GROUP_FILE"
    done
}

# 函数：根据网站名称获取 URL
get_website_url() {
    local name=$1
    if [[ -n "${website_urls[$name]}" ]]; then
        echo "${website_urls[$name]}"
    else
        echo "Error: Website '$name' not found."
    fi
}

# 主函数
main() {
    local action=$1
    shift
    case $action in
        -a)
            if [ $# -lt 2 ] || [ $# -gt 3 ]; then
                echo "Error: Invalid arguments for '-a' operation."
                show_help
                return 1
            fi
            add_or_update_website "$1" "$2" "$3"
            ;;
        -u)
            if [ $# -ne 1 ]; then
                echo "Error: Invalid arguments for '-u' operation."
                show_help
                return 1
            fi
            remove_website "$1"
            ;;
        -d)
            if [ $# -ne 2 ]; then
                echo "Error: Invalid arguments for '-d' operation."
                show_help
                return 1
            fi
            update_website "$1" "$2"
            ;;
        -l)
            list_websites
            ;;
        -g)
            if [ $# -ne 1 ]; then
                echo "Error: Invalid arguments for '-g' operation."
                show_help
                return 1
            fi
            # Remove group by unsetting all references and saving
            for name in ${groups[$1]}; do
                remove_website "$name"
            done
            unset groups["$1"]
            save_groups
            ;;
        -A)
            if [ $# -ne 2 ]; then
                echo "Error: Invalid arguments for '-A' operation."
                show_help
                return 1
            fi
            add_to_group "$1" "$2"
            ;;
        -D)
            if [ $# -ne 2 ]; then
                echo "Error: Invalid arguments for '-D' operation."
                show_help
                return 1
            fi
            remove_from_group "$1" "$2"
            ;;
        -L)
            list_groups
            ;;

        -I)
            initialize_data
            ;;
        -G)
            if [ $# -ne 1 ]; then
                echo "Error: Invalid arguments for '-G' operation."
                show_help
                return 1
            fi
            get_website_url "$1"
            ;;

        *)	
            show_help
            ;;
    esac
}

# 脚本主体
initialize_data

# 检查是否提供了至少一个参数
if [ $# -lt 1 ]; then
    show_help
fi

# 调用主函数
main "$@"
