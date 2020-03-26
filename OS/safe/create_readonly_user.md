# 创建只读用户

```
# ln -s /bin/bash  /bin/readonly-bash
# useradd -s /bin/readonly-bash rttlsa
# passwd rttlsa
# mkdir /home/rttlsa/bin
# chown root. /home/rttlsa/*
# vi /home/rttlsa/.bash_profile 
# vi /home/rttlsa/.bashrc
# .bash_profile
 
# Get the aliases and functions
# if [ -f ~/.bashrc ]; then
#        . ~/.bashrc
# fi
 
# User specific environment and startup programs
 
PATH=$HOME/bin
 
export PATH
 
# ln -s /bin/cat  /home/rttlsa/bin/cat  将允许执行的命令链接到$HOME/bin目录
```
