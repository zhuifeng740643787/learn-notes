# 原型模式（Prototype）

## 概念
- 用原型实例指定创建对象的种类，并且通过拷贝这些原型创建新的对象
- 允许一个对象再创建另外一个可定制的对象，根本无需知道任何创建的细节

## 角色 
- 抽象原型：声明一个克隆自身的接口
- 具体原型：实现一个克隆自身的操作

## 优点
- 可以在运行时增加和删除产品
- 可以改变值以指定新对象
- 可以改变结构以指定新对象
- 减少子类的构造
- 用类动态配置应用
- 适用于大对象的创建，节省了每次new时的开销，仅需内存拷贝即可

## 缺点
- 每一个类必须配备一个克隆方法，而且这个克隆方法需要对类的功能进行通盘考虑，这对全新的类来说不是很难，但对已有的类进行改造时，不一定是件容易的事

## 适用场景
- 当一个系统应该独立于它的产品创建、构成和表示时，要使用Prototype模式
- 当要实例化的类是在运行时刻指定时，例如动态加载
- 为了避免创建一个与产品类层次平等的工厂类层次时；
- 当一个类的实例只能有几个不同状态组合中的一种时。建立相应数目的原型并克隆它们可能比每次用合适的状态手工实例化该类更方便一些

## 示例
- 浅拷贝模式: 直接copy，拷贝了源对象的**引用地址**等，所以原来内容变化，新内容变化。
      
      <?php
      interface Prototype
      {
          function copy();
      }

      class ConcretePrototype implements Prototype
      {
          private $_name;
          public function __construct($name)
          {
              $this->_name = $name;
          }
          public function setName($name)
          {
              $this->_name = $name;
          }
          public function getName()
          {
              return $this->_name;
          }
          function copy()
          {
              //浅拷贝
              return clone $this;
          }
      }

      class CopyDemo
      {
          public $array;
      }

      //调用
      $demo = new CopyDemo();
      $demo->array = [1, 2, 3];

      $obj1 = new ConcretePrototype($demo);
      $obj2 = $obj1->copy();
      var_dump($obj1->getName(), $obj2->getName());
      $demo->array = [3,4,5];
      var_dump($obj1->getName(), $obj2->getName());

- 深拷贝模式: 通过序列化和反序列化完成copy，新copy的内容完全复制原来的内容。原来的内容变化，新内容不变。
      
      <?php
      interface Prototype
      {
          function copy();
      }
      class ConcretePrototype implements Prototype
      {
          private $_name;
          public function __construct($name)
          {
              $this->_name = $name;
          }
          public function setName($name)
          {
              $this->_name = $name;
          }
          public function getName()
          {
              return $this->_name;
          }
          function copy()
          {
              //深拷贝
              $serialize_obj = serialize($this);
              $clone_obj = unserialize($serialize_obj);
              return $clone_obj;
          }
      }
      class CopyDemo
      {
          public $array;
      }
      //调用
      $demo = new CopyDemo();
      $demo->array = [1, 2, 3];

      $obj1 = new ConcretePrototype($demo);
      $obj2 = $obj1->copy();
      var_dump($obj1->getName(), $obj2->getName());
      $demo->array = [3,4,5];
      var_dump($obj1->getName(), $obj2->getName());