# 里氏替换原则(Liskov Substitution Principle LSP)

## 核心思想
- **子类必须能够替换其基类**
- **子类可以扩展基类的功能，但不能修改基类原有的功能（子类尽量不要重载/重写基类的方法）**

## 概念
- 面向对象设计的基本原则之一，描述的是**基类与子类的关系**
- 任何基类可以出现的地方，子类一定可以出现 
- 是**继承复用**的基石，只有当子类可以替换基类，软件单位的功能不受影响时，基类才能真正的被复用，而子类也可以在基类的基础上增加新的行为


## 目的
- 增加程序的健壮性，需求变化时也可以保持良好的兼容性和稳定性，即使增加子类，原有的子类可以继续运行。在实际项目中，每个子类对应不同的业务含义，**使用父类作为参数**，传递不同的子类完成不同业务逻辑。