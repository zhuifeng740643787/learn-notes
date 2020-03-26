# 代理模式（Proxy）

## 概念
- 一种对象结构型模式，给某一个对象提供一个代理，并由代理对象控制对原对象的引用

## 角色
- 抽象主题角色(Subject): 定义了ConcreteSubject和Proxy的公用接口，这样就在任何使用ConcreteSubject的地方都可以使用Proxy
- 具体主题角色(ConcreteSubject): 定义了Proxy所代表的真实实体
- 代理角色(Proxy): 保存一个实体的引用使得代理可以访问实体，并提供一个与ConcreteSubject接口相同的接口，这样代理可以用来代替实体（ConcreteSubject）

## 适用场景
- 远程(Remote)代理：为一个位于不同的地址空间的对象提供一个本地 的代理对象，这个不同的地址空间可以是在同一台主机中，也可是在 另一台主机中，远程代理又叫做大使(Ambassador)。
- 虚拟(Virtual)代理：如果需要创建一个资源消耗较大的对象，先创建一个消耗相对较小的对象来表示，真实对象只在需要时才会被真正创建。
- Copy-on-Write代理：它是虚拟代理的一种，把复制（克隆）操作延迟 到只有在客户端真正需要时才执行。一般来说，对象的深克隆是一个 开销较大的操作，Copy-on-Write代理可以让这个操作延迟，只有对象被用到的时候才被克隆。
- 保护(Protect or Access)代理：控制对一个对象的访问，可以给不同的用户提供不同级别的使用权限。
- 缓冲(Cache)代理：为某一个目标操作的结果提供临时的存储空间，以便多个客户端可以共享这些结果。
- 防火墙(Firewall)代理：保护目标不让恶意用户接近。
- 同步化(Synchronization)代理：使几个用户能够同时使用一个对象而没有冲突。
- 智能引用(Smart Reference)代理：当一个对象被引用时，提供一些额外的操作，如将此对象被调用的次数记录下来等。

## 示例
      <?php
      /* 抽象主题角色 */
      interface Subject
      {
          function giveLetter();

          function giveFollow();
      }

      class Girl
      {
          protected $name;

          public function __construct($name)
          {
              $this->name = $name;
          }

          public function setName($name)
          {
              $this->name = $name;
          }

          public function getName()
          {
              return $this->name;
          }
      }
      /* 具体主题角色 */
      class ConcreteSubject implements Subject
      {
          protected $girl;

          public function __construct(Girl $girl)
          {
              $this->girl = $girl;
          }

          function giveLetter()
          {
              echo "送给{$this->girl->getName()}一封情书\r\n";
          }

          function giveFollow()
          {
              echo "送给{$this->girl->getName()}一束花\r\n";
          }
      }
      /* 代理角色 */
      class Proxy implements Subject
      {
          private $_concreteSubject;

          public function __construct(Subject $subject = null)
          {
              if (!$subject) {
                  $subject = new ConcreteSubject();
              }
              $this->_concreteSubject = $subject;
          }

          function giveLetter()
          {
              echo "代人";
              $this->_concreteSubject->giveLetter();
          }

          function giveFollow()
          {
              echo "代人";
              $this->_concreteSubject->giveFollow();
          }
      }

      //调用
      $boy = new ConcreteSubject(new Girl("Lucy"));
      $boy->giveLetter();
      $boy->giveFollow();
      $roommate = new Proxy($boy);
      $roommate->giveLetter();
      $roommate->giveFollow();
