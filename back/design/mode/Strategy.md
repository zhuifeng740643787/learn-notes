# 策略模式（Strategy）

[参考地址](https://segmentfault.com/a/1190000007523487)

## 概念
- 定义了一系列算法，并将每一个算法分别封装起来，而且让它们之间可以相互替换。
- 让算法独立于使用它的客户而独立变化

## 组成
- 抽象策略角色：策略类，通常有一个接口或抽象类实现
- 具体策略角色：封装了相关的算法和行为
- 环境角色：持有一个策略类的引用，最终给客户端调用

## 应用场景
- 多个类只区别在表现行为不同，可以使用策略模式，在运行时动态选择具体要执行的行为。
- 需要在不同情况下使用不同的策略(算法)，或者策略还可能在未来用其它方式来实现。
- 对客户隐藏具体策略(算法)的实现细节，彼此完全独立

## 优点
- 策略模式提供了管理相关的算法族的办法。
- 策略类的等级结构定义了一个算法或行为族。
- 恰当使用继承可以把公共的代码转移到父类里面，从而避免重复的代码。
- 策略模式提供了可以替换继承关系的办法。继承可以处理多种算法或行为。如果不是用策略模式，那么使用算法或行为的环境类就可能会有一些子类，每一个子类提供一个不同的算法或行为。但是，这样一来算法或行为的使用者就和算法或行为本身混在一起。决定使用哪一种算法或采取哪一种行为的逻辑就和算法或行为的逻辑混合在一起，从而不可能再独立演化。继承使得动态改变算法或行为变得不可能。
- 使用策略模式可以避免使用多重条件转移语句。多重转移语句不易维护，它把采取哪一种算法或采取哪一种行为的逻辑与算法或行为的逻辑混合在一起，统统列在一个多重转移语句里面，比使用继承的办法还要原始和落后。

## 缺点
- 客户端必须知道所有的策略类，并自行决定使用哪一个策略类。这就意味着客户端必须理解这些算法的区别，以便适时选择恰当的算法类。换言之，策略模式只适用于客户端知道所有的算法或行为的情况。
- 策略模式造成很多的策略类，每个具体策略类都会产生一个新类。有时候可以通过把依赖于环境的状态保存到客户端里面，而将策略类设计成可共享的，这样策略类实例可以被不同客户端使用。换言之，可以使用享元模式来减少对象的数量。

## 示例
- 电商网站首页根据登录用户的性别不同展示不同的广告和目录
- 代码实现：

      <?php
      /* 抽象策略角色 */
      interface IUserStrategy {
          function showAd();
          function showCategory();
      }
      /* 具体策略角色 */
      class MaleStrategy implements IUserStrategy {
          function showAd(){
              echo "Male Ad \r\n";
          }
          function showCategory(){
              echo "Male Category \r\n";
          }
      }
      /* 具体策略角色 */
      class FemaleStrategy implements IUserStrategy {
          function showAd(){
              echo "Felale Ad \r\n";
          }
          function showCategory(){
              echo "Female Category \r\n";
          }
      }
      /* 环境角色 */
      class HomePage {
          protected $strategy;
          public function setStrategy(IUserStrategy $strategy) {
              $this->strategy = $strategy;
          }
          function show(){
              $this->strategy->showAd();
              $this->strategy->showCategory();
          }
      }

      //调用
      $page = new HomePage();
      $page->setStrategy(new MaleStrategy());
      $page->show();






