# 文件

## 打开模式 (fopen函数)
- r : 只读方式打开，将文件指针指向文件头
- r+: 读写方式打开，将文件指针指向文件头
- w : 写入方式打开，将文件指针指向文件头并将文件大小截为0，文件不存在则尝试创建之
- w+: 读写入方式打开，将文件指针指向文件头并将文件大小截为0，文件不存在则尝试创建之
- a : 写入方式打开，将文件指针指向文件末尾，文件不存在则尝试创建之
- a+: 读写方式打开，将文件指针指向文件末尾，文件不存在则尝试创建之
- x : 创建并以写入方式打开，将文件指针指向文件头，如果文件存在，则抱E_WARNING级别的错误，返回false
- x+: 创建并以读写方式打开，将文件指针指向文件头，如果文件存在，则抱E_WARNING级别的错误，返回false
- b : 强制使用二进制模式，这样就不会转换数据，需配合其他模式使用
- t : windows下提供的一个文本转换标记，可透明的将\n转换为\r\n，需配合其他模式使用


## 文件操作常用函数
- 写入
    + fwrite()
    + fputs()
- 读取
    + fread()
    + fgets()
    + fgetc()
- 关闭
    + fclose()
- 不需要使用fopen打开的函数
    + file_get_contents()
    + file_put_contents()
- 其他读取函数
    + file()
    + readfile()
- 访问远程文件
    + 需开启allow_url_fopen, HTTP协议连接只能使用只读，FTP协议可以使用只读或只写
- 文件大写
    + filesize()
- 删除文件
    + unlink()
- 文件截取
    + ftruncate()
- 文件锁定
    + flock
        - LOCK_SH: 读锁，共享锁
        - LOCK_EX: 写锁，独占锁
        - LOCK_UN: 释放锁
    

## 目录操作常用函数
- 名称相关
    + basename()
    + dirname()
    + pathinfo()
- 目录读取
    + opendir()
    + readdir()
    + closedir()
    + rewinddir()
- 目录创建
    + mkdir()
- 目录删除
    + rmdir(): `目录为空时才能删除，注意..文件`

## 磁盘函数
- 磁盘剩余空间
    + disk_free_space()
- 磁盘大写
    + disk_total_space()

## 文件或目录
- 文件类型
    + filetype()
- 重命名(含有mv功能)
    + rename()
- 文件属性
    + file_exists() // 文件是否存在
    + is_readable() // 是否可读
    + is_writeable() // 是否可写
    + is_executable() // 是否可执行
    + filectime() // 上次索引节点被修改的时间
    + fileatime() // 上次访问时间
    + filemtime() // 上次修改时间


## 案例
- 文件获取锁，并写入文件
```php
<?php
$f = fopen('aa.txt', 'a+'); // 文件追加方式打开文件
if (flock($f, LOCK_SH)) { // 获取独占锁
    fwrite($f, "上锁了\r\n");
    flock($f, LOCK_UN); // 释放锁
}
fclose($f); // 关闭文件句柄
```

- 遍历文件夹
```php
<?php

function makeSpaces($num) {
    $str = '';
    for ($i = 0; $i < $num; $i++) {
        $str .= "  ";
    }
    return $str;
}
function loopDir($dir, $depth) {
    if (!$dir) {
        return;
    }
    echo makeSpaces($depth) . ($depth == 0 ? '' : '|- ') . basename($dir) . "\r\n";
    if (filetype($dir) == 'dir') {
        $handle = opendir($dir);
        while (($file = readdir($handle)) !== false) {
            if ($file == '.' || $file == '..') {
                continue;
            }
            loopDir($dir . '/' . $file, $depth + 1);
        }
        return;
    }
}

$path = dirname(dirname(__DIR__));
loopDir($path, 0);
```


















