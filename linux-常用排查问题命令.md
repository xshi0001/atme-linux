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
### network

#### IPTraf
IPTraf 是诊断网络问题的利器，他可以监控系统的所有网络流量。可以为指定的端口、传输类型设置过滤器。

IPTraf 就像是一个轻量级的 Wireshark。通过 IPTraf 可以做很多细致的操作，例如按总体数据包大小对流量进行统计细分：
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
