# 数据类型

## 基本类型
- 布尔型(bool)
    + `++ 或 -- 操作，值不变`
    + false的7种情况
        - `0, 0.0, '0', '', [], false, null`
- 整型(int)
- 浮点型(float)
    `不能进行运算，因为在转换为二进制格式时会丢失一点点精度`
- 字符串(string)
    + 三种表示方式：
        1. 单引号：不解析变量
        2. 双引号：解析变量
        3. heredoc / newdoc: 处理大文本
            ```
            heredoc类似于双引号作用，<<<EOT ... EOT(需置于行头)
            newdoc类十余单引号作用，<<<'EOT' ... EOT(需置于行头)
            ```
- 数组(array)
    + 超全局数组
        `$GLOBALS, $_GET, $_POST, $_REQUEST, $_SESSION, $_COOKIE, $_SERVER, $_FILES, $_ENV`
        ```
        $_SERVER['SERVER_ADDR']: 服务器地址
        $_SERVER['REMOTE_ADDR']: 客户端地址
        $_SERVER['SERVER_NAME']: 服务器主机名
        $_SERVER['REQUEST_TIME']: 请求时间
        $_SERVER['QUERY_STRING']: 查询字符串(问号后面的数据)
        $_SERVER['HTTP_USER_AGENT']: 用户代理信息
        $_SERVER['PATH_INFO']: 跟在真是脚本名称之后且在QUERY_STRING之前的路径信息
        $_SERVER['HTTP_REFERER']: 引导用户代理到当前页的前一页的地址
        ```

- 对象(object)
- 资源类型(resource)
- 空(null)
    + `三种情况：直接赋值为null、未定义的变量、unset销毁的变量`
    + `--操作，值不变， ++操作，值变为1`
- 回调类型（Callback / Callable）

## 常量
- 定义之后不能改变
- 定义方式
    + define: 是一个函数
    + const: 是一个语言结构，更快，可以定义类的常量

## 预定义常量
- `__FILE__, __LINE__, __DIR__, __FUNCTION__, __CLASS__, __TRAIT__, __METHOD__, __NAMESPACE__`




















