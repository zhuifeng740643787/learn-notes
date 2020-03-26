# 适配器模式（Adapter）

## 概念
- 将一个类的接口，转换成客户端希望的另外一个接口
- 使原本由于接口不兼容而不能一起工作的类可以一起工作

## 角色
- 目标(Target)角色：该角色定义把其他类转换成何种接口，也就是我们的期望接口
- 源(Adaptee)角色：就是需要被适配的接口
- 适配器(Adapter)角色：其他的两个角色都是已经存在的角色，而适配器角色是需要新建立的，它用来对Adaptee与Target接口进行适配；适配器是本模式的核心，它把源接口转换成目标接口，此角色为具体类

## 适用场景
- 想使用一个已存在的类，而该类的接口不符合你的需求
- 想创建一个可复用的类，该类可以与其他不相关的类或不可预见的类协同工作
- 相使用一个已存在的子类，但是不可能对每一个都进行子类化以匹配它们的接口。对象适配器可以适配它的父类接口（仅限于对象适配器）

## 细分
- ### 类适配器
    + Adapter与Adaptee是**继承**关系
        * 用一个具体的Adapter类和Target进行匹配。结果是当我们想要一个匹配一个类以及所有它的子类时，类Adapter将不能胜任工作
        * 使得Adapter可以重定义Adaptee的部分行为，因为Adapter是Adaptee的一个子集
        * 仅仅引入一个对象，并不需要额外的指针以间接取得adaptee
    + 代码示例
    
          <?php
          /* 目标角色 */
          interface Target {
            function oldMethod();
            function newMethod();
          }
          /* 源角色 */
          class Adaptee {
            function oldMethod(){***}
          }
          /* 适配器 */
          class Adapter extends Adaptee implements Target {
            function newMethod(){***)))}
          }
          //调用
          $adapter = new Adapter();
          $adapter->oldMethod();
          $adapter->newMethod();

- ### 对象适配器
    + Adapter与Adaptee是委托关系
    + 代码示例
    
          <?php
          /* 目标角色 */
          interface Target {
            function oldMethod();
            function newMethod();
          }
          /* 源角色 */
          class Adaptee {
            function oldMethod(){***}
          }
          /* 适配器 */
          class Adapter implements Target {
            private $_adaptee;
            //将源角色(Adaptee作为对象传入)
            public function __construct(Adaptee $adaptee) {
                $this->_adaptee = $adaptee;
            }
            public function oldMethod() {
                return $this->_adaptee->oldMethod();
            }
            public function newMethod() {
                ***
            }
          }
          //调用
          $adaptee = new Adaptee();
          $adapter = new Adapter($adaptee);
          $adapter->oldMethod();
          $adapter->newMethod();


## 优点
- 通过适配器，客户端可以调用同一接口，因而对客户端来说是透明的。这样做更简单、更直接、更紧凑。
- 复用了现存的类，解决了现存类和复用环境要求不一致的问题。
- 将目标类和适配者类解耦，通过引入一个适配器类重用现有的适配者类，而无需修改原有代码。
- 一个对象适配器可以把多个不同的适配者类适配到同一个目标，也就是说，同一个适配器可以把适配者类和它的子类都适配到目标接口。

## 缺点
- 过多的调用适配器，会让系统非常零乱，不易整体进行把握。比如，明明看到调用的是A接口，其实内部被适配成了B接口的实现，一个系统如果太多出现这种情况，无异于一场灾难。因此如果不是很有必要，可以不使用适配器，而是直接对系统进行重构。

## 应用场景
- PHP的数据库操作有Mysqli, PDO等，可以用适配器统一成一致
- cache适配器，将memcache、redis、file、apc等不同的缓存函数统一成一致
- 示例代码

      <?php
      /* 目标角色 */
      interface IDatabase {
          //原方法
          function adapteeMethod();

          //新方法
          function connect($host, $username, $password, $db_name);
          function query($sql);
          function close();
      }
      /* 源角色 */
      class Adaptee {
        public function adapteeMethod() {
            return 'Adaptee';
        }
      }
      /**
       * 类适配器模式（继承Adaptee）
       * 适配器
       */
      class Mysqli extends Adaptee implements IDataBase
      {
          protected $conn;

          function connect($host, $username, $password, $db_name)
          {
              $conn = mysqli_connect($host, $username, $password, $db_name);
              $this->conn = $conn;
          }

          function query($sql)
          {
              return mysqli_query($this->conn, $sql);
          }

          function close()
          {
              mysqli_close($this->conn);
          }
      }
      /**
       * 对象适配器模式（委托Adaptee）
       * 适配器
       */
      class PDO implements IDataBase
      {
          protected $conn;
          private $_adaptee;

          public function __construct(Adaptee $adaptee) {
              $this->_adaptee = $adaptee;
          }
          protected $options = [
              \PDO::ATTR_CASE => \PDO::CASE_NATURAL,
              \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,//输出异常和错误码
              \PDO::ATTR_ORACLE_NULLS => \PDO::NULL_NATURAL,
              \PDO::ATTR_STRINGIFY_FETCHES => false,
              \PDO::ATTR_EMULATE_PREPARES => false,//输出格式化之后的数据,如id为int
          ];

          function adapteeMethod(){
              return $this->_adaptee->adapteeMethod();
          }
          function connect($host, $username, $password, $db_name)
          {
              $conn = new \PDO("mysql:host=$host;dbname=$db_name", $username, $password, $this->options);
              $this->conn = $conn;
          }

          function query($sql)
          {
              $query = $this->conn->query($sql);
              return $query;
          }

          function close()
          {
              unset($this->conn);
          }
      }

      //调用
      $mysqli = new Mysqli();
      $mysqli->connect(xxx);
      $pdo = new Pdo(new Adaptee());
      $pdo->connect(xxx);



