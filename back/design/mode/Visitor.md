# 访问者模式（Visitor）

## 概念
- 让外部类能够获取属性结构的每个节点的对象，对每个对象进行操作的模式，能让我们在不改动原有树形结构的基础上扩展功能，比如统计等

## 角色
- 抽象访问者角色(Visitor)：为该对象结构中的每一个具体元素提供一个访问操作接口，该操作接口的名字和参数标识了要访问的具体元素角色。这样访问者就可以直接通过该元素角色的特定接口直接访问它
- 具体访问者角色(ConcreteVisitor)：实现抽象访问者角色接口中针对各个具体元素角色声明的操作
- 抽象元素角色(Element)：该接口定义一个accept操作接收具体的访问者
- 具体元素角色(ConcreteElement)：实现抽象元素角色中的accept操作
- 元素集合角色(ElementCollection)：是使用访问者模式的必备角色，含以下特征：
    + 能枚举它的元素
    + 可以提供一个高层的接口以允许该访问者访问它的元素
    + 可以是一个复合（组合模式）或是一个集合

## 优点
- 访问者模式使得增加新的操作变得很容易。使用访问者模式可以在不用修改具体元素类的情况下增加新的操作。它主要是通过元素类的accept方法来接受一个新的visitor对象来实现的。如果一些操作依赖于一个复杂的结构对象的话，那么一般而言，增加新的操作会很复杂。而使用访问者模式，增加新的操作就意味着增加一个新的访问者类，因此，变得很容易
- 访问者模式将有关的行为集中到一个访问者对象中，而不是分散到一个个的节点类中
- 访问者模式可以跨过几个类的等级结构访问属于不同的等级结构的成员类。迭代子只能访问属于同一个类型等级结构的成员对象，而不能访问属于不同等级结构的对象。访问者模式可以做到这一点
- 积累状态。每一个单独的访问者对象都集中了相关的行为，从而也就可以在访问的过程中将执行操作的状态积累在自己内部，而不是分散到很多的节点对象中。这是有益于系统维护的优点

## 缺点
- 增加新的节点类变得很困难。每增加一个新的节点都意味着要在抽象访问者角色中增加一个新的抽象操作，并在每一个具体访问者类中增加相应的具体操作
- 破坏封装。访问者模式要求访问者对象访问并调用每一个节点对象的操作，这隐含了一个对所有节点对象的要求：它们必须暴露一些自己的操作和内部状态。不然，访问者的访问就变得没有意义。由于访问者对象自己会积累访问操作所需的状态，从而使这些状态不再存储在节点对象中，这也是破坏封装的

## 适用场景
- 对象群结构中(Collection) 中的**对象类型**很少改变。
- 在接口Visitor和Element中,确保Element很少变化,也就是说，确保不能频繁的添加新的Element元素类型加进来，可以变化的是访问者行为或操作，也就是Visitor的不同子类可以有多种,这样使用访问者模式最方便
- 如果对象集合中的对象集合经常有变化, 那么不但Visitor实现要变化，ConcreteVisitor也要增加相应行为，那就不如在这些对象类中直接逐个定义操作，无需使用访问者设计模式。

## 示例
- 给不同用户组的用户添加不同的积分；
- 打印不同用户组的用户积分

      <?php
      /* 抽象访问者角色 */
      interface Visitor
      {
          function visitNormal(User $user);

          function visitVip(User $user);
      }

      /* 具体访问者角色 */
      class PointVisitor implements Visitor
      {
          function visitNormal(User $user)
          {
              $user->point += 5;
          }

          function visitVip(User $user)
          {
              $user->point += 20;
          }
      }

      /* 具体访问者角色 */
      class PrintVisitor implements Visitor
      {
          function visitNormal(User $user)
          {
              print_r("Normal User {$user->getName()} has points: {$user->point}");
              echo PHP_EOL;
          }

          function visitVip(User $user)
          {
              print_r("Vip User {$user->getName()} has points: {$user->point}");
              echo PHP_EOL;
          }
      }

      /* 抽象元素角色 */
      abstract class User
      {
          public $point = 0;
          private $name;

          public function __construct($name)
          {
              $this->name = $name;
          }

          public function getName()
          {
              return $this->name;
          }

          public function getPoint()
          {
              return $this->point;
          }

          abstract function accept(Visitor $visitor);
      }

      /* 具体元素角色 */
      class NormalUser extends User
      {
          function accept(Visitor $visitor)
          {
              return $visitor->visitNormal($this);
          }
      }

      /* 具体元素角色 */
      class VipUser extends User
      {
          function accept(Visitor $visitor)
          {
              return $visitor->visitVip($this);
          }
      }

      /* 元素集合角色 */
      class UserCollection
      {
          private $_collection = [];

          public function addUser(User $user)
          {
              array_push($this->_collection, $user);
          }

          public function accept(Visitor $visitor)
          {
              foreach($this->_collection as $user) {
                  $user->accept($visitor);
              }
          }

      }

      // 调用
      $normalUser1 = new NormalUser('normalUser1');
      $normalUser2 = new NormalUser('normalUser2');
      $normalUser3 = new NormalUser('normalUser3');
      $vipUser1 = new VipUser('vipUser1');
      $vipUser2 = new VipUser('vipUser2');
      $userCollection = new UserCollection();
      $userCollection->addUser($normalUser1);
      $userCollection->addUser($normalUser2);
      $userCollection->addUser($normalUser3);
      $userCollection->addUser($vipUser1);
      $userCollection->addUser($vipUser2);
      $pointVisitor = new PointVisitor();
      $userCollection->accept($pointVisitor);
      $printVisitor = new PrintVisitor();
      $userCollection->accept($printVisitor);
