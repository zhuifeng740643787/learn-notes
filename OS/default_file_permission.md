# 修改用户创建文件的默认权限

## 文件权限
[参考文档](https://my.oschina.net/alphajay/blog/112428)
```
echo 'umask 0000' >> ~/.bash_profile && source ~/.bash_profile
```


## 默认所属组
[参考文档](https://blog.csdn.net/furzoom/article/details/77737344)
```
chgrp groupA dirA/
chmod g+s dirA/
```