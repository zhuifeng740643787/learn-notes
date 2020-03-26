# 模板方法模式（TemplateMethod）

## 概念
- 又叫模板模式
- 该模式在一个方法中定义一个算法的骨架，而将一些步骤延迟到子类中，使得子类可以在不改变算法结构的情况下，重新定义算法的某些步骤
- 将主要的方法定义为final，防止子类修改算法骨架，将子类必须实现的方法定义为abstract，而普通的方法则称之为钩子（hook）

## 角色
- 抽象模板角色(Templete)：
  - 定义一个或多个抽象方法让子类实现。这些抽象方法叫做基本操作，它们是顶级逻辑的组成部分。
  - 定义一个模板方法。这个模板方法一般是一个具体方法，它给出顶级逻辑的骨架，而逻辑的组成步骤在对应的抽象操作中，这些操作将会推迟到子类中实现。同时，顶层逻辑也可以调用具体的实现方法
- 具体模板角色(ConcreteTemplete)：实现父类的一个或多个抽象方法，作为顶层逻辑的组成而存在。

## 适用场景
- 一次性实现一个算法的不变不封，并将可变的行为留给子类来实现
- 各子类中公共的行为应被提取出来并集中到一个公共父类中以避免代码重复
- 控制子类扩展

## 示例
- 去银行办理业务：存款、取款、办卡

      <?php
      /* 抽象模板角色 */
      abstract class BankBusiness
      {
          private static $_num = 0;//排队号码

          //模板方法 - 算法骨架
          public final function process()
          {
              $this->takeNum();//区号
              $this->transact();//交易
              if($this->hasEvaluate()) {//是否评价
                  $this->evaluate();//评价
              }
          }
          //基本方法
          private function takeNum() {
              echo "取号：" . ++self::$_num . PHP_EOL;
          }
          //抽象方法 - 延迟给子类实现
          protected abstract function transact();
          //钩子方法
          protected function hasEvaluate() {
              return false;
          }
          //钩子方法
          protected function evaluate() {
              echo "10分评价" . PHP_EOL;
          }
      }
      /* 具体角色 */
      class Deposit extends BankBusiness {
          function transact() {
              echo "存款" . PHP_EOL;
          }
      }
      /* 具体角色 */
      class Withdraw extends BankBusiness {
          function transact() {
              echo "取款" . PHP_EOL;
          }
      }
      /* 具体角色 */
      class Card extends BankBusiness {
          function transact() {
              echo "办卡" . PHP_EOL;
          }
          public function hasEvaluate() {
              return true;
          }
          //钩子方法
          protected function evaluate() {
              echo "差评" . PHP_EOL;
          }

      }

      $business1 = new Deposit();
      $business1->process();
      $business2 = new Withdraw();
      $business2->process();
      $business3 = new Card();
      $business3->process();

