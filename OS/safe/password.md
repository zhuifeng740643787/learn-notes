# 密码复杂度策略
[参考文章](http://blog.51cto.com/hunkz/1630369)

## 描述
- 操作系统口令强度策略不完善。

## 分析
- 所有Linux操作系统的口令强度策略不完善，未设置口令复杂度及口令定时更新周期。

## 风险评价
- 口令可能被恶意用户猜测获得，合法用户身份被仿冒，导致数据库被非授权访问。

## 关联威胁
- 网络攻击、越权或滥用

## 修复措施
- 设置用户口令长度及复杂度要求策略，设置口令定期更换策略。口令长度:16位+大小写字母+字符？口令最长有效期:60天

### 设置密码复杂度办法
- 修改/etc/login.defs文件,控制密码的有效期
```
PASS_MAX_DAYS   60  #密码最长过期天数
PASS_MIN_DAYS   0  #密码最小过期天数, 表示自从上次密码修改以来多少天后用户才被允许修改口令
PASS_MIN_LEN    16  #密码最小长度,对于root无效
PASS_WARN_AGE   7   #密码过期警告天数,表示在口令到期前多少天开始通知用户口令即将到期
```
- 修改/etc/pam.d/system-auth文件,控制密码的复杂度
```
找到 password requisite pam_cracklib.so这么一行替换成如下：
password  requisite pam_cracklib.so retry=5  difok=3 minlen=16 ucredit=-1 lcredit=-3 dcredit=-3 dictpath=/usr/share/cracklib/pw_dict
参数含义：
    retry 尝试次数：5  
    difok 最少不同字符：3 
    minlen 最小密码长度：16  
    ucredit 最少大写字母：1 
    lcredit 最少小写字母：3 
    dcredit 最少数字：3 
    dictpath 密码字典：/usr/share/cracklib/pw_dict
```
- **注意：以上设置对root用户无效**

### 测试
```
root身份：
root>useradd  test
root>passwd test
root>su test

test身份：
test>passwd
...

```