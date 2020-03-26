# 接口隔离原则（Interface Segregation Principle ISP）

## 核心概念
- 客户端不应该依赖它不需要的接口
- 一个类对另一个类的依赖应该建立在最小的接口上

## 概念
- 建立单一接口，不要建立庞大臃肿的接口，尽量细化接口，接口中的方法尽量少
- 要为各个类建立专用的接口，而不要试图去建立一个很庞大的接口供所有依赖它的类去调用

## 与[单一职责原则](SRP.md)的区别
- 单一职责原则原注重的是**职责**；而接口隔离原则注重对**接口依赖的隔离**
- 单一职责原则主要是**约束类**，其次才是接口和方法，它针对的是程序中的**实现和细节**；而接口隔离原则主要**约束接口**，主要**针对抽象**，针对程序整体框架的构建。

## 注意
- **接口尽量小，但是要有限度**。对接口进行细化可以提高程序设计灵活性是不挣的事实，但是如果过小，则会造成接口数量过多，使设计复杂化。所以一定要**适度**。
- 为依赖接口的类定制服务，**只暴露给调用的类它需要的方法，它不需要的方法则隐藏起来**。只有专注地为一个模块提供定制服务，才能建立最小的依赖关系。
- **提高内聚，减少对外交互**。使接口用最少的方法去完成最多的事情。

## 示例
- 未遵循ISP原则的设计

      <?php
      /*定义一个臃肿的接口*/
      interface I {
        function method1();
        function method2();
        function method3();
      }
      class A {
        function depend1(I $i) { $i->method1(); }
        function depend2(I $i) { $i->method2(); }
      }
      class B implements I {
        function method1(){***}
        function method2(){***}
        //不需要的方法
        function method3(){}
      }
      class C {
        function depend1(I $i) { $i->method1(); }
        function depend3(I $i) { $i->method3(); }
      }
      class D implements I {
        function method1(){***}
        //不需要的方法
        function method2(){}
        function method3(){***}
      }

      //调用
      $a = new A();
      $a->depend1(new B());
      $a->depend2(new B());
      $c = new C();
      $c->depend1(new D());
      $c->depend3(new D());

可以看到，如果接口过于臃肿，只要接口中出现的方法，不管对依赖于它的类有没有用处，实现类中都必须去实现这些方法，这显然不是好的设计。如果将这个设计修改为符合接口隔离原则，就必须对接口I进行拆分。

- 遵循ISP原则

      <?php
      /*接口拆分*/
      interface I1{
        function method1();
      }
      interface I2{
        function method2();
      }
      interface I3{
        function method3();
      }
      class A {
        function depend1(I1 $i) { $i->method1(); }
        function depend2(I2 $i) { $i->method2(); }
      }
      class B implements I1, I2 {
        function method1(){***}
        function method2(){***}
      }
      class C {
        function depend1(I1 $i) { $i->method1(); }
        function depend3(I3 $i) { $i->method3(); }
      }
      class D implements I1, I3 {
        function method1(){***}
        function method3(){***}
      }
      //调用
      $a = new A();
      $a->depend1(new B());
      $a->depend2(new B());
      $c = new C();
      $c->depend1(new D());
      $c->depend3(new D());
