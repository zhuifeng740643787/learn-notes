# 正则表达式
- 作用: 分割、查找、匹配、替换字符串
- 分隔符： 正斜线(/)、hash符号(#)、取反符号(~)
- 通用原子： 
    + \d: 0-9
    + \D: 除了0-9
    + \w: 大小写字母数字和下划线
    + \W: 除了大小写字母数字和下划线
    + \s: 空白符
    + \S: 除了空白符
- 元字符
    + .: 除了换行符之外的任意字符
    + *: 表示匹配的字符出现0次、1次或多次
    + ?: 表示匹配的字符出现0次或1次
    + +: 表示匹配的字符出现1次或多次
    + ^: 匹配开头
    + $: 匹配结尾
    + {n}: 匹配n次
    + {n,}: 匹配大于等于n次
    + {n,m}: 匹配大于等于n次小于等于m次
    + []: 要匹配的集合(各元素为`或`关系), 如[abc]表示匹配a或b或c
    + (): `后向引用`，或表示一个整体
    + [^]: 要匹配的集合取反, 如[^abc]表示匹配除了a或b或c
    + |: 或者
    + [-]: 表示范围, 如[0-9a-zA-Z]
- 模式修正符
    + i: 不区分大小写
    + m: 将字符串分割，对每一行分别进行匹配，前提是有换行符
    + U: 取消贪婪模式
    + u: 对utf-8格式的中文进行匹配

## 后向引用
- 将匹配字符用()括起来
```php
<?php
$str = '<b>abc</b>';
$pattern = '/<b>(a.*)<\/b>/'; // 用()括起来
$aa = preg_replace($pattern, '\\1', $str); // \1表示括号内匹配的第一个字符串
var_dump($aa); // string(3) "abc" 
```

## 取消贪婪模式
- 使用.*?
- 使用U模式修正符
```php
<?php
$str = '<b>abc</b><b>abc1</b><b>abc2</b>';
$pattern = '/<b>(.*?)<\/b>/';
$pattern2 = '/<b>(.*)<\/b>/U';
$aa = preg_replace($pattern, '\\1', $str);
$bb = preg_replace($pattern2, '\\1', $str);
var_dump($aa); // string(11) "abcabc1abc2"
var_dump($bb); // string(11) "abcabc1abc2"
```


## PCRE函数
- preg_match()
- preg_match_all()
- preg_replace()
- preg_split()

## 中文匹配
- UTF-8环境下汉字编码范围为`0x4e00-0x9fa5`,要使用u模式修正符
- ANSI(GB2312)环境下汉字编码范围为`0xb0-0xf7`,`0xa1-0xfe`,要使用`chr`将ASCII码转换为字符
```php
<?php

$str = '你好abcd哈哈';
$pattern = '/[\x{4e00}-\x{9fa5}]+/u'; // UTF-8格式
//$pattern = '/['. chr(0xb0) .'-' . chr(0xf7) . ']['. chr(0xa1) .'-' . chr(0xfe) . ']+/'; // ANSI（GB2312）格式
preg_match_all($pattern, $str, $match);
var_dump($match); // array(1) { [0] => array(2) { [0] => string(6) "你好" [1] => string(6) "哈哈" } }

```


## 案例
- 匹配字符串中所有的img标签的src值
```
$str = '<img alt="img1" src=\'1.jpg\'/><br><img src="2.jpg" alt="img2" id="img2"/>';

$pattern = '/<img.*Src=[\"\']+(.*)[\"\']+.*>/iU'; // 大小写不敏感 + 取消贪婪模式
preg_match_all($pattern, $str, $match);
var_dump($match); 

输出为：
array(2) {
  [0] =>
  array(2) {
    [0] =>
    string(29) "<img alt="img1" src='1.jpg'/>"
    [1] =>
    string(39) "<img src="2.jpg" alt="img2" id="img2"/>"
  }
  [1] =>
  array(2) {
    [0] =>
    string(5) "1.jpg"
    [1] =>
    string(5) "2.jpg"
  }
}

```