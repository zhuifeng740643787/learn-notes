# 工具集
- nsq_stat 对指定主题/通道的所有生产者进程测验并显示汇总统计信息
- nsq_tail 消耗指定主题/通道的消息并写入stdout
- nsq_to_file 消耗指定的主题/通道并写到换行符分隔的文件中
- nsq_to_http 消耗指定的主题/通道，并向指定的端点执行HTTP请求
- nsq_to_nsq 消耗指定的主题/通道，并通过TCP将消息重新发布到目标nsqd
- to_nsq 接收标准输入流，并在换行符上分割（默认），通过TCP重新发布到目标nsqd