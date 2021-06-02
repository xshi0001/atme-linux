# atme-linux


## 排序命令
- sort
- wc
- uniq

## 截取命令

[cut command in Linux with examples](https://www.geeksforgeeks.org/cut-command-linux-examples/)
- cut

-d ：后面接分隔字符。与 -f 一起使用（一定是一起使用不然报错）

语法：cut -d "delimiter" -f (field number) file.txt
` ss -tn  | cut -d ':' -f 8 |cut -d ']' -f 1`


 `ss state all sport = :9092 | cut -d ':' -f 8 |cut -d ']' -f 1  |sort | uniq -c`

- grep
## 正则

- sed
- awk: 好用的数据处理工具


