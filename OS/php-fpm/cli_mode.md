# php交互模式
- [参考文档](https://my.oschina.net/lxrm/blog/538716)
- PHP 在mac下面很容易（php -a）就可以开启CLI交互模式，但是在其他平台，比如debian、ubuntu之类的Linux系统里面就不行了，是因为没有开启 readline和libedit编译选项的原因。

```
# yum install -y libedit-dev
# php -m |grep readline
如果没有，则需要到源码ext下找找 readline扩展包，默认好像没有启用。 (--with-readline)
# cd /root/install-pakages/php-5.6.14/ext/readline 
# phpize
# ./configure --with-readline --with-libedit
# make
# make install
# echo extension=readline.so >> /usr/local/php/lib/php.ini
# php -m | grep readline
readline
# php -a
Interactive mode enabled

php > //终于进入交互模式欧也

```