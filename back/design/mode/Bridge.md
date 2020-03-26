# 桥梁模式（Bridge）

## 概念
- 将抽象部分与实现部分分离，使它们都可以独立的变化

## 意图
- 将**抽象化**与**实现化**_脱耦_，使得两者可以独立地变化

## 关键词
- 抽象化
存在于多个实体中的共同的概念性联系，就是抽象化。作为一个过程，抽象化就是忽略一些信息，从而把不同的实体当做同样的实体对待

- 实现化
抽象化给出的具体实现，就是实现化

- 脱耦
所谓耦合，就是两个实体的行为的某种强关联。而将它们的强关联去掉，就是耦合的解脱，或称脱耦。在这里，脱耦是指将抽象化和实现化之间的耦合解脱开，或者说是将它们之间的强关联改换成弱关联。将两个角色之间的继承关系改为聚合关系，就是将它们之间的强关联改换成为弱关联。因此，桥梁模式中的所谓脱耦，就是指在一个软件系统的抽象化和实现化之间使用组合/聚合关系而不是继承关系，从而使两者可以相对独立地变化。这就是桥梁模式的用意

# 角色
- 抽象化角色(Abstraction)：抽象化给出的定义，并保存一个对现实化对象的引用
- 修正抽象化角色(Redefined Abstraction)：扩展抽象化角色，改变和修正父类对抽象化的定义
- 抽象实现化角色(Implementor)：给出实现化的角色接口，但不给出具体实现。这个接口不一定和抽象化角色的接口定义相同，可以非常的不一样。实现化角色只给出底层操作，而抽象化角色应当只给出基于底层操作的更高一层的操作
- 具体实现化角色(ConcreteImplementor)：给出抽象实现化角色接口的具体实现

## 适用场景
- 如果一个系统需要在构件的抽象化和具体化角色之间增加更多的灵活性，避免在两个层次之间建立静态的联系
- 设计要求实现化角色的任何改变不应当影响客户端，或者说实现化角色的改变对客户端是完全透明的
- 一个构件有多于一个的抽象化角色和实现化角色，并且系统需要它们之间进行动态的耦合
- 虽然在系统中使用继承是没有问题的，但是由于抽象化角色和具体化角色需要独立变化，设计要求需要独立管理这两者

## 优点
- 分离接口及其实现部分: 将Abstraction与Implementor分享有助于降低对实现部分编译时刻的依赖性; 
  接口与实现分享有助于分层，从而产生更好的结构化系统
- 抽象和实现可以独立扩展，不会影响到对方
- 对于具体实现的修改，不会影响到客户端

## 缺点
- 增加了设计复杂度
- 抽象类的修改影响到子类

## 示例

      <?php
      /* 抽象化角色 */
      abstract class Abstraction {
          protected $implementor;
          abstract function handle();
      }
      /* 修正抽象化角色 */
      class RedefinedAbstraction extends Abstraction {

          public function __construct(Implementor $implementor) {
              $this->implementor = $implementor;
          }
          function handle() {
              echo "重新定义了下抽象化操作" . PHP_EOL;
              $this->implementor->handleImp();
          }

      }
      /* 抽象实现化角色 */
      interface Implementor {

          function handleImp();

      }
      /* 具体实现化角色 */
      class ConcreteImplementor1 implements Implementor {
          function handleImp() {
              echo "ConcreteImplementor1 handle method" . PHP_EOL;
          }
      }
      /* 具体实现化角色 */
      class ConcreteImplementor2 implements Implementor {
          function handleImp() {
              echo "ConcreteImplementor2 handle method" . PHP_EOL;
          }
      }
      //调用
      $redefinedAbstraction = new RedefinedAbstraction(new ConcreteImplementor1());
      $redefinedAbstraction->handle();
      $redefinedAbstraction = new RedefinedAbstraction(new ConcreteImplementor2());
      $redefinedAbstraction->handle();
