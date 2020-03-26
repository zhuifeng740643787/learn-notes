# 代码规范
[参考文档](https://www.kancloud.cn/thinkphp/php-fig-psr/3139)
- 文件
    + 必须以`<?php`标签开始
    + 尾部不要添加`?>`
- 缩进
    + 4个空格，而不是一个tab
- 字符编码
    + 不带BOM头的UTF-8格式
    + 切记不要使用window系统的记事本编写文件
- 命名
    + 类：驼峰式，首字母大写
    + 变量：全小写，单词间用`_`分隔
    + 常量：全大写，单词间用`_`分隔
    + 函数：驼峰式，首字母小写
- 属性
    + 必须添加访问修饰符
    + 不可使用关键字 var 声明一个属性
- 方法
    + 必须添加访问修饰符
- 关键字
    + 必须小写，如`true/false/null`
- 注释
    + 复杂逻辑一定要有注释
- 例子
```php

<?php declare(strict_types=1);
/**
 * PHP代码示例
 * User: xxx
 * Date: 2019/10/24
 * Time: 2:19 PM
 */

namespace App;

class PhpCodeExample
{

    // 类型1
    const TYPE_ONE = 1;
    // 类型2
    const TYPE_TWO = 2;

    /**
     * 名称
     * @var string
     */
    protected $name;

    /**
     * 属性列表
     * @var array
     */
    protected $attributes;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    /**
     * @return string
     */
    public function getName(): string
    {
        return $this->name;
    }

    /**
     * 获取属性
     * @param string $key 属性名
     * @param string $default 属性不存在时，返回的默认值
     * @return mixed|string
     */
    public function getAttribute(string $key, $default = '')
    {
        return $this->attributes[$key] ?? $default;
    }

    /**
     * 设置属性值
     * @param $key
     * @param $value
     */
    public function setAttribute(string $key, $value): void
    {
        $this->attributes[$key] = $value;
    }

    /**
     * 处理复杂逻辑, 写好注释
     * 1. 第1步。。。
     * 2. 第2步。。。
     * 3. 第3步。。。
     * 4. 第4步。。。
     * 5. 第5步。。。
     * @return array
     */
    public function processComplexLogic()
    {
        // 1. 第1步。。。
        // 2. 第2步。。。
        // 3. 第3步。。。
        // 4. 第4步。。。
        // 5. 第5步。。。
        return [];
    }

}
```