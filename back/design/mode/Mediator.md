# 中介者模式（Mediator）

## 概念
- 用一个中介对象封装一系列的对象交互
- 中介者使各对象不需要显示的相互引用，从而使其耦合松散，而且可以独立的改变他们之间的交互
- 又称为调停者模式，是一种对象行为型模式

## 角色
- 抽象中介者(Mediator)：定义了同事对象到中介者对象的接口
- 具体中介者对象(ConcreteMediator)：实现抽象类的方法，它需要知道所有具体同事类，并从具体同事接收消息，向具体同事对象发出命令
- 抽象同事类(Colleague)：定义同事对象的接口
- 具体同事类(ConcreteColleague)：每个具体同事类只知道自己的行为，而不了解其他同事的情况，但它们却都认识中介者对象

## 优点
- 可以使对象之间的关系数量急剧减少
- 中转作用(结构性):各个同事对象不再需要显示引用其他同事，当需要和其他同事进行交互时，通过中介者即可
- 协调作用(行为性):可以进一步对同事之间的关系进行封装，同事可以一致地和中介者进行交互，而不需要指明中介者需要具体怎么做，中介者根据封装在自身内部的协调逻辑，对同事的请求进行进一步处理，将同事成员之间的关系行为进行分离和封装

## 示例
- 电话-交换机-手机

      <?php
      /*抽象中介者*/
      interface Mediator {
          function handle($from, $to, $msg);
      }
      /*具体中介者对象*/
      class ConcreteMediator implements Mediator {
          protected $colleagues = [];
          public function addColleagues(Colleague $colleague) {
              if(!in_array($colleague, $this->colleagues)) {
                  array_push($this->colleagues, $colleague);
              }
          }
          function handle($from, $to, $msg) {
              echo $from->getNum() . "向" . $to->getNum() . "发送一条消息:" . $msg . PHP_EOL;
              $to->receiveMsg($from, $msg);
          }

      }
      /*抽象同事类*/
      abstract class Colleague {
          protected  $mediator;
          protected $num;
          public function __construct($num){
              $this->num = $num;
          }
          public function getNum() {
              return $this->num;
          }

          public function setMediator(Mediator $mediator){
              $this->mediator = $mediator;
          }
          public function getMediator(){
              return $this->mediator;
          }
          abstract function sendMsg(Colleague $colleague, $msg);
          abstract function receiveMsg(Colleague $colleague, $msg);

      }
      /*具体同事类*/
      class ConcreteColleague1 extends Colleague {

          function sendMsg(Colleague $colleague, $msg) {
              $this->getMediator()->handle($this, $colleague, $msg);
          }

          function receiveMsg(Colleague $colleague, $msg) {
              echo "叮叮叮, 收到来自{$colleague->getNum()}的一条新消息：{$msg}" . PHP_EOL;
          }
      }
      /*具体同事类2*/
      class ConcreteColleague2 extends Colleague {

          function sendMsg(Colleague $colleague, $msg) {
              $this->getMediator()->handle($this, $colleague, $msg);
          }

          function receiveMsg(Colleague $colleague, $msg) {
              echo "叮叮叮, 收到来自{$colleague->getNum()}的一条新消息：{$msg}" . PHP_EOL;
          }
      }

      //调用
      $switchboard = new ConcreteMediator();
      $telephone = new ConcreteColleague1("xxxxxx");
      $telephone->setMediator($switchboard);
      $mobile = new ConcreteColleague2("xxxxxxxx");
      $mobile->setMediator($switchboard);
      $telephone->sendMsg($mobile, "***");
      $mobile->sendMsg($telephone, "*** +1");

- 租客-中介-房东

      <?php
      /* 抽象中介者 */
      interface Mediator
      {
          function rentOut();//出租
          function renting();//租房
      }
      /* 具体中介者 */
      class HouseMediator implements Mediator
      {
          protected $houseOwner;
          protected $renter;
          public function setHouseOwner(Colleague $colleague) {
              $this->houseOwner = $colleague;
          }
          public function setRenter(Colleague $colleague) {
              $this->renter = $colleague;
          }
          public function getHouseOwner() {
              return $this->houseOwner;
          }
          public function getRenter() {
              return $this->renter;
          }
          function rentOut()
          {
              //将房东的出租消息传递给租户
              $this->getRenter()->response();
          }
          function renting()
          {
              //将租户的租赁请求传递给房东
              $this->getHouseOwner()->response();
          }
      }
      /* 抽象同事类 */
      abstract class Colleague {
          protected $mediator;
          public function setMediator(Mediator $mediator) {
              $this->mediator = $mediator;
          }
          public function getMediator() {
              return $this->mediator;
          }
          abstract function request();
          abstract function response();
      }
      /* 具体同事类 */
      class HouseOwner extends Colleague {
          function request() {
              echo "房东发出出租消息" . PHP_EOL;
              $this->getMediator()->rentOut();
          }
          function response() {
              echo "房东收到租赁请求" . PHP_EOL;
          }
      }
      /* 具体同事类 */
      class Renter extends Colleague {
          function request() {
              echo "租户发出租赁请求" . PHP_EOL;
              $this->getMediator()->renting();
          }
          function response() {
              echo "租户收到出租消息" . PHP_EOL;
          }
      }
      //调用
      $house_mediator = new HouseMediator();
      $renter = new Renter();
      $house_owner = new HouseOwner();
      $renter->setMediator($house_mediator);
      $house_owner->setMediator($house_mediator);
      $house_mediator->setHouseOwner($house_owner);
      $house_mediator->setRenter($renter);
      $house_owner->request();
      $renter->request();


