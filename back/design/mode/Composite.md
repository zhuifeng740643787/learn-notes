# 组合模式（Composite）

## 概念
- 又叫部分-整体模式
- 用于将对象组合成树形结构以表示“部分-整体”的层次关系
- 使得用户对单个对象和组合对象的使用具有一致性

# 优点 
- 在树形结构中的问题中，模糊了简单元素和复杂元素的概念，客户程序可以像处理简单元素一样处理复杂元素，从而使得客户程序与复杂元素的内部结构解耦
- 可以优化处理递归或分级数据结构

# 适用场景
- 想表示对象的“部分-整体”的层次结构
- 希望用户忽略组合对象与单个对象的不同，用户将统一使用组合结构中的所有对象

# 常见应用场景
- 树形菜单
- 文件夹菜单
- 部门组织架构图

# 角色
- 抽象组合对象接口(Component): 实现多有类共有接口的默认行为
- 叶子节点对象(Leaf): 实现抽象组合对象接口，没有子节点
- 组合对象(Composite): 实现抽象组合对象接口，有子节点，可以添加和删除子节点

# 示例
- 树形菜单

      <?php
      /* 抽象组合对象接口 */
      abstract class Component
      {
          protected $parent;
          protected $level = 0;
          protected $name;

          public function __construct($name)
          {
              $this->name = $name;
          }
          public function setParent(Component $component) {
              $this->parent = $component;
              $this->level = $this->parent->level + 1;
          }
          abstract function display();
      }
      /* 组合对象 */
      class Composite extends Component
      {

          protected $child_nodes = [];

          function display()
          {
              $this->_levelDisplay($this);
          }

          private function _display(Composite $composite)
          {
              for ($i = 0; $i < $composite->level; $i++) {
                  echo "  ";
              }
              echo $composite->name . PHP_EOL;
          }

          private function _levelDisplay(Composite $composite)
          {
              $composite->_display($composite);
              foreach ($composite->child_nodes as $child) {
                  if ($child instanceof Leaf) {
                      $child->display();
                  } else {
                      $this->_levelDisplay($child);
                  }
              }
          }

          function add(Component $component)
          {
              if (!in_array($component, $this->child_nodes)) {
                  //$component->level = $this->level + 1;
                  $component->setParent($this);
                  array_push($this->child_nodes, $component);
              }
          }

          function remove(Component $component)
          {
              $index = array_search($component, $this->child_nodes, true);
              if ($index !== false) {
                  unset($this->child_nodes[$index]);
              }
          }

          function getChildNodes()
          {
              return $this->child_nodes;
          }

      }
      /* 叶子节点 */
      class Leaf extends Component
      {
          function display()
          {
              for ($i = 0; $i < $this->level; $i++) {
                  echo "  ";
              }
              echo $this->name . PHP_EOL;
          }
      }

      $menu = new Composite("root");
      $dir1 = new Composite('dir1');
      $dir2 = new Composite('dir1.1');
      $dir3 = new Composite('dir2');
      $dir4 = new Composite('dir2.1');
      $dir5 = new Composite('dir1.1.1');
      $file1 = new Leaf('file1');
      $file2 = new Leaf('file2');
      $menu->add($dir1);
      $menu->add($dir3);
      $dir1->add($dir2);
      $dir2->add($dir5);
      $dir3->add($dir4);
      $dir2->add($file1);
      $dir4->add($file2);
      $menu->display();



