<?php
/**
 * Created by PhpStorm.
 * User: gongyidong
 * Date: 2018/7/12
 * Time: 下午2:52
 */
error_reporting(E_ERROR);
ini_set('date.timezone', 'Asia/Shanghai');

/**
 * 获取目录下最后修改的修改
 * @property $dir 目录
 * @property $start_time 开始时间,时间戳格式
 */
class Solution
{
    protected $dir;
    protected $start_time;

    function __construct($dir, $start_time)
    {
        $this->dir = realpath($dir);
        $this->start_time = $start_time;
    }


    function getLastModifyFiles()
    {
        $this->log('目录：' . $this->dir . "\t" . '时间：' . date('Y-m-d H:i:s', $this->start_time));
        if (time() < $this->start_time) {
            $this->log('空');
            return;
        }

        if (!file_exists($this->dir) || !is_dir($this->dir)) {
            $this->log('目录不存在');
            return;
        }

        // 递归目录文件
        $this->_handleDir($this->dir, 0);
    }

    private function _handleDir($dir, $depth)
    {
        if ($dh = opendir($dir)) {
            while (($file = readdir($dh)) !== false) {
                if (in_array($file, ['.', '..', '.gitignore', '.git', '.idea'], true) || strpos($file, 'log') !== false) {
                    continue;
                }
                $file_path = $dir . DIRECTORY_SEPARATOR . $file;
                $modify_time = filemtime($file_path);
                if ($modify_time < $this->start_time) {
                    continue;
                }
                $prefix_str = str_repeat("  ", $depth) . '> ';
                if (is_dir($file_path)) {
                    $this->log($prefix_str . $file);
                    $this->_handleDir($file_path, $depth + 1);
                } else {
                    $this->log($prefix_str . $file . "\t" . date('Y-m-d H:i:s', $modify_time));
                }
            }
            closedir($dh);
        }
    }

    function log($message)
    {
        print_r($message);
        echo PHP_EOL;
    }
}

$dir = !empty($argv[1]) ? $argv[1] : __DIR__;
$time = !empty($argv[2]) ? strtotime($argv[2]) : time();
$handle = new Solution($dir, $time);
$handle->getLastModifyFiles();