# 装饰器模式（Decorator）

## 概念
- 动态的给一个对象添加一些额外的职责，就增加功能来说，装饰器模式比生成子类更为灵活
-

## 角色
- 抽象组件角色（Component）：定义一个接口，以规范准备接受附件职责的对象，即可以给这个对象动态的添加职责
- 具体组件角色（ConcreteComponent）：被装饰者，定义一个将要被装饰增加功能的类。可以给这个类的对象添加一些职责
- 抽象装饰角色（Decorator）：维持一个指向构建Component对象的实例，并定义一个与抽象组件角色Component接口一致的接口
- 具体装饰器角色（ConcreteDecorator）：向组件添加职责


## 示例
- 方式1：

      <?php
      /* 抽象组件角色-被装饰者的接口 */
      interface Component
      {
          function draw();
      }
      /* 具体组件角色-被装饰者 */
      class ConcreteComponent implements Component
      {
          function draw()
          {
              echo "original page \r\n";
          }
      }
      /* 抽象装饰角色 */
      abstract class Decorator implements Component {
          private $_component;
          public function __construct(Component $component){
              $this->_component = $component;
          }
          function draw() {
              $this->_component->draw();
          }
      }
      /* 具体装饰器 */
      class SizeDecorator extends Decorator {
          function draw(){
              $this->beforeDraw();
              parent::draw();
              $this->afterDraw();
          }

          function beforeDraw() {
              echo "before size \r\n";
          }
          function afterDraw() {
              echo "after size \r\n";
          }
      }
      /* 具体装饰器 */
      class ColorDecorator extends Decorator {
          function draw(){
              $this->beforeDraw();
              parent::draw();
              $this->afterDraw();
          }

          function beforeDraw() {
              echo "before color \r\n";
          }
          function afterDraw() {
              echo "after color \r\n";
          }
      }

      //调用
      $page1 = new ConcreteComponent();
      $page1->draw();
      $page2 = new ColorDecorator(new ConcreteComponent());
      $page2->draw();
      $page3 = new SizeDecorator(new ColorDecorator(new ConcreteComponent()));
      $page3->draw();

- 方式2：

      <?php
      /* 装饰器接口 */
      interface Decorator
      {
          function beforeDraw();

          function afterDraw();
      }
      /* 具体装饰器 */
      class ColorDecorator implements Decorator
      {
          function beforeDraw()
          {
              echo "before color \r\n";
          }

          function afterDraw()
          {
              echo "after color \r\n";
          }
      }
      /* 具体装饰器 */
      class SizeDecorator implements Decorator
      {
          function beforeDraw()
          {
              echo "before size \r\n";
          }

          function afterDraw()
          {
              echo "after size \r\n";
          }
      }
      /* 被装饰者-可添加、删除装饰器 */
      class Page {
          protected $decorators = [];

          public function addDecorator(Decorator $decorator)
          {
              array_push($this->decorators, $decorator);
          }

          public function removeDecorator(Decorator $decorator)
          {
              $index = array_search($decorator, $this->decorators);
              if($index !== false) {
                  unset($this->decorators[$index]);
              }
         }

          public function draw() {
              $this->beforeDraw();
              echo "Original Page \r\n";
              $this->afterDraw();
          }

          public function beforeDraw() {
              foreach($this->decorators as $decorator) {
                  $decorator->beforeDraw();
              }
          }

          public function afterDraw() {
              $decorators = $this->decorators;
              while($decorator = array_pop($decorators)) {
                  $decorator->afterDraw();
              }
          }
      }
      //调用
      $page = new Page();
      $page->draw();
      $colorDecorator = new ColorDecorator();
      $page->addDecorator($colorDecorator);
      $page->draw();
      $sizeDecorator = new SizeDecorator();
      $page->addDecorator($sizeDecorator);
      $page->draw();
      $page->removeDecorator($colorDecorator);
      $page->draw();

 
