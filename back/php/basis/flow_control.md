# 流程控制

## 数组遍历方式
- for循环：只能遍历索引数组
- foreach：可遍历索引和关联数组,`会reset数组指针`
- 联合使用list/each/while：`不会reset数组指针`

## 分支
- if ... elseif ... else: 
    ```
    只有一个表达式为true;
    尽量可能性大的表达式放在if后面
    ```
- switch ... case ...: 
    ```
    会生成跳转索引表，直接跳转到相应的case, 所以执行效率相对会较快;
    只能判断整型、浮点型、字符串;
    case中的continue与break作用相同;
    如果switch外层有for循环，跳出上层循环用continue2
    switch($var) {
        case: 
        break;  
    }
    ```
    
