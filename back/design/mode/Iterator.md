# 迭代器模式（Iterator）

## 概念
- 又称游标模式（Cursor）
- 提供一种方法顺序访问一个聚合对象中的各种元素，而又不暴露该对象的内部表示

## 角色
- 抽象迭代器（Iterator）: 迭代器定义访问和遍历元素的接口(PHP SPL中已提供)
- 具体迭代器（ConcreteIterator）: 具体迭代器实现迭代器接口，对该聚合遍历时跟踪当前位置
- 抽象聚合（IteratorAggregate）: 聚合定义创建相应迭代器对象的接口(PHP SPL中已提供)
- 具体聚合（ConcreteAggregate）: 实现创建相应迭代器的接口，该操作返回ConcreteIterator的一个适当的实例

## 适用场景
- 访问一个聚合对象的内容而无需暴露它的内部结构
- 支持对聚合对象的多种遍历
- 为遍历不同的聚合结构提供一个统一的接口

## 示例
      <?php
      /* 具体迭代器 */
      class ConcreteIterator implements Iterator
      {
          protected $array = [];
          protected $position = 0;

          public function __construct($array)
          {
              $this->array = $array;
          }

          function rewind()
          {
              $this->position = 0;
          }

          function key()
          {
              return $this->position;
          }

          function valid()
          {
              return isset($this->array[$this->position]);
          }

          function next()
          {
              ++$this->position;
          }

          function current()
          {
              return $this->array[$this->position];
          }

      }
      /* 具体聚合 */
      class ConcreteAggregate implements IteratorAggregate
      {
          protected $values = [];

          public function addValues($value)
          {
              array_push($this->values, $value);
          }

          function getIterator()
          {
              return new ConcreteIterator($this->values);
          }
      }

      $aggregate = new ConcreteAggregate();
      $aggregate->addValues([1, 2, 3]);
      $aggregate->addValues("hello");
      $aggregate->addValues(new stdClass());
      $aggregate->addValues(function () {
          return 1;
      });
      foreach ($aggregate->getIterator() as $key => $value) {
          var_dump($key, $value);
          echo PHP_EOL;
      }


