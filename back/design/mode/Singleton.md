# 单例模式（Singleton）

## 概念
- 确保某个类**只有一个实例**
- 必须自行创建这个实例
- 必须自行向整个系统提供这个实例

## 要点
- 私有化一个静态属性用于存放唯一的一个实例
- 私有化构造方法，私有化克隆方法，用来创建并只允许自行创建一个实例
- 公有化静态方法，用于向系统提供这个实例

## 应用场合
- 应用程序与数据库交互：避免大量的new操作（每一次new操作都会消耗内存资源和系统资源）
- 控制配置信息

## php缺点
- PHP语言是一种解释型的脚本语言，这种运行机制使得每个PHP页面被解释执行后，所有的相关资源都会被回收。也就是说，PHP在语言级别上没有办法让某个对象常驻内存，这和asp.NET、Java等编译型是不同的，比如在Java中单例会一直存在于整个应用程序的生命周期里，变量是跨页面级的，真正可以做到这个实例在应用程序生命周期中的唯一性。然而在PHP中，所有的变量无论是全局变量还是类的静态成员，都是**页面级**的，每次页面被执行时，都会重新建立新的对象，都会在页面执行完毕后被清空，这样似乎PHP单例模式就没有什么意义了，所以PHP单例模式我觉得只是**针对单次页面级请求**时出现多个应用场景并需要共享同一对象资源时是非常有意义的。

## 代码实现
- 基础使用

      <?php
      class Singleton {
        /* 私有静态实例 */
        private static $_instance;
        /* 防止外部实例化 */
        private function __construct() {}
        /* 防止对象实例被克隆 */
        private function __clone() {}
        /* 防止序列化 */
        private function __sleep() {}
        /* 防止反实例化 */
        private function __wakeup() {}
        /* 自行创建并返回实例 */ 
        public static function getInstance(){
            if(!(static::$_instance instanceof static)) {
                static::$_instance = new staic();
            }
            return static::$_instance;
        }
      }
      //调用
      $singleton = Singleton::getInstance(); 

- 连接数据库

      <?php
      class DB {
        /* 私有静态实例 */
        private static $_instance;
        private $_conn;
        /* 防止外部实例化 */
        private function __construct() {
            $this->_conn = new PDO("dbdriver:dbname=xxx;host=xxx;port=xxx;", "username", "password");
        }
        /* 防止对象实例被克隆 */
        private function __clone() {}
        /* 防止序列化 */
        private function __sleep() {}
        /* 防止反实例化 */
        private function __wakeup() {}
        /* 自行创建并返回实例 */ 
        public static function getInstance(){
            if(!(static::$_instance instanceof static)) {
                static::$_instance = new staic();
            }
            return static::$_instance;
        }

        public function getConn(){
            return $this->_conn;
        }
      }
      //调用
      $db = DB::getInstance(); 
      $conn = $db->getConn();
