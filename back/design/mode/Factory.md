# 工厂模式（Factory）

[参考地址](https://segmentfault.com/a/1190000007473294)

## 概念
- 是我们最常用的实例化对象的模式
- 是用工厂方法代替*new*操作的一种模式

## 优点
- 如修改实例化的类名时，只需修改该工厂方法的内容即可，不需逐一寻找代码中具体实例化的地方(*new*处)修改了。为系统结构提供**灵活的动态扩展机制，减少了耦合**。

## 细分
- [简单工厂模式](#简单工厂模式)
- [工厂方法模式](#工厂方法模式)
- [抽象工厂模式](#抽象工厂模式)

### 简单工厂模式
- 又称静态工厂方法模式，通过一个静态方法来创建对象
- 代码示例

      <?php
      /* 定义人类的接口 */
      interface People {
        function say();
      }
      class Man implements People {
        function say() {
          echo "Man";
        }
      }
      class Women implements People {
        function say() {
          echo "Women";
        }
      }
      /* 工厂类 */
      class SimpleFactory {
        // 静态方法-创建对象
        static function createMan(){
          return new Man();
        }
        static function createWomen(){
          return new Women();
        }
      }
      //调用
      $man = SimpleFactory::createMan();
      $man->say(); // 输出 Man
      $women = SimpleFactory::createWomen();
      $women->say(); // 输出 Women

### 工厂方法模式
- 定义**一个**用于创建对象的接口，让子类决定哪个类实例化
- 可以解决简单工厂模式中的**[开放封闭原则](../principle/OCP.md)**问题
- 代码示例：

      <?php
      /* 定义人类的接口 */
      interface People {
        function say();
      }
      class Man implements People {
        function say(){echo "Man";}
      }
      class Women implements People {
        function say(){echo "Women";}
      }
      /* 将对象的创建抽象成一个接口 */
      interface CreatePeople {
        function create();
      }
      class FactoryMan implements CreatePeople {
        function create() {
          return new Man();
        }
      }
      class FactoryWomen implements CreatePeople {
        function create() {
          return new Women();
        }
      }
      /*调用*/
      $manFactory = new FactoryMan();      
      $man = $manFactory->create();
      $man->say();
      $womenFactory = new FactoryWomen();      
      $women = $womenFactory->create();
      $women->say();

## 抽象工厂模式
- 提供一个创建**一系列**相关或相互依赖对象的接口
- 和工厂方法的区别是：一系列（多个）,而工厂方法只有一个
- 代码示例：

      <?php
      interface People {
        function say();
      }
      class OneMan implements People {
        function say(){ echo "OneMan"; }
      }
      class TwoMan implements People {
        function say(){ echo "TwoMan"; }
      }
      class OneWomen implements People {
        function say(){ echo "OneWomen"; }
      }
      class TwoWomen implements People {
        function say(){ echo "TwoWomen"; }
      }
      /* 定义一个创建一系列对象的接口，含有多个工厂方法 */
      interface CreatePeople {
        function createOne();
        function createTwo();
      }
      class FactoryMan implements CreatePeople {
        function createOne(){
          return new OneMan();
        }
        function createTwo(){
          return new TwoMan();
        }
      }

      class FactoryWomen implements CreatePeople {
        function createOne(){
          return new OneWomen();
        }
        function createTwo(){
          return new TwoWomen();
        }
      }

      /* 调用 */
      $manFactory = new FactoryMan();
      $oneMan = $manFactory->createOne();
      $oneMan->say();
      $twoMan = $manFactory->createTwo();
      $twoMan->say();

      $womenFactory = new FactoryWomen();
      $oneWomen = $womenFactory->createOne();
      $oneWomen->say();
      $twoWomen = $womenFactory->createTwo();
      $twoWomen->say();

## 区别
- 简单工厂模式（静态方法工厂模式）: 用来生成同一等级结构中的固定产品（不能增加新的产品）
- 工厂方法模式: 用来生成同一等级的任意产品（支持添加任意产品）
- 抽象工厂模式: 用来生产不同产品种类的全部产品（不能增加新的产品，支持增加产品种类）


## 适用范围
- 简单工厂模式：工厂类负责创建的对象较少，操作时只需知道传入工厂类的参数即可，对于如何创建对象过程不用关心。
- 工厂方法模式：满足以下条件时，可以考虑使用工厂方法模式
  - 当一个类不知道它所必须创建对象的类时
  - 一个类希望由子类来指定它所创建的对象时
  - 当类将创建对象的职责委托给多个帮助子类中的某一个，并且你希望将哪一个帮助子类是代理者这一信息局部化时
- 抽象工厂模式：满足以下条件时，可以考虑使用抽象工厂模式
  - 系统不依赖于产品类实例如何被创建，组合和表达的细节。
  - 系统的产品有多于一个的产品族，而系统只消费其中某一族的产品
  - 同属于同一个产品族是在一起使用的。这一约束必须在系统的设计中体现出来。
  - 系统提供一个产品类的库，所有产品以同样的接口出现，从而使客户端不依赖于实现

以上几种，归根结底，都是将重复的东西提取出来，以方便整体解耦和复用，修改时方便。可根据具体需求而选择使用。























