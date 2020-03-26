# 进制

## 常用进制
- Dec: 十进制 (123)
- Hex: 十六进制 (0x1df2,注意前面的0x)
- Oct: 八进制 (0123,注意签名的0)
- Bin: 二进制 ('1001',注意单引号)

## 转义字符
- \x : 表示十六进制
```
<?php
echo "\x41"; // 输出65对应的ascii值A
```
- \ : 表示八进制
```
<?php
echo "\101"; // 输出65对应的ascii值A
```

## 字符与ascii值转换
- chr()函数: ascii值转字符
```
<?php
//都将输出A
echo chr(65);// 十进制，返回A
echo chr(0x41);// 十六进制，返回A
echo chr(0101);// 八进制，返回A
echo chr('1000001');// 二进制，返回A
```
- ord()函数: 字符转ascii值
```
<?php  
echo ord('A');//输出65  
```
- printf/sprintf()函数: 格式化输出
```
<?php
//都将输出A
printf("%c", 0x41);               //第二个参数一定不能用单/双引号  
printf("%c", 0101);               //第二个参数一定不能用单/双引号  
printf("%c", 65);                    //第二个参数一定不能用单/双引号  
printf("%c", '01000001');
```

## 进制间转换
- bin2hex 二进制转为16进制
- decbin 十进制转二进制
- dechex 十进制转十六进制
- hexdec 十六进制转十进制
- octdec 八进制转十进制
- decoct 十进制转八进制
- base_convert 任意进制转换
```
<?php
echo bin2hex('A');// 返回 41(ascii值A对应的十进制为65，十进制的65对应的十六进制为41)
echo decbin(123);// 返回 1111011
echo octdec(11);// 返回 9，不需要加前面的0
echo hex2bin(65);// 返回 e(十六进制的65对应十进制为101, ascii值为101对应的字符为e)
echo hexdec(23);// 返回35，不需要加前面的0x
echo base_convert(1001, 8, 2);//返回1000000001, 八进制的1001转为二进制
```


## 实例
- 写一个函数来检查用户提交的数据是否为整数（不区分数据类型，可以为二进制、八进制、十进制、十六进制数字）
```
<?php
$val = isset($argv[1]) ? $argv[1] : '';
if(!$val) {
    p('请输入数据');
}

p(checkInt($val) ? 'yes' : 'no');

function checkInt($a) {

    if($a === '0') {
        return true;
    }
    //十六进制
    if(strpos($a, '0x') === 0) {
        return preg_match('/^0x[0-9a-fA-F]+$/', $a);
    }
    //八进制/二进制
    if(strpos($a, '0') === 0) {
        return preg_match('/^0[0-7]*$/', $a);
    }

    return preg_match('/^[1-9][0-9]*$/', $a);

}

function p(...$str) {//三个点的写法适用于php5.6版本之后(含5.6)
   if(is_array($str)) {
       foreach ($str as $s) {
           print_r($s);
       }
       return;
   }
   print_r($str);
}

//测试
shell> php index.php 0x123
-> yes
shell> php index.php 0123f
-> no
```



