# 开机启动服务
[参考文档](https://blog.csdn.net/yusiguyuan/article/details/9457297)

## 添加自启动服务方法
- ln -s 在/etc/rc.d/rc*.d目录中建立/etc/init.d/服务的软链接(*代表0~6七个运行级别之一)
- chkconfig 命令行运行级别设置
    + 查看当前开机启动服务列表: chkconfig --list
    + 添加服务: chkconfig --add nginx
    + 开启服务: chkconfig nginx on
    + 关闭服务: chkconfig nginx off

## 启动级别0、1、2、3、4、5、6的分析
0:停机
1：单用户形式，只root进行维护
2：多用户，不能使用net file system
3：完全多用户
5：图形化
4：安全模式
6：重启 
其实，可以通过查看/etc/rc.d/中的rc*.d的文件来对比理解。。
init 0，对应的系统会运行，/etc/rc.d/rc0.d里指定的程序

