#!/bin/sh

#服务启动

CONFIG_PATH="/usr/local/nsq/config"
DATA_PATH="/usr/local/nsq/data"
LOG_PATH="/acs/log/nsq/"

LOOKUP_TCP_ADDRESS=0.0.0.0:40000
LOOKUP_HTTP_ADDRESS=0.0.0.0:40001

mkdir -p $CONFIG_PATH 
mkdir -p $DATA_PATH 
mkdir -p $DATA_PATH/nsqd_1
mkdir -p $DATA_PATH/nsqd_2
mkdir -p $LOG_PATH

# 启动nsqlookupd
echo "启动nsqlookupd..."
nohup nsqlookupd \
    --broadcast-address=local-nsqlookup \
    --tcp-address=$LOOKUP_TCP_ADDRESS \
    --http-address=$LOOKUP_HTTP_ADDRESS \
    >> $LOG_PATH/nsqlookupd.log 2>&1 & 
echo "nsqlookupd: http://0.0.0.0:40001"

echo '启动nsqd服务1...'
nohup nsqd \
    --broadcast-address=local-nsqlookup \
    --data-path=$DATA_PATH/nsqd_1 \
    --lookupd-tcp-address=$LOOKUP_TCP_ADDRESS \
    --tcp-address=0.0.0.0:41000 \
    --http-address=0.0.0.0:41001 \
    --log-prefix=[nsqd1] \
    >> $LOG_PATH/nsq1.log 2>&1 & 
echo '启动nsqd服务2...'
echo "nsqd1: http://0.0.0.0:41001"
nohup nsqd \
    --broadcast-address=local-nsqlookup \
    --data-path=$DATA_PATH/nsqd_2 \
    --lookupd-tcp-address=$LOOKUP_TCP_ADDRESS \
    --tcp-address=0.0.0.0:41010 \
    --http-address=0.0.0.0:41011 \
    --log-prefix=[nsqd2] \
    >> $LOG_PATH/nsq2.log 2>&1 & 
echo "nsqd2: http://0.0.0.0:41011"
 
echo '启动nsqdadmin服务...'
nohup nsqadmin \
    --http-address=0.0.0.0:42001 \
    --lookupd-http-address=$LOOKUP_HTTP_ADDRESS \
    >> $LOG_PATH/nsqadmin.log 2>&1 & 
echo "nsqadmin: http://0.0.0.0:42001"
