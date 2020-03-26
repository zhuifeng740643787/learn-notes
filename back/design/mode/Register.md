# 注册模式（Register）

## 概念
- 又称注册树模式或注册器模式
- 通过将对象实例注册到一棵全局的对象树上，需要的时候从对象树上采摘的模式设计方法，和果树不同的是，果子只能采摘一次，而注册树上的实例却可以无数次获取

## 示例
- 基础构建

      <?php
      class Register {
        //存放实例的数组
        protected static $objects;
        //注册实例到注册树中
        public static function set($alias, $object) {
            self::$objects[$alias] = $object;
        }
        //从注册树中读取实例
        public static function get($alias) {
            if(isset(self::$objects[$alias])) {
                return self::$objects[$alias];
            }
            echo "Object not exists"; 
        }
        //销毁注册树中的实例
        public static function unset($alias) {
            unset(self::$objects[$alias]); 
        }
      }
      class Demo {
        public function test() { echo 'test'; }
      }
      //调用
      $tree = Register::set('demo', new Demo());
      $demo = Register::get('demo');
      $demo->test();

- 与工厂模式和单例模式结合
    
      <?php
      class Register {
        //存放实例的数组
        protected static $objects;
        //注册实例到注册树中
        public static function set($alias, $object) {
            self::$objects[$alias] = $object;
        }
        //从注册树中读取实例
        public static function get($alias) {
            if(isset(self::$objects[$alias])) {
                return self::$objects[$alias];
            }
            echo "Object not exists"; 
        }
        //销毁注册树中的实例
        public static function unset($alias) {
            unset(self::$objects[$alias]); 
        }
      }
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

      Class Factory {
        public static function create() {
            return DB::getInstance();
        }
      }

      //调用
      Register::set('db', Factory::create());
      $db = Register::get('db');
      $conn = $db->getConn();












