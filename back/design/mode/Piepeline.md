# 管道模式（Piepeline）

## 概念
- 将数据传递到一个任务列表中，管道扮演着流水线的角色，数据在这里被处理然后传递到下一个步骤
- 将复杂的进程分解成多个独立的子任务，每个独立的任务都是可以复用的，因此这些任务可以被组合成复杂的进程

## 关键
- 每个子任务处理后都返回一个当前对象的**this**指针

## 应用场景
- Laravel框架的中间件(middleware)
- Laravel框架的查询语句  
- Unix系统的管道命令

## 优点
- 将复杂的处理流程分解成独立的子任务，从而方便测试每个子任务
- 被分解的子任务可以被不同的处理进程复用，避免代码冗余
- 在复杂进程中添加、移除和替换子任务非常轻松，对已存在的进程没有任何影响

## 缺点
- 虽然每个子任务变得简单了，但是当你再度尝试将这些子任务组合成完整进程时有一定复杂性
- 此外你还需要保证独立子任务测试通过后整体的流程能正常工作，这有一定的不确定性
- 当你看到的都是一个个子任务时，对理解整体流程带来困难

## 示例
- Laravel框架的查询语句

      <?php
        class DB
        {
            private static $_instance;
            private $_conn;

            private function __construct()
            {
                $this->_conn = new PDO("mysql:dbname=xxx;host=xxx;port=3306;", 'username', 'passwd', [
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ,
                    PDO::ATTR_EMULATE_PREPARES => false,
                    PDO::MYSQL_ATTR_INIT_COMMAND => "set names utf8;"
                ]);
            }

            public function __clone()
            {
                return false;
            }

            public static function getInstance()
            {
                if (!(self::$_instance instanceof self)) {
                    self::$_instance = new self;
                }
                return self::$_instance;
            }

            public function getConn()
            {
                return $this->_conn;
            }
        }

        //查询语句
        class QueryBuilder
        {
            protected $table;
            protected $wheres = [];
            protected $limit;
            protected $skip;
            protected $orderBy = [];
            protected $prepares = [];
            protected $conn;
            public function __construct($table)
            {
                $this->table = $table;
                $this->conn = DB::getInstance()->getConn();
            }

            public function where($column, $operate = null, $value = null)
            {
                if ($column instanceof Closure) {
                    call_user_func($column, $this);
                } else {
                    if (count(func_get_args()) <= 2) {
                        $value = func_get_arg(1);
                        $operate = '=';
                    }
                    array_push($this->wheres, "{$column} {$operate} :{$column}");
                    $this->prepares[":{$column}"] = $value;
                }
                return $this;
            }

            public function limit($limit)
            {
                $this->limit = $limit;
                return $this;
            }

            public function skip($skip = 0)
            {
                $this->skip = $skip;
                return $this;
            }

            public function orderBy($field, $order = 'asc')
            {
                array_push($this->orderBy, "$field $order");
                return $this;
            }

            public function get($columns = '*')
            {
                if (empty($columns)) {
                    $columns = '*';
                } elseif (is_array($columns)) {
                    $columns = implode(",", $columns);
                }

                $where = $this->wheres ? "where " . implode(" and ", $this->wheres) : '';
                $limit = $this->limit ? " limit {$this->skip}, {$this->limit}" : '';
                $orderby = $this->orderBy ? "order by " . implode(",", $this->orderBy) : '';
                $sql = "select {$columns} from {$this->table} {$where} {$orderby} {$limit}";
                $query = $this->conn->prepare($sql);
                $query->execute($this->prepares);
                $result = [];
                while($row = $query->fetch(PDO::FETCH_OBJ)) {
                   $result[] = $row;
                }
                return $result;
            }
        }
        //调用
        $queryBuilder = new QueryBuilder('xxx');
        $queryBuilder->where('name', '!=', 'xxx')->where(function ($query) {
            $query->where('id', '>', 123);
        })->orderBy("id", 'desc')->orderBy("name")->limit(10)->skip(20);
        var_dump($queryBuilder->get());
