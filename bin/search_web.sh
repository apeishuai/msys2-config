#!/bin/bash

# 定义保存网站列表的文件路径
list_file="G:/config and meta_data/website_list.txt"

# 检查网站列表文件是否存在，不存在则创建
if [ ! -f "$list_file" ]; then
  touch "$list_file"
fi

# 添加网站到列表
add_website() {
  read -p "请输入要添加的网站URL: " url
  echo "$url" >> "$list_file"
  echo "网站已添加到列表。"
}

# 从列表中删除网站
delete_website() {
  read -p "请输入要删除的网站URL: " url
  sed -i "/$url/d" "$list_file"
  echo "网站已从列表中删除。"
}

# 显示网站列表
show_website_list() {
  echo "当前网站列表："
  cat "$list_file"
}

# 搜索网站内容
search_website() {
  read -p "请输入要搜索的关键词: " keyword
  echo "搜索结果："
  echo

  # 保存匹配结果的数组
  results=()

  while IFS= read -r url; do
    content=$(curl -s "$url" | grep -i "$keyword")
    if [ -n "$content" ]; then
      results+=("$url\n$content\n")
    fi
  done < "$list_file"

  # 检查搜索结果是否为空
  if [ ${#results[@]} -eq 0 ]; then
    echo "未找到匹配的内容。"
  else
    # 以更灵活的方式展示搜索结果
    for result in "${results[@]}"; do
      echo "------------------------------------"
      echo -e "$result"
    done
    echo "------------------------------------"
  fi
}

# 主菜单
while true; do
  echo "请选择操作："
  echo "1. 添加网站到列表"
  echo "2. 从列表中删除网站"
  echo "3. 显示网站列表"
  echo "4. 在列表的网站里搜索"
  echo "5. 退出"

  read -p "请输入选项（1-5）: " choice

  case $choice in
    1)
      add_website
      ;;
    2)
      delete_website
      ;;
    3)
      show_website_list
      ;;
    4)
      search_website
      ;;
    5)
      break
      ;;
    *)
      echo "无效的选项，请重新输入。"
      ;;
  esac

  echo
done
