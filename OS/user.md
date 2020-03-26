# 用户

## 创建用户
- 创建
```
shell> useradd remote
```
- 设置密码
```
shell> passwd remote
```
- 查看用户、组、密码
```
shell> vim /etc/passwd
    - remote:x:1000:1000::/home/remote:/bin/bash
    - 注册名（login_name）:口令（passwd）:用户ID:组ID:用户详细信息:用户主目录:命令解释程序
shell> vim /etc/group
    - remote:x:1000:
    - 组名:口令:组ID:组成员（逗号分隔）
shell> vim /etc/shadow
    - gyd:$m1nzERhpqPgMLr834l4i/xQaqgWiJTG80:17465:0:99999:7:::
    - 登录名:口令（前面还有*或!或!!代表用户被禁用掉了）:口令最后修改时间距1970年1月1日的天数:口令能被修改之前的天数(防止修改口令，然后立刻将它改回到老口令):::
```

## 设置sudoer,且免密登录
- 添加 **remote ALL=(ALL) NOPASSWD:ALL** 到`/etc/sudoers` 文件

## 禁用root密码登录，开启sshkey认证
- 修改配置文件
```
shell> vim /etc/ssh/sshd_config
    RSAAuthentication yes
    PubkeyAuthentication yes
    PermitRootLogin no
    PasswordAuthentication no
```
- 将本地ssh pub key 写入`.ssh/authorized_keys`文件
- 注意文件权限
```
    SSH对公钥、私钥的权限和所有权的要求是非常严格的，总结如下：
    1、下面两个目录的所有权必须是user，所属组也应该是user，前者权限不能是777，后者权限必须为700
    \home\user
    \home\user\.ssh
    2、下面公钥文件的所有权必须是user，所属组也应该是user，权限必须为644
    \home\user\.ssh\authorized_keys
    3、下面私钥文件的所有权必须是user，所属组也应该是user，权限必须是600
    \home\user\.ssh\id_rsa
```
- 重启sshd服务，搞定
```
shell> systemctl restart sshd.service
```


