# 数组合并的三种方式

1. 操作符（+）: 一维数组的合并
2. array_merge: 一维数组的合并
3. array_merge_recursive: 递归合并

PHP数组分为索引数组和关联数组
- 索引数组 : 没有键值和以键值为数字的数组
- 关联数组 : 键值为字符的数组


## 操作符（+）
- 合并相同的键值(索引+关联)，以前面数组的值为合并的结果   

## array_merge
- 只对相同的关联键值进行合并，以后面数组的值为合并的结果
- 索引键值的值不进行合并，索引值以0开始重新生成

## array_merge_recursive
- 以array_merge相同，只对相同的关联键值进行合并，合并结果为两个键值对应值生成的数组
- 索引键值的值不进行合并，索引值以0开始重新生成


## 代码示例
```
<?php
$a = [
    'hello',
    '11' => '11',
    '2' => '22',
    'ss',
    'a' => 'a',
    'a2'=>'b',
    'aaa' => 123123,
    'asd'
];
$b = [
    'world',
    '10' => '222',
    'bb',
    '2' => '333',
    'a' => 'c',
    'a2'=>'d',
    'a3'=>'ajsd',
    'asdhask'
];
$c = $a + $b;
$d = array_merge($a, $b);
$e = array_merge_recursive($a, $b);
var_dump($a, $b, $c, $d, $e);

//-----------
输出：

$a :
array(8) {
  [0] => string(5) "hello"
  [11] => string(2) "11"
  [2] => string(2) "22"
  [12] => string(2) "ss"
  'a' => string(1) "a"
  'a2' => string(1) "b"
  'aaa' => int(123123)
  [13] => string(3) "asd"
}

$b: 
array(8) {
  [0] => string(5) "world"
  [10] => string(3) "222"
  [11] => string(2) "bb"
  [2] => string(3) "333"
  'a' => string(1) "c"
  'a2' => string(1) "d"
  'a3' => string(4) "ajsd"
  [12] => string(7) "asdhask"
}

$c = $a + $b :
array(10) {
  [0] => string(5) "hello"
  [11] => string(2) "11"
  [2] => string(2) "22"
  [12] => string(2) "ss"
  'a' => string(1) "a"
  'a2' => string(1) "b"
  'aaa' => int(123123)
  [13] => string(3) "asd"
  [10] => string(3) "222"
  'a3' => string(4) "ajsd"
}

$d = array_merge($a, $b) : 
array(14) {
  [0] => string(5) "hello"
  [1] => string(2) "11"
  [2] => string(2) "22"
  [3] => string(2) "ss"
  'a' => string(1) "c"
  'a2' => string(1) "d"
  'aaa' => int(123123)
  [4] => string(3) "asd"
  [5] => string(5) "world"
  [6] => string(3) "222"
  [7] => string(2) "bb"
  [8] => string(3) "333"
  'a3' => string(4) "ajsd"
  [9] => string(7) "asdhask"
}

$e = array_merge_recursive($a, $b) :
array(14) {
  [0] => string(5) "hello"
  [1] => string(2) "11"
  [2] => string(2) "22"
  [3] => string(2) "ss"
  'a' => array(2) {
    [0] => string(1) "a"
    [1] => string(1) "c"
  }
  'a2' => array(2) {
    [0] => string(1) "b"
    [1] => string(1) "d"
  }
  'aaa' => int(123123)
  [4] => string(3) "asd"
  [5] => string(5) "world"
  [6] => string(3) "222"
  [7] => string(2) "bb"
  [8] => string(3) "333"
  'a3' => string(4) "ajsd"
  [9] => string(7) "asdhask"
}


