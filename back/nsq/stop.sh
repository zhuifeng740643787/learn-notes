#!/bin/sh
#服务停止
echo "停止服务..."
ps -ef | grep nsq| grep -v grep | awk '{print $2}' | xargs kill -2
echo "停止服务完成"
