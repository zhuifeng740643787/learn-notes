# 源码结构目录
文件目录：/usr/local/Cellar/php71/7.1.5_17/include/php

- ext: 官方扩展目录，包括了绝大多数PHP的函数的定义和实现，如array系列，pdo系列，spl系列等函数的实现，都在这个目录中。个人写的扩展在测试时也可以放到这个目录，方便测试和调试。
- Zend: Zend引擎的实现目录，比如脚本的词法解析，opcode的执行以及扩展机制的实现等等
- TSRM: PHP的线程安全是构建在TSRM库之上的，PHP实现中常见的*G宏通常是对TSRM的封装，
TSRM(Thread Safe Resource Manager)线程安全资源管理器。
- main: PHP最为核心的文件，主要实现PHP的基本设施，这里和Zend引擎不一样，Zend引擎主要实现语言最核心的语言运行环境
- sapi: 包含了各种服务器抽象层的代码，例如apache的mod_php，cgi，fastcgi以及fpm等等接口
