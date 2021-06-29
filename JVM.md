# JVM 常用工具

## 一、jstat
Jstat是JDK自带的一个轻量级小工具。全称**Java Virtual Machine statistics monitoring tool**，它位于java的bin目录下，主要利用JVM内建的指令对Java应用程序的资源和性能进行实时的命令行的监控，包括了对Heap size和垃圾回收状况的监控。

目的
- 新生代的增长速率
- Young GC的触发频率
- Young GC的耗时
- 每次Young GC后有多少对象存活下来的
- 每次Young GC过后有多少对象进入老年代
- 老年代对象增长速率
- Full GC的触发速率
- Full GC的耗时

[官网-jstat](https://docs.oracle.com/javase/7/docs/technotes/tools/share/jstat.html)

> 120Kafka的问题排除还记得吗？17万次的full gc问题

1. 用法一： **jstat -gc PID 1 count** 每1s输出当前的进程的内存和GC情况，共输出count次

- 示例：jstat -gc -h3 17767  250
- 语法含义：

`jstat -<option>  -t（产生时间戳） -h<lines>（每统计几条数据，显示行名称） <vmid>（进程pid） <interval>(统计间隔时间)  <count>（统计多少次）`

2. 用法二：远程监控 jstat -gcutil 40496@remote.domain 1000

## 二、jconsole

开启jmx 监控jvm进程

`KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=10.0.0.109 -Djava.net.preferIPv4Stack=true -Dcom.sun.management.jmxremote.port=9999"`

## 三、jmap



JVM新增对象的速度很快，到底什么对象占据了那么多内存，
1. jmap -heap pid
打印一个堆的摘要信息，包括使用的**GC算法**、堆配置信息和各内存区域内存使用信息
2. jmap -histo:live pid
显示堆中对象的统计信息
其中包括每个Java类、对象数量、内存大小(单位：字节)、完全限定的类名。打印的虚拟机内部的类名称将会带有一个’*’前缀。如果指定了live子选项，则只计算活动的对象
3. jmap -clstats pid

打印Java堆内存的永久保存区域的类加载器的智能统计信息。对于每个类加载器而言，它的名称、活跃度、地址、父类加载器、它所加载的类的数量和大小都会被打印。此外，包含的字符串数量和大小也会被打印。

4. **java heap dumps**
dump文件记录了JVM运行期间的内存占用、线程执行等情况。

| 生成dump文件方式  | 命令|
|---|---|
| jmap  |jmap -dump:live,format=b,file=heapdump.phrof pid （慎用，STW）|
| jar 启动命令生产环境推荐  |java -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=<file-or-dir-path>|
| jcmd  |jcmd 12587 GC.heap_dump /tmp/dump.hprof|
| jmx方式  |jconsole-MBeans tab and find the **HotSpotDiagnostic** under com.sun.management.|
| arthas  |heapdump /tmp/dump.hprof|


dump文件怎么分析？

## 四、jstack

堆栈分析工具

## 五、jinfo

1. 动态的添加jvm参数

   `jinfo -flag +PrintGCDetails <PID>`


## 六、JCmd

可以用它来导出堆、查看Java进程、导出线程信息、执行GC、还可以进行采样分析（jmc 工具的飞行记录器）

常用使用场景与命令：

1. 查看性能统计、查看指定进程的性能统计信息

    `jcmd pid PerfCounter.print`


2. 当前运行的java进程可以执行的操作,进而可以查看命令选项帮助

   `jcmd pid help`

   想查看 JFR.dump 命令选项， `jcmd PID help JFR.dump`

3. JRF 相关命令

   * enable JRF: -XX:+UnlockCommercialFeatures -XX:+FlightRecorder

   * 启动JFR:`jcmd $PID JFR.start name=abc,duration=120s`

   * Dump JFR等待至少duration（本文设定120s）后，执行命令：`jcmd PID JFR.dump name=abc,duration=120s filename=abc.jfr`（注意，文件名必须为.jfr后缀）

   * 检查JFR状态,执行命令：`jcmd $PID JFR.check name=abc,duration=120s`

   * 停止JFR, 执行命令：`jcmd $PID JFR.stop name=abc,duration=120s`

   * JMC分析,切回开发机器，下载步骤3中生成的abc.jfr，打开jmc，导入abc.jfr即可进行可视化分析

4. 其他

|  命令 |详情|
|---|---|
|  jcmd PID VM.uptime |查看 JVM 的启动时长|
|  jcmd PID GC.class_histogram |查看系统中类统计信息，jmap -histo pid的效果是一样的，这个可以查看每个类的实例数量和占用空间大小|
|  jcmd PID Thread.print |查看线程堆栈信息|
|  jcmd PID GC.heap_dump FILE_NAME |查看 JVM 的Heap Dump，跟 jmap命令：jmap -dump:format=b,file=heapdump.phrof pid 效果一样。导出的 dump 文件，可以使用MAT 或者 Visual VM 等工具进行分析|
|  jcmd PID VM.system_properties |查看 JVM 的属性信息|
|jcmd PID VM.flags|查看 JVM 的启动参数|
|jcmd PID VM.command_line |查看 JVM 的启动命令行|




5. 
jcmd <PID> GC.class_stats|awk '{print$13}'|sed  's/\(.*\)\.\(.*\)/\1/g'|sort |uniq -c|sort -nrk1




参考文献：

- [jvm 性能调优工具之 jcmd](https://cloud.tencent.com/developer/article/1130026)

## 七、JMC






参看文献：

- [JDK Mission Control 官方文档](https://www.oracle.com/java/technologies/jdk-mission-control.html)

## 八、JProfile

-[Jprofile解析dump文件使用详解](https://mp.weixin.qq.com/s/7WGs6gmn9piSEzcO9IkbMA)

## 零、开发中常见排除问题

### Q1-判断GC到底有没有问题

1. 首先设置评价标准,
* **延迟（Latency）**： 也可以理解为最大停顿时间，即垃圾收集过程中一次`STW`的最长时间，越短越好，一定程度上可以接受频次的增大，**GC技术的主要发展方向**,目前各大互联网最求避免一次GC停顿的时间过长对用户体验造成损失。
* **吞吐量（Throughput）**： 应用系统的生命周期内，由于GC线程会占用Mutator当前可用的 CPU 时钟周期，吞吐量即为 Mutator 有效花费的时间占系统总运行时间的百分比，例如系统运行了 100 min，GC 耗时 1 min，则系统吞吐量为 99%，吞吐量优先的收集器可以接受较长的停顿。


### 参考文献

- [美团-Java中9种常见的CMS GC问题分析与解决](https://tech.meituan.com/2020/11/12/java-9-cms-gc.html#)




