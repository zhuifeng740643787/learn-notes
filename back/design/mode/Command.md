# 命令模式（Command）

## 概念
- 将请求封装成对象，从而使你可用不同的请求对客户进行参数化，对请求排队或记录请求日志，以及支持可撤销的操作
- 对命令的封装，把发出命令的责任和执行命令的责任分隔开，委派给不同的对象

## 角色
- 抽象命令角色(Command): 声明了一个给所有具体命令类的抽象接口。这是一个抽象角色。
- 具体命令角色(ConcreteCommand): 定义一个接收者和行为之间的弱耦合；实现Execute()方法，负责调用接收者的相应操作。Execute()方法通常叫做执行方法
- 请求者角色(Invoker): 负责调用命令对象执行请求，相关的方法叫做行动方法(action)
- 接收者角色(Receiver): 负责具体实施和执行一个请求。任何一个类都可以成为接收者，实施和执行请求的方法叫做行动方法(action)

## 适用场景
- 抽象出待执行的动作以参数化对象。Command模式是回调机制的一个面向对象的替代品
- 在不同的时刻指定、排列和执行请求
- 支持取消操作
- 支持修改日志
- 用构建在原语操作上的高层操作构造一个系统。Command模式提供了对事务进行建模的方法。Command有一个公共的接口，使得你可以用同一种方式调用所有的事务。同时使用该模式也易于添加新事务以扩展系统

## 优点
- 命令模式把请求一个操作的对象与知道怎么执行一个操作的对象分离开
- 命令类与其他任何别的类一样，可以修改和推广
- 可以把命令对象聚合在一起，合成为合成命令
- 可以很容易的加入新的命令类

## 缺点
- 可能会导致某些系统有过多的具体命令类

## 示例

    <?php
    /* 抽象命令角色 */
    abstract class Command {

        protected $receiver;

        public function __construct(Receiver $receiver)
        {
            $this->receiver = $receiver;
        }
        abstract function execute();

    }
    /* 具体命令角色 */
    class ConcreteCommand1 extends Command {
        function execute() {
            echo "ConcreteCommand1 execute" . PHP_EOL;
            $this->receiver->action();
        }
    }
    class ConcreteCommand2 extends Command {
        function execute() {
            echo "ConcreteCommand2 execute" . PHP_EOL;
            $this->receiver->action();
        }
    }
    /* 请求者角色 */
    class Invoker {

        private $_command;

        public function __construct(Command $command)
        {
            $this->_command = $command;
        }

        public function action()
        {
            $this->_command->execute();
        }
    }
    /* 接收者角色 */
    interface Receiver {
        function action();
    }
    class Receiver1 implements Receiver {
        function action() {
            echo "Receiver1 action" . PHP_EOL;
        }
    }
    class Receiver2 implements Receiver {
        function action() {
            echo "Receiver2 action" . PHP_EOL;
        }
    }

    //调用
    $receiver1 = new Receiver1();
    $receiver2 = new Receiver2();
    $command1 = new ConcreteCommand1($receiver1);
    $command2 = new ConcreteCommand2($receiver2);
    $invoker1 = new Invoker($command1);
    $invoker1->action();
    $invoker2 = new Invoker($command2);
    $invoker2->action();


