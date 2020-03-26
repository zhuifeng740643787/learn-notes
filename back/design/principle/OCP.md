# 开放封闭原则（Open-Closed Principle OCP）

## 核心思想
- **软件实体应该是可扩展的，不可修改的。也就是，对扩展开放，对修改封闭的**

## 概念
软件实体应该**对扩展开放，对修改封闭**。是所有面向对象原则的核心。软件设计本身所追求的目标就是**封装变化，降低耦合**，而开放封闭原则就是这一目标的最直接体现。
  + 封装变化，是实现开放封闭原则的重要手段，对于经常发生变化的状态，一般将其封装为一个**抽象**。
  + 拒绝滥用抽象，只将经常变化的部分进行抽象。

## 体现
  + 对扩展开放：意味着有新的需求或**变化**时，可以对现有代码进行扩展，以适应新的情况。
  + 对修改封闭：意味着类一旦设计完成，就可以独立工作，而不要对类进行任何修改。


## 优点
软件需求总是变化的，世界上没有一个软件的是不变的，因此对软件设计人员来说，必须在不需要对原有系统进行修改的情况下，实现灵活的系统扩展。
    
## 示例
以银行业务员为例：
- 不符合OCP

      <?php
      class BankProcess {
        //存款
        function deposite(){}
        //取款
        function withdraw(){}
        //转账
        function transfer(){}
      }
      //调用
      $process = new BankProcess();
      $type = 'xxx';
      switch($type) {
        case 'deposite': //存款
          $process->deposite();break;
        case 'withdraw': //取款
          $process->withdraw();break;
        case 'transfer': //转账
          $process->transfer();break;
      }

    - 缺点：目前设计中就只有存款，取款和转账三个功能，将来如果业务增加了，比如增加申购基金功能，理财功能等，就必须要修改BankProcess业务类。我们分析上述设计就会发现把多个业务封装在一个类里面，违反单一职责原则，而有新的需求发生，必须修改现有代码则违反了开放封闭原则。
    - 改进：使用抽象，将业务功能抽象为接口，当业务员依赖于固定的抽象时，对修改就是封闭的，而通过继承和多态继承，从抽象体中扩展出新的实现，就是对扩展的开放。

- 符合OCP
  
      <?php
      /* 业务处理接口 */
      interface IBankProcess{
        function process();
      }
      class DepositeProcess implements IBankProcess {
        function process() {
          echo '存款';
        }
      }    
      class WithdrawProcess implements IBankProcess {
        function process() {
          echo '取款';
        }
      }    
      class TransferProcess implements IBankProcess {
        function process() {
          echo '转账';
        }
      }    
      //调用
      $type = 'xxx';
      switch($type) {
        case 'deposite': //存款
          $process = new DepositeProcess(); break;
        case 'withdraw': //取款
          $process = new WithdrawProcess();break;
        case 'transfer': //转账
          $process = new TransferProcess();break;
      }  
      $process->process();

    - 说明：这样当业务变更时，只需要修改对应的业务实现类就可以，其他不相干的业务就不必修改。当业务增加，只需要增加业务的实现就可以了。



