# 变量与函数

## 变量作用域
- 也称变量的范围，即它定义的上下文背景，大部分变量只有一个单独的范围，同样包含include和require引入的文件
- 全局变量: 函数体外部的变量
- 局部变量: 函数体内部的变量
    ```
    函数体内使用全局变量使用global关键字
    $outer_var = 'aaa'; // 全局变量
    function func() {
        $inner_var = '123'; // 局部变量
        global $outer_var; // 加global关键字，可访问全局变量
        echo $outer_var;
        echo $GLOBALS['outer_var']; // 或使用$GLOBALS超全局数组
    }
    ```

- 静态变量：仅在局部函数域中存在,但当程序执行离开此作用域时，其值并不会消失
    ```
    static关键字
    1、仅初始化一次
    2、初始化时需要赋值
    3、每次执行函数该值会保留
    4、static修饰的变量是局部的，仅在函数内部有效
    5、可记录函数的调用次数，从而可以在某些条件下终止递归
    function f () {
        static $aa;
        echo $aa++;
    }
    f(); // 无输出 
    f(); // 输出 1
    f(); // 输出 2 
    ```

## 函数
### 参数
- 默认情况下，函数参数通过`值`传递
- 可通过引用传递参数来修改参数的值
```php
<?php
$a = 1;
function f(&$a) {
    $a = 2;
}
f($a);// 只能传递变量，不能传递一个值
echo $a; // 2
```

### 返回值
- 使用return, 可返回任意类型
- 省略return时，返回NULL,不可有多个返回值
- 引用返回:
    + 从函数返回一个引用，必须在函数声明和指派返回值给一个变量时都是用引用运算符&
    ```
    <?php
    function &f() {
        static $b = 10;
        return $b; // 必须返回一个要引用的变量
    }
    $a = f();
    echo $a; // 10
    $a = &f();
    echo $a; // 10
    $a = 100;
    echo f(); // 100
    ```

### 外部文件导入
- include / require : 
    + 包含并运行指定文件
    + 如果给出路径名，则按照路径来找
    + 如果未给出路径名，则查找顺序：include_path --> 调用脚本文件所在目录
    + 当一个文件被包含时，其中所包含的代码继承了include所在行的变量范围
    + 未找到文件时
        - include 会发出一条警告E_WARNING，程序继承执行
        - require 会产生E_COMPILE_ERROR级别的错误，程序中止
    + include_once / require_once 只包含一次

## 系统内置函数

### 时间日期函数
- date()
- strtotime()
- mktime()
- time()
- microtime()
- date_default_timezone_set()
```php
<?php
echo date('Y-m-d H:i:s', time()) . PHP_EOL; // 2018-03-07 16:54:28
echo strtotime('+1 day', time()) . PHP_EOL; // 1520499268
echo microtime(true) . PHP_EOL;             // 1520412868.75
date_default_timezone_set('Asia/Shanghai');
echo date_default_timezone_get() . PHP_EOL; // Asia/Shanghai
```

### IP处理函数
- ip2long()
- long2ip()
```
echo ip2long('127.0.0.1'); // 2130706433
echo long2ip(2130706433); // 127.0.0.1
```

### 打印处理
- print / print()
- printf()
- print_r()
- echo 
- sprintf() 
- var_dump()
- var_export()
```php
<?php
echo '123', 11;  echo PHP_EOL;      // 12311
print '123'; echo PHP_EOL; // 123
echo(12); echo PHP_EOL; // 12
print(12); echo PHP_EOL; // 12
printf("this is %.2f - %d", 1222.232, 100); echo PHP_EOL; // this is 1222.23 - 100
$a = sprintf("this is %.2f - %d", 1222.232, 100); echo PHP_EOL;
var_dump($a); // string(21) "this is 1222.23 - 100"
print_r([1,2,3]); echo PHP_EOL; // Array ([0] => 1 [1] => 2 [2] => 3 )
var_dump([1,2,3]); echo PHP_EOL; // array(3) {[0] => int(1) [1] => int(2) [2] => int(3) }
var_export([1,2,3]); // array (0 => 1, 1 => 2, 2 => 3, )
$a = var_export([1,2,3], true);
var_dump($a); // string(39) "array (0 => 1, 1 => 2, 2 => 3, )"

```

### 序列化 反序列化
- serialize()
- unserialize()
```php
<?php
class A {
    public $name = 'alex';
    public $age = 22;
}
$a = new A();
echo serialize($a); // O:1:"A":2:{s:4:"name";s:4:"alex";s:3:"age";i:22;}
var_dump(unserialize(serialize($a))); // class A#2 (2) {public $name => string(4) "alex"public $age => int(22) }
```

### 字符串处理函数
- implode()
- explode()
- join()
- strrev()
- trim()
- ltrim()
- rtrim()
- strstr()
- number_format()
```php
<?php
var_dump(implode('|', [1, 2, 3])); // string(5) "1|2|3"
var_dump(explode('|', 'a|b|c')); // array(3) {[0] => string(1) "a"[1] => string(1) "b"[2] => string(1) "c"}
var_dump(join('|', [1, 2, 3])); // string(5) "1|2|3"
var_dump(strrev('abc')); // string(3) "cba"
var_dump(trim(" asd ")); // string(3) "asd"
var_dump(ltrim('aasdd', 'a')); // string(3) "sdd"
var_dump(rtrim('aasdd', 'd')); // string(3) "aas"
var_dump(strstr('abcde', 'bc')); // string(4) "bcde"
var_dump(number_format(12345.555, 2, '.', ',')); // string(9) "12,345.56"
```

















