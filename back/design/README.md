# 设计模式

- 高内聚低耦合，是软件工程中的概念，是判断设计好坏的标准，主要是面向对象的设计，主要是看类的内聚性是否高，耦合度是否低。

## 概念 
- 耦合性：又称**块间**联系。指软件系统结构中**各模块间**相互联系紧密程度的一种度量。模块之间联系越紧密，其耦合性就越强，模块的独立性则越差。模块间耦合高低取决于模块间接口的复杂性、调用的方式及传递的信息
- 内聚性：又称**块内**联系。指模块的功能强度的度量，即一个模块内部各个元素彼此结合的紧密程度的度量。若一个模块内各元素（语名之间、程序段之间）联系的越紧密，则它的内聚性就越高。
- 高内聚：指一个软件模块是由相关性很强的代码组成，只负责一项任务，也就是常说的单一责任原则。
- 低耦合：一个完整的系统，模块与模块之间，尽可能的使其独立存在。也就是说，让每个模块，尽可能的独立完成某个特定的子功能。模块与模块之间的接口，尽量的少而简单。如果某两个模块间的关系比较复杂的话，最好首先考虑进一步的模块划分。这样有利于修改和组合。


## 设计原则
* [单一职责原则](principle/SPR.md)
* [开放封闭原则](principle/OCP.md)
* [里氏替换原则](principle/LSP.md)
* [依赖倒置原则](principle/DIP.md)
* [迪米特法则](principle/LKP.md)
* [接口隔离原则](principle/.md)
* [合成/聚合复用原则](principle/CARP.md)


## 设计模式
* [工厂模式](mode/Factory.md)
* [单例模式](mode/Singleton.md)
* [注册模式](mode/Register.md)
* [适配器模式](mode/Adapter.md)
* [策略模式](mode/Strategy.md)
* [数据对象映射模式](mode/ORM.md)
* [观察者模式](mode/Observer.md)
* [原型模式](mode/Prototype.md)
* [装饰器模式](mode/Decorator.md)
* [迭代模式](mode/Iterator.md)
* [代理模式](mode/Proxy.md)
* [外观模式](mode/Facade.md)
* [中介模式](mode/Mediator.md)
* [桥梁模式](mode/Bridge.md)
* [管道模式](mode/Pipeline.md)
* [组合模式](mode/Composite.md)
* [备忘录模式](mode/Memento.md)
* [建造者模式](mode/Builder.md)
* [命令模式](mode/Command.md)
* [模板方法模式](mode/TemplateMethod.md)
* [访问者模式](mode/Visitor.md)
