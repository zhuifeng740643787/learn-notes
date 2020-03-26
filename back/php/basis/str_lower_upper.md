# 字符大小写转换

## 官方函数
- strtolower: 转换为小写
- strtoupper: 转换为大写

## 汉字问题
- 在安装非中文系统的服务器下可能会导致将汉字转换为乱码
  ```
  原因：
  中文是由多字节组成的，而只有英文系统的单个英文字符只有一个字节，所以该系统把中文的每一个字节
  都做了strtolower()处理,改变后的中文字节拼接在一起就成了乱码（新生成的编码映射对应的字符可能就不是中文了）
  ```
- 两种解决方法实现兼容Unicode文字的字符串大小写转换
  * 根据ASCII值,按每个字节进行切割
  ```
  function strUpper($str) {
    if(!is_string($str)) {
        return '';
    }
    $arr = str_split($str, 1);
    $str = '';
    foreach ($arr as $char) {
        $ascii_num = ord($char);
        if($ascii_num < 65 || $ascii_num > 90) {
           $str .= $char;
           continue;
        }
        $str .= chr($ascii_num + 32);
    }
    return $str;
  }

  function strLower($str) {
      if(!is_string($str)) {
          return '';
      }
      $arr = str_split($str, 1);
      $str = '';
      foreach ($arr as $char) {
          $ascii_num = ord($char);
          if($ascii_num < 97 || $ascii_num > 122) {
              $str .= $char;
              continue;
          }
          $str .= chr($ascii_num - 32);
      }
      return $str;
  }

  ```
  * 使用mbstring扩展
  ```
  string mb_convert_case (string $str ,int $mode [,string $encoding = mb_internal_encoding()])

  $mode有三种模式： 
  1.MB_CASE_UPPER：转成大写 
  2.MB_CASE_LOWER：转成小写 
  3.MB_CASE_TITLE ：转成首字母大写

  $encoding默认使用内部编码；也可以显示使用如’UTF-8’; 
  可以用echo mb_internal_encoding();来查看；

  推荐使用该扩展，不仅对中文适用，对其他语言也适用。

  string ucwords ( string $str )将每个单词的首字母大写 
  string ucfirst ( string $str )只是将字符串的首字母大写而已

  <?php
  //注意world的区别
  $str = "hello world";
  var_dump(ucfirst($str));//string(11) "Hello world"
  var_dump(ucwords($str));//string(11) "Hello World"
  var_dump(mb_convert_case($str,MB_CASE_TITLE,'UTF-8'));//string(11) "Hello World"
  ```