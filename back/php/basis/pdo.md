# PDO

```php
<?php
try {
    $mysql = new PDO('mysql:dbname=test;host=127.0.0.1;', 'root', '111111', [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, // 错误模式
        PDO::ATTR_EMULATE_PREPARES => false, // 不使用模拟预处理的方式，且返回原生数据类型
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ, // 默认数据返回类型
    ]);
    $query = $mysql->prepare('select * from user where id > :ID');
    $query->execute([':ID' => 1]);
    while ($row = $query->fetch(PDO::FETCH_OBJ)) {
        echo ($row->name) . PHP_EOL;
    }

    $insert_sql = $mysql->prepare('insert into user(name, age, num) values(:name, :age, :num)');
    $result = $insert_sql->execute([':name' => 'aaa', ':age' => 111, ':num' => rand(0, 100)]);
    var_dump($result);


    $query->execute([':ID' => 1]);
    while ($row = $query->fetch(PDO::FETCH_OBJ)) {
        echo ($row->name) . PHP_EOL;
    }
} catch (PDOException $e) {
    echo ($e->getMessage());
}

```