# 建造者模式（Builder）

## 概念
- 可以让一个产品的内部表象和产品的生产过程分离开，从而可以生成具有不同表象的产品

## 角色
- 抽象建造者角色(Builder)：定义一个抽象接口，规范产品各个组成成分的建造（即规范具体建造者的方法实现）。其中所规范的方法中必须包括建造方法和结果返回方法
- 具体建造者角色(ConcreteBuilder)：实现抽象建造者角色所定义的方法。具体建造者与业务逻辑关联性较大，应用程序最终会通过调用此角色中所实现的建造方法按照业务逻辑创建产品，在建造完成后通过结果返回方法返回建造的产品实例。一般在外部由客户或一个抽象工厂创建。
- 导演者角色(Director)：此角色的作用是调用具体的建造者角色建造产品。导演者与产品类没有直接关系，与产品类交谈的是具体建造者角色。导演者与客户端直接打交道，它理解客户端的业务逻辑，将客户端创建产品的请求拆分成对产品组成部分的请求，然后调用具体产品角色执行建造操作。它分离了客户端与具体建造者。
- 产品角色(Product)：在指导者的指导下由建造者所创建的那个复杂的对象

## 优点
- 建造者模式可以很好的将一个对象的实现与相关的“业务”逻辑分离开来，从而可以在不改变事件逻辑的前提下,使增加(或改变)实现变得非常容易。

## 缺点
- 建造者接口的修改会导致所有执行类的修改。

## 适用场景
- 需要生成的产品对象有复杂的内部结构
- 需要生成的产品对象的属性相互依赖，建造者模式可以强迫生成顺序
- 在对象创建过程中会使用到系统中的一些其它对象，这些对象在产品对象的创建过程中不易得到

## 示例
- 建造车辆：汽车、自行车

      <?php
      /* 抽象建造者角色 */
      abstract class Builder {
          protected $name;
          public function __construct($name)
          {
              $this->name = $name;
          }
          abstract function createVehicle();//创建产品
          abstract function addWheel();//添加轮子
          abstract function addEngine();//添加引擎
          abstract function decorate();//装饰
          abstract function getVehicle();//出产
      }

      /* 具体建造者角色 */
      class BikeBuilder extends Builder {
          private $_bike;
          function createVehicle(){
              $this->_bike = new Bike($this->name);
          }
          function addWheel(){
              $this->_bike->addPart('wheel', $this->_bike->getName(). " wheel");
          }
          function addEngine(){
              $this->_bike->addPart('engine', $this->_bike->getName(). " engine");
          }
          function decorate(){
              $this->_bike->addPart('decorate', $this->_bike->getName(). " decorate");
          }
          function getVehicle(){
              return $this->_bike;
          }
      }
      class CarBuilder extends Builder {
          private $_car;

          function createVehicle(){
              $this->_car = new Car($this->name);
          }
          function addWheel(){
              $this->_car->addPart('wheel', $this->_car->getName() . " wheel");
          }
          function addEngine(){
              $this->_car->addPart('engine', $this->_car->getName(). " engine");
          }
          function decorate(){
              $this->_car->addPart('decorate', $this->_car->getName(). " decorate");
          }
          function getVehicle(){
              return $this->_car;
          }
      }
      /* 导演者角色 */
      class Director {
          public function build(Builder $builder) {
              $builder->createVehicle();
              $builder->addWheel();
              $builder->addEngine();
              $builder->decorate();
              return $builder->getVehicle();
          }
      }
      /* 产品角色 */
      abstract class Vehicle {
          protected $name;
          private $_parts = [];
          public function __construct($name)
          {
              $this->name = $name;
          }
          public function getName()
          {
              return $this->name;
          }
          public function addPart($key, $value)
          {
              $this->_parts[$key] = $value;
          }
          public function getParts() {
              return $this->_parts;
          }
          public function info() {
              echo "name: " . $this->name . PHP_EOL;
              foreach($this->_parts as $key => $part) {
                  echo $key . ": " . $part . PHP_EOL;
              }
          }
      }
      class Bike extends Vehicle {

      }
      class Car extends Vehicle {

      }
      //调用
      $director = new Director();
      $bike = $director->build(new BikeBuilder("自行车"));
      $car = $director->build(new CarBuilder("汽车"));
      $bike->info();
      $car->info();
    
