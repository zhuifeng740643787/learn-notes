# 依赖倒置原则（Dependence Inversion Principle DIP）

## 核心思想
- **依赖于抽象**
  + 高层模块不依赖于低层模块，二者都同依赖于抽象
  + 抽象不依赖于具体，具体依赖于抽象

## 概念
- **依赖于抽象，不依赖于具体**
- **对抽象进行编程，不对实现进行编程**，以降低客户与实现模块间的耦合

## 优点
- 面向过程开发，上层调用下层，上层依赖于下层，当下层剧烈变化时，上层也要跟着变化，这就会导致模块的复用性降低而且大大提高了开发的成本。<br/>
面向对象的开发很好的解决了这个问题，一般的情况下**抽象的变化概率很小**，___让用户程序依赖于抽象，实现的细节也依赖于抽象___。即使实现细节不断变化，只要抽象不变，客户程序就不需要变化。这大大降低了客户程序域实现细节的耦合度。

## 示例
一个合资汽车公司现在要求开发一个自动驾驶系统，只要汽车上安装上这个系统，就可以实现无人驾驶，该系统可以在福特车系列和本田车系列上使用。
- 面向过程的实现：

      <?php
      class HondaCar {
        function run(){}
        function turn(){}
        function stop(){}
      }
      class FordCar {
        function run(){}
        function turn(){}
        function stop(){}
      }
      class AutoSystem {
        protected $carType;
        protected $honda;
        protected $ford;
        function __construct($carType) {
          $this->carType = $carType;
          $this->honda = new HondaCar();
          $this->ford = new FordCar();
        }
        function runCar(){
          if($this->carType == 'honda'){
            $this->honda->run();
          } else if($this->carType == 'ford') {
            $this->ford->run();
          }
        }
        function turnCar(){
          if($this->carType == 'honda'){
            $this->honda->turn();
          } else if($this->carType == 'ford') {
            $this->ford->turn();
          }
        }
        function stopCar(){
          if($this->carType == 'honda'){
            $this->honda->stop();
          } else if($this->carType == 'ford') {
            $this->ford->stop();
          }
        }
      }
  
  缺点：如果现在公司业务规模扩大了，该自动驾驶系统还要把吉普车也兼容了。这些就需要修改AutoSystem类如下：

      class JeepCar {
        function run(){}
        function turn(){}
        function stop(){}
      }
      class AutoSystem {
        ***
        protected $jeep;
        function __construct($carType) {
          ***
          $this->jeep = new JeepCar();
        }
        function runCar(){
          ***
          } else if($this->carType == 'jeep') {
            $this->jeep->run();
          }
        }
        function turnCar(){
          ***
          } else if($this->carType == 'jeep') {
            $this->jeep->turn();
          }
        }
        function stopCar(){
          ***
          } else if($this->carType == 'jeep') {
            $this->jeep->stop();
          }
        }
      }

  这样会导致系统越来越臃肿，越来越大，而且依赖越来越多低层模块，只有低层模块变动，AutoSystem类就不得不跟着变动，导致系统设计变得非常脆弱和僵硬。<br/>
  导致上面所述问题一个原因是，含有高层策略的模块，如AutoSystem模块，依赖于它所控制的低层的具体细节的模块（如FordCar和HondaCar）。如果能使AutoSystem模块独立于它所控制的具体细节，而是依赖抽象，那么我们就可以复用它了。这就是面向对象中的“依赖倒置”机制

- DIP原则实现：

      <?php
      /* 定义Car的接口 */
      interface ICar {
        function run();
        function turn();
        function stop();
      } 
      class HondaCar implements ICar(){
        function run(){}
        function turn(){}
        function stop(){}
      }
      class FordCar implements ICar(){
        function run(){}
        function turn(){}
        function stop(){}
      }      
      class JeepCar implements ICar(){
        function run(){}
        function turn(){}
        function stop(){}
      } 
      class AutoSystem {
        protected $car;
        function __construct(ICar $car) {
          $this->car = $car;
        }
        function runCar(){
          $this->car->run();
        }
        function turnCar(){
          $this->car->turn();
        }
        function stopCar(){
          $this->car->stop();
        }
      }
      
  现在Autosystem系统依赖于ICar这个抽象，而与具体的实现细节HondaCar:和FordCar无关，所以实现细节的变化不会影响AutoSystem.对于实现细节只要实现ICar即可。即实现细节依赖于ICar抽象。

- 总结
  - 一个应用中的重要策略决定及业务 正是在这些高层的模块中。也正是这些模块包含这应用的特性。但是，当这些模块依赖于低层模块时，低层模块的修改将直接影响到他们，迫使它们也改变。这种情况是荒谬的。
  - 应该是**处于高层的模块去迫使那些低层的模块发生改变**。处于高层的模块应优先于低层的模块。无论如何高层模块也不应该依赖于低层模块。而且我们想能够复用的是高层的模块，只有高层模块独立于低层模块时，复用才有可能。
  - 总之，**高层次的模块不应该依赖于低层次的模块，它们都应该依赖于抽象。抽象不应该依赖于具体，具体应该依赖于抽象**。

