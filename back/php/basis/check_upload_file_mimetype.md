# 检查上传文件的真实mimetype

PHP处理上传文件信息数组中的文件类型$_FILES['type']由客户端浏览器提供，有可能是黑客伪造的信息，请写一个函数来确保用户上传的图像文件类型真实可靠

## 解决方案
- 使用mime_content_type函数
  ```
  mime_content_type($filename);
  ```
- 使用Fileinfo
  ```
  $finfo = finfo_open(FILEINFO_MIME_TYPE);
  echo finfo_file($finfo, $filename);
  finfo_close($finfo);
  ```

## 示例
  - 使用curl模拟上传
  ```
  curl -F "image=@/xxx/xx.jpg;type=text/csv;" http://xxx/xxx
  ```
  - 获取类型
  ```
  <?php
    p($_FILES);
    p(mime_content_type($_FILES['image']['tmp_name']));
    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    echo finfo_file($finfo, $_FILES['image']['tmp_name']);br();
    finfo_close($finfo);

    function p(...$str) {
       if(is_array($str)) {
           foreach ($str as $s) {
               print_r($s);
               br();
           }
           return;
       }
       print_r($str);
    }
    function br() {
        echo "\r\n";
    }
  ```