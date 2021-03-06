# 打印

## echo 命令
- 是命令,输出一个或多个字符串或变量值,不能输出数组或对象
- 参数是一个或多个字符串或变量值,之间用分号间隔
- 无返回值

## print 函数
- 是函数，打印字符，不能打印数组或对象
- 只能有一个参数，
- 总返回1
- **print() 稍慢于 echo()**

## print_r函数
- 是函数，打印关于变量的易于理解的信息
- 第一个参数可以是数组、对象
- 第二个参数设为true, 则要打印的数组作为返回值返回

## var_dump函数 
- 是函数，显示关于一个或多个表达式的结构信息，包括表达式的类型与值。数组将递归展开值，通过缩进显示其结构
- 它是直接将结果输出到浏览器的，如果需要将结果保存到一个string变量中，可使用输出控制函数来捕获当前函数的输出
- 第二个参数设为true, 则要打印的数组作为返回值返回

## var_export函数
- 是函数，用于输出或返回一个变量的字符串表示。
- 第一个参数可以是数组、对象
- 第二个参数设为true, 则要打印的数组作为返回值返回

## printf函数
- 是函数，格式化输出字符串
- 无返回值
```
printf(format,arg1,arg2,arg++)

格式：
%% - 返回一个百分号 %
%b - 二进制数
%c - ASCII 值对应的字符
%d - 包含正负号的十进制数（负数、0、正数）
%e - 使用小写的科学计数法（例如 1.2e+2）
%E - 使用大写的科学计数法（例如 1.2E+2）
%u - 不包含正负号的十进制数（大于等于 0）
%f - 浮点数（本地设置）
%F - 浮点数（非本地设置）
%g - 较短的 %e 和 %f
%G - 较短的 %E 和 %f
%o - 八进制数
%s - 字符串
%x - 十六进制数（小写字母）
%X - 十六进制数（大写字母）
附加的格式值。必需放置在 % 和字母之间（例如 %.2f）：
+ （在数字前面加上 + 或 - 来定义数字的正负性。默认地，只有负数做标记，正数不做标记）
' （规定使用什么作为填充，默认是空格。它必须与宽度指定器一起使用。）
- （左调整变量值）
[0-9] （规定变量值的最小宽度）
.[0-9] （规定小数位数或最大字符串长度）

```
## sprintf函数
- 是函数，把格式化的字符串写入变量中
- 格式跟printf一样
- 有返回值
