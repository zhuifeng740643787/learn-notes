# 备忘录模式（Memento）

## 概念
- 又叫快照模式（Snapshot）或Token模式
- 用意是在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态，这样就可以在合适的时候将该对象恢复到原先保存的状态

## 角色
- 备忘录角色(Memento)：存储发起人对象的内部状态，而发起人根据需要决定备忘录存储发起人的那些内部状态，备忘录可以保护其内容不被发起人对象之外的任何对象所读取
- 发起人角色(Originator)：创建一个含有当前的内部状态的备忘录对象，使用备忘录对象存储其内部状态，负责创建和恢复备忘录数据
- 负责人角色(Caretaker)：负责对备忘录对象进行管理，不检查备忘录对象的内容，保存和提供备忘录

## 适用场景
- 必须保存一个对象再某一个时刻的（部分）状态，这样以后需要时可以恢复到先前的状态
- 如果用一个接口来让其他对象直接得到这些状态，将会暴露对象的实现细节并破坏对象的封装性

## 应用场景
- 回滚操作，如数据库的事务
- 文本编辑器的撤销（Ctrl+Z）操作

## 优点
- 有时一些发起人对象的内部信息必须保存在发起人对象以外的地方，但是必须要由发起人对象自己读取
- 简化了发起人(Originator)类。发起人(Originator)不再需要管理和保存其内部状态的一个个版本，客户端可以自行管理它们所需要的这些状态的版本
- 当发起人角色的状态改变的时候，有可能这个状态无效，这时候就可以使用暂时存储起来的备忘录将状态复原

## 缺点
- 如果发起人角色的状态需要完整地存储到备忘录对象中，那么在资源消耗上面备忘录对象会很昂贵
- 当负责人角色将一个备忘录存储起来的时候，负责人可能并不知道这个状态会占用多大的存储空间，从而无法提醒用户一个操作是否会很昂贵
- 当发起人角色的状态改变的时候，有可能这个状态无效

## 示例
- 编辑器的撤销操作

      <?php
      /* 发起人 */
      class Originator
      {
          private $_state;

          public function mementoState()
          {
              return new Memento($this->_state);
          }

          public function recoverState(Memento $memento = null)
          {
              $this->_state = $memento ? $memento->getState() : null;
          }

          public function setState($state)
          {
              $this->_state = $state;
          }

          public function getState()
          {
              return $this->_state;
          }

      }
      /* 备忘录 */
      class Memento
      {
          private $_state;

          public function __construct($state)
          {
              //深拷贝方式存储
              $this->_state = $this->_copyState($state);
          }

          private function _copyState($state){
              return unserialize(serialize($state));
          }

          public function getState()
          {
              return $this->_state;
          }
      }
      /* 负责人 */
      class Caretaker
      {
          protected $histories = [];

          function addHistory(Memento $memento)
          {
              array_push($this->histories, $memento);
          }

          function popHistory()
          {
              return array_pop($this->histories);
          }
      }
      //调用
      $careTaker = new Caretaker();
      $originator = new Originator();
      $originator->setState([1,2]);
      $careTaker->addHistory($originator->mementoState());
      $originator->setState("Hello World!");
      $careTaker->addHistory($originator->mementoState());
      $obj = new stdClass();
      $obj->aa = 123;
      $originator->setState($obj);
      $careTaker->addHistory($originator->mementoState());

      $obj->aa = 333;
      $originator->recoverState($careTaker->popHistory());
      var_dump($originator->getState());
      $originator->recoverState($careTaker->popHistory());
      var_dump($originator->getState());
      $originator->recoverState($careTaker->popHistory());
      var_dump($originator->getState());
      $originator->recoverState($careTaker->popHistory());
      var_dump($originator->getState());



