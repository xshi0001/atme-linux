#!/bin/bash

# Program:
#    jdk version
# History:
# 2020 JClearLove First release


spawn update-alternatives --config java

expect {

"*number:" {send "3\r";}
}

expect eof
exit