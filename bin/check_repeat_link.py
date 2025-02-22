def check_if_repeat():
    with open("./include/blog_list.txt",mode = 'r') as f:
        blog_list = f.readlines()
        with open("./include/new_list.txt",mode="r") as n: 
            new_link = n.readlines()
            for link in new_link:
                if link not in blog_list:
                    print(link)
        n.close()
    f.close()

check_if_repeat()

