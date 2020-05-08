#!/bin/bash

# 打印日志
function printLog() {
  echo $1
}

printLog '开始挂载磁盘....'
printLog '查看是否有数据盘'
fdisk -l

printLog '对数据盘进行分区:' 
printLog '输入 n 并按回车键：创建一个新分区。'
printLog '输入 p 并按回车键：选择主分区。因为创建的是一个单分区数据盘，所以只需要创建主分区。'
printLog '说明：如果要创建 4 个以上的分区，您应该创建至少一个扩展分区，即选择 e。'
printLog '输入分区编号并按回车键。因为这里仅创建一个分区，可以输入 1。'
printLog '输入第一个可用的扇区编号：按回车键采用默认值 1。'
printLog '输入最后一个扇区编号：因为这里仅创建一个分区，所以按回车键采用默认值。'
printLog '输入 wq 并按回车键，开始分区'
fdisk /dev/vdb

printLog '查看新的分区' 
fdisk -l

printLog '磁盘格式化'

printLog '查看系统支持的文件系统格式'
cat /etc/filesystems
printLog '在新分区上创建文件系统'
mkfs.ext4 /dev/vdb1
printLog '向 /etc/fstab 写入新分区信息，便于开机后自动挂载磁盘'
echo /dev/vdb1 /mnt ext4 defaults 0 0 >> /etc/fstab

## 挂载
printLog '查看当前系统挂载的所有分区、分区文件系统的类型、挂载点及一些选项等信息'
mount
printLog '挂载'
mount /dev/vdb1 /mnt
printLog '查看目前磁盘空间和使用情况'
df -h