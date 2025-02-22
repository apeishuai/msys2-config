import sys
import re

# 检查是否提供了文件路径参数
if len(sys.argv) != 2:
    print("Usage: python script.py path_to_file")
    sys.exit(1)

# 从命令行参数获取文件路径
file_path = sys.argv[1]

# 尝试以不同编码读取文件
valid_encodings = ['utf-8', 'utf-8-sig', 'ISO-8859-1', 'windows-1252']
text = ""
for encoding in valid_encodings:
    try:
        with open(file_path, 'r', encoding=encoding) as file:
            text = file.read()
            break  # 成功读取后退出循环
    except (FileNotFoundError, UnicodeDecodeError) as e:
        print(f"Error reading file {file_path} with encoding {encoding}: {e}")
        continue

# 如果没有找到合适的编码，则报错
if not text:
    print(f"Could not decode the file {file_path} with the encodings: {valid_encodings}")
    sys.exit(1)

# 使用正则表达式匹配以I、Q、V或M开头，后跟任意字符，以.数字结尾的变量
pattern = r'\b([IQVM])([a-zA-Z0-9_]*)\.(\d+)'

# 使用re.findall查找所有匹配的字符串
matches = re.findall(pattern, text)

# 准备输出格式，每个匹配项一行出现两次，中间用Tab分隔
output_format = "\t{0}{1}.{2}\t{0}{1}.{2}\n"

# 输出到kaiguan.txt文件
with open('kaiguan.txt', 'w') as f:
    for match in matches:
        # 组合回原格式
        switch_quantity = "".join(match)
        f.write(output_format.format(switch_quantity, match[1], match[2]))

# 打印到控制台
print("Found switch quantities, written to kaihuan.txt:")
for match in matches:
    switch_quantity = "".join(match)
    print(output_format.format(switch_quantity, match[1], match[2]))
