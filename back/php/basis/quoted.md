# 引用机制

## COW
- 写时复制机制
```php
<?php
    $a = range(0,1000); // 开辟一块空间A
    echo memory_get_usage(); // 查看内存使用情况
    xdebug_debug_zval('a'); // 查看变量 a 引用情况 refcount: 指向这块内存的变量个数 is_ref: 是否为引用
    $b = $a; // 此时指向空间A
    echo memory_get_usage();
    $a = range(1,10);// 重新开辟一块空间B， $a指向B
    echo memory_get_usage();
```

## 引用
- 定义：用不同的名字访问同一个变量内容，使用 & 符号
```php
<?php
    $a = range(0, 10);// 开辟空间A
    $b = &$a; // $b引用$a,指向空间A
    $a = range(1,3);// $a改变，空间A中的数据改变，$b的值也随之改变
    
    unset($a);// 只会取消引用，而不会销毁空间A
    
    class Person {
        public $name = 'A';
    }
    
    $p1 = new Person;
    $p2 = $p1; // 对象赋值本身就是一种引用传递, 但引用计数不会增加，只是不进行写时复制了
    $p1->name = 'B'; // name值改变，$p2的name值也随之改变
    
```



