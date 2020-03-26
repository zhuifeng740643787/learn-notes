<?php

$dir = __DIR__;

process($dir);

function process($dir) {
    if (!is_dir($dir)) {
        return;
    }
    $dir_handler = opendir($dir);
    while ($file = readdir($dir_handler)) {
        if ($file == '.' || $file == '..') {
            continue;
        }
        if (strpos($file, '.log') === mb_strlen($file) - 4) {
            continue;
        }
        $file = $dir . DIRECTORY_SEPARATOR . $file;
        if (strpos($file, 'temp/data_caches/') > 0) {
            continue;
        }
        if(is_dir($file)) {
            process($file);
        }
        // 处理文件
        if (fileowner($file) == 0 || filegroup($file) == 0) {
            echo $file . PHP_EOL;
        }
    }

    closedir($dir_handler);
}