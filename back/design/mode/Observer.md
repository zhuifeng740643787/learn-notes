# 观察者模式（Observer）
- 又叫发布-订阅模式（Publish-Subscribe）
- 又叫模型-视图模式（Model-View）
- 又叫源-监听器模式（Source-Listener）

## 概念
- 定义了一种一对多的关系，让多个观察者同时监听某一个主题对象。
- 这个主题对象在状态发生变化时，会通知所有观察者对象，使他们能够自动更新自己
- 注册 -- 通知 -- 撤销注册

## 角色
- 主题对象(一个)
- 观察者(多个)

## 示例

      <?php
      /* 定义一个观察者接口 */
      interface IObserver {
          public function update();
      }
      /* 观察者1 */
      class Observer1 implements IObserver {
          public function update() {
              echo "Observer1 Update \r\n";
          }
      }
      /* 观察者2 */
      class Observer2 implements IObserver {
          public function update() {
              echo "Observer2 Update \r\n";
          }
      }
      /* 观察者3 */
      class Observer3 implements IObserver {
          public function update() {
              echo "Observer3 Update \r\n";
          }
      }
      /* 主题角色 */
      Class Subject {
          protected $observers = [];
          public function addObserver(IObserver $observer) {
              if(array_search($observer, $this->observers, true) === false) {
                  array_push($this->observers, $observer);
              }
          }
          public function removeObserver(IObserver $observer) {
              $index = array_search($observer, $this->observers, true);
              if($index !== false) {
                  unset($this->observers[$index]);
              }
          }
          public function checkExist(IObserver $observer) {
              return array_search($observer, $this->observers, true) !== false;
          }
          public function notify() {
              foreach($this->observers as $observer) {
                  $observer->update();
              }
          }
      }

      //调用
      $observer1 = new Observer1();
      $observer2 = new Observer2();
      $observer3 = new Observer3();
      $subject = new Subject();
      $subject->addObserver($observer1);
      $subject->addObserver($observer2);
      $subject->addObserver($observer3);
      $subject->notify();
      $subject->removeObserver($observer2);
      $subject->notify();


