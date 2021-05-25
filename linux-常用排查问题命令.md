# atme-linux

## 常用监控工具

### IO
#### iotop工具
某些进程使用了多少你宝贵的 I/O 资源,iostat 命令也是查看 I/O 状态的，但他监控的是系统级别的 I/O 情况，而 iotop 监控的是进程级别的，可以监控到哪一个进程使用的 I/O 信息。
```
各个参数说明：(除了传参，可以在运行过程中按相应的按键)

　　-o, --only只显示正在产生I/O的进程或线程。除了传参，可以在运行过程中按o生效。
　　-b, --batch非交互模式，一般用来记录日志。
　　-n NUM, --iter=NUM设置监测的次数，默认无限。在非交互模式下很有用。
　　-d SEC, --delay=SEC设置每次监测的间隔，默认1秒，接受非整形数据例如1.1。
　　-p PID, --pid=PID指定监测的进程/线程。
　　-u USER, --user=USER指定监测某个用户产生的I/O。
　　-P, --processes仅显示进程，默认iotop显示所有线程。
　　-a, --accumulated显示累积的I/O，而不是带宽。
　　-k, --kilobytes使用kB单位，而不是对人友好的单位。在非交互模式下，脚本编程有用。
　　-t, --time 加上时间戳，非交互非模式。
　　-q, --quiet 禁止头几行，非交互模式。有三种指定方式。
　　-q 只在第一次监测时显示列名
　　-qq 永远不显示列名。
　　-qqq 永远不显示I/O汇总。
交互按键：
　　和top命令类似，iotop也支持以下几个交互按键。
　　left和right方向键：改变排序。　　
　　r：反向排序。
　　o：切换至选项--only。
　　p：切换至--processes选项。
　　a：切换至--accumulated选项。
　　q：退出。
　　i：改变线程的优先级。
```
时间刷新间隔2秒，输出5次： iotop  -d 2 -n 5
非交互式，输出5次，间隔2秒，输出到屏幕，也可输出到日志文本，用于监控某时间段的io信息
iotop -botq -n 5 -d 2
非交互式，输出pid为8382的进程信息
iotop -botq -p 8382

### cpu
### network 网络

#### IPTraf
IPTraf 是诊断网络问题的利器，他可以监控系统的所有网络流量。可以为指定的端口、传输类型设置过滤器。

IPTraf 就像是一个轻量级的 Wireshark。通过 IPTraf 可以做很多细致的操作，例如按总体数据包大小对流量进行统计细分

#### nc
简介：
- ncat 或者说 nc 是一款功能类似 cat 的工具，
- 是用于网络的。它是一款拥有多种功能的 CLI 工具，可以用来**在网络上读、写以及重定向数据**。
- 它被设计成可以被脚本或其他程序调用的可靠的后端工具。同时由于它能创建任意所需的连接，因此也是一个很好的网络调试工具

主要有如下使用方法：
- 监听udp端口：`ncat -l  -u 1234` 用 `netstat -tunlp | grep 1234`,-k 强制服务器保持连接并继续监听端口
- 想发送或者说测试某个远程主机 UDP 端口的连通性 `ncat -v -u {host-ip} {udp-port}`
- 使用ncat作为聊天工具：服务端  `ncat -l 8080` 和客户端 ` ncat 192.168.1.100 8080`
- nc 作为代理 ：` ncat -l 8080 | ncat 192.168.1.200 80`  我们服务器 8080 端口的连接都会自动转发到 192.168.1.200 上的 80 端
  nc作为代理双向联通：
- nc作为端口转发 ` ncat -u -l  80 -c  'ncat -u -l 8080'`

[nc命令详解](https://linux.cn/article-9190-1.html)


#### ss
简介：
- 用来显示处于活动状态的套接字信息。ss命令可以用来获取socket统计信息，它可以显示和netstat类似的内容。但ss的优势在于它能够显示更多更详细的有关TCP和连接状态的信息，而且比netstat更快速更高效

```
-h, --help      帮助信息
-V, --version   程序版本信息
-n, --numeric   不解析服务名称
-r, --resolve   解析主机名
-a, --all       显示所有套接字（sockets）
-l, --listening 显示监听状态的套接字（sockets）
-o, --options   显示计时器信息
-e, --extended  显示详细的套接字（sockets）信息
-m, --memory    显示套接字（socket）的内存使用情况
-p, --processes 显示使用套接字（socket）的进程
-i, --info      显示 TCP内部信息
-s, --summary   显示套接字（socket）使用概况
-4, --ipv4      仅显示IPv4的套接字（sockets）
-6, --ipv6      仅显示IPv6的套接字（sockets）
-0, --packet    显示 PACKET 套接字（socket）
-t, --tcp       仅显示 TCP套接字（sockets）
-u, --udp       仅显示 UCP套接字（sockets）
-d, --dccp      仅显示 DCCP套接字（sockets）
-w, --raw       仅显示 RAW套接字（sockets）
-x, --unix      仅显示 Unix套接字（sockets）
-f, --family=FAMILY  显示 FAMILY类型的套接字（sockets），FAMILY可选，支持  unix, inet, inet6, link, netlink
-A, --query=QUERY, --socket=QUERY
      QUERY := {all|inet|tcp|udp|raw|unix|packet|netlink}[,QUERY]
-D, --diag=FILE     将原始TCP套接字（sockets）信息转储到文件
 -F, --filter=FILE  从文件中都去过滤器信息
       FILTER := [ state TCP-STATE ] [ EXPRESSION ]


```

实例：

```
ss -t -a    # 显示TCP连接
ss -s       # 显示 Sockets 摘要
ss -l       # 列出所有打开的网络连接端口
ss -pl      # 查看进程使用的socket
ss -lp | grep 3306  # 找出打开套接字/端口应用程序
ss -u -a    显示所有UDP Sockets
ss -o state established '( dport = :smtp or sport = :smtp )' # 显示所有状态为established的SMTP连接
ss -o state established '( dport = :http or sport = :http )' # 显示所有状态为Established的HTTP连接
ss -o state fin-wait-1 '( sport = :http or sport = :https )' dst 193.233.7/24  # 列举出处于 FIN-WAIT-1状态的源端口为 80或者 443，目标网络为 193.233.7/24所有 tcp套接字

# ss 和 netstat 效率对比
time netstat -at
time ss

# 匹配远程地址和端口号
# ss dst ADDRESS_PATTERN
ss dst 192.168.1.5
ss dst 192.168.119.113:http
ss dst 192.168.119.113:smtp
ss dst 192.168.119.113:443

# 匹配本地地址和端口号
# ss src ADDRESS_PATTERN
ss src 192.168.119.103
ss src 192.168.119.103:http
ss src 192.168.119.103:80
ss src 192.168.119.103:smtp
ss src 192.168.119.103:25
```
用TCP 状态过滤Sockets

```
ss -4 state closing
# ss -4 state FILTER-NAME-HERE
# ss -6 state FILTER-NAME-HERE
# FILTER-NAME-HERE 可以代表以下任何一个：
# established、 syn-sent、 syn-recv、 fin-wait-1、 fin-wait-2、 time-wait、 closed、 close-wait、 last-ack、 listen、 closing、
# all : 所有以上状态
# connected : 除了listen and closed的所有状态
# synchronized :所有已连接的状态除了syn-sent
# bucket : 显示状态为maintained as minisockets,如：time-wait和syn-recv.
# big : 和bucket相反.
```
显示TCP连接

`ss -t -a`

显示UDP sockets

`ss -u -a`

所有端口为 22（ssh）的连接
`ss state all sport = :ssh`



### 综合

#### htop工具
[htop使用详解](https://www.cnblogs.com/programmer-tlh/p/11726016.html)

#### Monit工具
Monit 允许对进程、端口、文件等目标进行监控，并且可以设置动态的告警模式。支持对进程的重启
[centos7使用monit监控服务运行状态](https://blog.51cto.com/u_12173069/2307649)

#### 3 lsof工具 -lists openfiles

可以使用它来获得你系统上设备的信息，你能通过它了解到指定的用户在指定的地点正在碰什么东西，或者甚至是一个进程正在使用什么文件或网络连接。

默认 : 没有选项，lsof列出活跃进程的所有打开文件
组合 : 可以将选项组合到一起，如-abc，但要当心哪些选项需要参数
-a : 结果进行“与”运算（而不是“或”）
-l : 在输出显示用户ID而不是用户名
-h : 获得帮助
-t : 仅获取进程ID
-U : 获取UNIX套接口地址
-F : 格式化输出结果，用于其它命令。可以通过多种方式格式化，如-F pcfn（用于进程id、命令名、文件描述符、文件名，并以空终止）

#####  3.1 处理网络方面

- -i 使用-i显示所有连接


`lsof -i[46] [protocol][@hostname|hostaddr][:service|port]`
有些人喜欢用netstat来获取网络连接

显示TCP连接（同理可获得UDP连接）- **lsof  -iTCP**

使用-i:port来显示与指定端口相关的网络信息，`lsof  -i :22`,注意这个冒号和端口连在一起，我总忘记


使用@host来显示指定到指定主机的连接- 你在检查是否开放连接到网络中或互联网上某个指定主机的连接时十分有用 ` lsof  -i@172.16.12.5`

使用@host:port显示基于主机与端口的连接 - `  lsof  -i@172.16.12.5:22`

指出监听端口 `lsof  -i -sTCP:LISTEN`

你也可以获取各种用户的信息，以及它们在系统上正干着的事情，包括它们的网络活动、对文件的操作等。


##### 3.2 处理用户信息

-u显示指定用户打开了什么 - `lsof  -u daniel`

##### 3.3 命令和进程

可以查看指定程序或进程由什么启动，这通常会很有用，而你可以使用lsof通过名称或进程ID过滤来完成这个任务。下面列出了一些选项：

使用-c查看指定的命令正在使用的文件和网络连接-   `lsof -c nginx |grep log`

`lsof -c java |grep log`


使用-p查看指定进程ID已打开的内容- ` lsof  -p 10075`

t选项只返回PID `  lsof -t -c nginx`

##### 3.5 文件和目录

查看指定文件或目录，你可以看到系统上所有正与其交互的资源——包括用户、进程等。

显示与指定目录交互的所有一切   `lsof  /var/log/messages/`


### References


## 常用操作

- [Running Java application as Linux service with systemd](https://medium.com/@ameyadhamnaskar/running-java-application-as-a-service-on-centos-599609d0c641)
