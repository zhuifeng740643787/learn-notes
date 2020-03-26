# 数据对象映射模式（ORM）

## 概念
- 将对象和数据存储映射起来，对一个对象的操作会映射为对数据存储的操作

## 示例

    <?php
    class Model {
        protected $table;
        protected $db;
        protected $attributes;
        protected $model_name;

        public function __construct()
        {
            $this->model_name = get_called_class();
            $this->db = Register::get('db');
        }

        public function find($id)
        {
            $ret = $this->db->query("select * from {$this->table} where id={$id} limit 1");
            $data = $ret->fetchObject();
            if ($data) {
                $mode_name = get_called_class();
                $model = new $mode_name;
                $model->attributes = (array)$data;
                return $model;
            }
            return null;
        }

        public function select($sql)
        {
            $ret = $this->db->query($sql);
            $data = [];
            while ($item = $ret->fetchObject()) {
                $model = new $this->model_name;
                $model->attributes = (array)$item;
                $data[] = $model;
            }
            return $data;
        }

        public function save()
        {
            $attributes = $this->attributes;
            if ($this->isNew()) {
                $columns = "`" . implode('`,`', array_keys($attributes)) . '`';
                $values = '';
                foreach ($attributes as $k => $v) {
                    if (is_string($v)) {
                        $values .= "'{$v}',";
                        continue;
                    }
                    $values .= "{$v},";
                }
                $values = rtrim($values, ',');
                $this->db->query("insert into {$this->table} ({$columns}) values({$values});");
            } else {
                $id = $this->attributes['id'];
                $set = '';
                foreach ($this->attributes as $k => $v) {
                    if ($k == 'id') {
                        continue;
                    }
                    if (is_string($v)) {
                        $set .= "`{$k}`='{$v}',";
                        continue;
                    }
                    $set .= "`{$k}`='{$v}',";
                }
                $set = rtrim($set, ',');
                $this->db->query("update {$this->table} set {$set} where id={$id};");
            }
        }

        public function isNew()
        {
            return empty($this->attributes['id']);
        }


        public function __set($key, $value)
        {
            $this->attributes[$key] = $value;
        }

        public function __get($key)
        {
            if (isset($this->attributes[$key])) {
                return $this->attributes[$key];
            }
            throw new Exception(__CLASS__ . ': 未定义的属性 {' . $key . '}');
        }

    }