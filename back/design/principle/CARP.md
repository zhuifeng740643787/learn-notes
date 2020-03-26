# 合成/聚合复用原则（Composite/Aggregate Reuse Principle CARP）

## 概念
- 组合和聚合都是对象建模中关联（Association）关系的一种
- 聚合表示整体与部分的关系，表示“含有”，整体由部分组合而成，部分可以脱离整体作为一个独立的个体存在
- 组合则是一种更强的聚合，部分组成整体，而且不可分割，部分不能脱离整体而单独存在。
- 在合成关系中，部分和整体的生命周期一样，组合的新的对象完全支配其组成部分，包括他们的创建和销毁。一个合成关系中成分对象是不能与另外一个合成关系共享。
- **组合/聚合和继承是实现复用的两个基本途径。合成复用原则是指尽量使用合成/聚合，而不是使用继承。**

## 注意
只有当以下的条件全部被满足时，才应当使用继承关系。
- 子类是超类的一个特殊种类，而不是超类的一个角色，也就是区分“Has-A”和“Is-A”.只有“Is-A”关系才符合继承关系，“Has-A”关系应当使用聚合来描述。
- 永远不会出现需要将子类换成另外一个类的子类的情况。如果不能肯定将来是否会变成另外一个子类的话，就不要使用继承。
- 子类具有扩展超类的责任，而不是具有置换掉或注销掉超类的责任。如果一个子类需要大量的置换掉超类的行为，那么这个类就不应该是这个超类的子类。

错误的使用继承而不是合成/聚合的一个常见原因是错误地把“Has-A”当成了“Is-A”.”Is-A”代表一个类是另外一个类的一种；而“Has-A”代表一个类是另外一个类的一个角色，而不是另外一个类的特殊种类。
    
## 示例
- 我们需要办理一张银行卡，如果银行卡默认都拥有了存款、取款和透支的功能，那么我们办理的卡都将具有这个功能，
  + 使用继承关系：

        <?php
        /*银行卡接口*/
        interface Card {
          function deposite();//存款
          function withdraw();//取款
          function overdraw();//透支
        }
        /*招商银行卡*/
        class CmbcCard implements Card {
          function deposite(){} 
          function withdraw(){} 
          function overdraw(){} 
        }

  + 为了灵活地拥有各种功能，此时可以分别设立储蓄卡和信用卡两种，并有银行卡来对它们进行聚合使用。此时采用了合成复用原则: 

        <?php
        /*储蓄卡接口*/
        interface IDepositCard {
          function deposite();//存款
          function withdraw();//取款
        }
        /*信用卡接口*/
        interface ICreditCard {
          function overdraw();//透支
        }
        /*银行卡*/
        class Card implements IDepositCard, ICreditCard {
          function deposite(){} 
          function withdraw(){} 
          function overdraw(){} 
        }
        /*招商银行卡*/
        class CmbcCard extends Card {
          ***
        }
        