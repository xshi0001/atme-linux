# JVM 常用工具

## jstat
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

1. **jstat -gc PID 1 count** 每1s输出当前的进程的内存和GC情况，共输出count次

 jstat -gc -h3 17767  250

jstat -<option>  -t（产生时间戳） -h<lines>（每统计几条数据，显示行名称） <vmid>（进程pid） <interval>(统计间隔时间)  <count>（统计多少次）

2. 远程监控 jstat -gcutil 40496@remote.domain 1000

## 开启jmx 监控jvm进程

`KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=10.0.0.109 -Djava.net.preferIPv4Stack=true -Dcom.sun.management.jmxremote.port=9999"`

## jmap



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
| visualVM  |图形化界面|
| jmx方式  |jconsole-MBeans tab and find the **HotSpotDiagnostic** under com.sun.management.|

dump文件怎么分析？




