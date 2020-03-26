# 源码安装扩展,如soap

## centos下安装php的soap扩展,无需重新安装php
- 首先进入原先安装php版本文件夹下ext目录下相应的扩展
```
执行/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --enable-soap
make
make install
注：
Installing shared extensions:     /usr/local/php5/lib/php/extensions/no-debug-zts-20060613/
提示编译后的soap.so文件保存在了/usr/local/php/lib/php/extensions/no-debug-zts-20060613/目录下。
 
```
- 修改php.ini
```
 如果之前没有安装过extension，则需要将extension_dir = "./"改为extension_dir = "/usr/local/php5/lib/php/extensions/no-debug-zts-20060613/"，如果已经装过，这步之前应 该就已经改过了，也可以自定义到其它路径，一般使用默认路径。
添加：extension=soap.so
```
- reload下php-fpm
```
/etc/init.d/php-fpm reload
```
