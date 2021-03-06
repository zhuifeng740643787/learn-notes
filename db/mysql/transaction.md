# 事务
- 事务是由一组SQL语句组成的逻辑处理单元 

## ACID属性
- 原子性（Atomicity）:事务被视为不可分割的最小单元，要么全部提交成功，要么全部失败回滚。
- 一致性（Consistency）:事务执行前后都保持一致性状态。在一致性状态下，所有事务对一个数据的读取结果都是相同的。
- 隔离性（Isolation）: 一个事务所做的修改在最终提交以前，对其它事务是不可见的。
- 持久性（Durability）:一旦事务提交，对其所做的修改就会永久保存到数据库中，此时即使系统崩溃，修改的数据也不会丢失

## 并发事务处理带来的问题
相对于串行处理来说，并发事务处理能大大增加数据库资源的利用率，提高数据库系统的事务吞吐量，从而可以支持更多的用户，但并发处理也会带来一些问题，如下
- 更新丢失(Lost Update)：当两个或多个事务选择同一行，然后基于最初选定的值更新该行时，由于每个事务都不知道其他事务的存在，就会发生丢失更新问题－－`最后的更新覆盖了由其他事务所做的更新`。 
- 脏读(Dirty Reads)：一个事务正在对一条记录做修改，在这个事务完成并提交前，这条记录的数据就处于不一致状态；这时，另一个事务也来读取同一条记录，如果不加控制，第二个事务读取了这些“脏”数据，并据此做进一步的处理，就会产生`未提交的数据`依赖关系。这种现象被形象地叫做”脏读”。
- 不可重复读(Non-Repeatable Reads)：`一个事务`在读取某些数据后的某个时间，`再次读取以前读过的数据，却发现其读出的数据已经发生了改变`、或某些记录已经被删除了！这种现象就叫做“不可重复读”。
- 幻读(Phantom Reads)：`一个事务`按相同的查询条件重新读取以前检索过的数据，却发现`其他事务插入了满足其查询条件的新数据`，这种现象就称为“幻读”。

## 事务隔离级别
- 在并发事务处理带来的问题中，“更新丢失”通常是应该完全避免的。但防止更新丢失，并不能单靠数据库事务控制器来解决，需要应用程序对要更新的数据加必要的*锁*来解决，因此，防止更新丢失应该是应用的责任。
- 脏读”、“不可重复读”和“幻读”，其实都是数据库读一致性问题，必须由数据库提供一定的事务隔离机制来解决。数据库实现事务隔离的方式，基本上可分为以下两种:
    + 在读取数据前，对其加锁，阻止其他事务对数据进行修改（悲观锁）
    + 不用加任何锁，通过一定机制生成一个数据请求时间点的`一致性数据快照`（Snapshot)，并用这个快照来提供一定级别（语句级或事务级）的一致性读取。从用户的角度来看，好像是数据库可以提供同一数据的多个版本，因此，这种技术叫做`数据多版本并发控制`（MultiVersion Concurrency Control，简称MVCC或MCC），也经常称为多版本数据库。
- 数据库的事务隔离越严格，并发副作用越小，但付出的代价也就越大，因为事务隔离实质上就是使事务在一定程度上 “串行化”进行，这显然与“并发”是矛盾的。同时，不同的应用对读一致性和事务隔离程度的要求也是不同的，比如许多应用对“不可重复读”和“幻读”并不敏感，可能更关心数据并发访问的能力。
- 四个隔离级别

   | 隔离级别 | 读数据一致性 | 脏读 | 不可重复读 | 幻读 |
   |---------|------------|:----:|:---------:|:----:| 
   | 未提交读（Read uncommitted） |   最低级别，事务中的修改，即使没有提交，对其它事务也是可见的） | 是 | 是 | 是 |
   | 已提交度（Read committed） | 语句级，一个事务只能读取已经提交的事务所做的修改。换句话说，一个事务所做的修改在提交之前对其它事务是不可见的 | 否 | 是 | 是 |
   | 可重复读（Repeatable read） | 事务级，保证在同一个事务中多次读取同样数据的结果是一样的 | 否 | 否 | 是 |
   | 可序列化（Serializable） | 强制事务串行执行 | 否 | 否 | 否 |

- 各数据库实现的隔离级别区别
    + Oracle只提供Read committed和Serializable两个标准隔离级别，另外还提供自己定义的Read only隔离级别；
    + SQL Server除支持上述ISO/ANSI SQL92定义的4个隔离级别外，还支持一个叫做“快照”的隔离级别，但严格来说它是一个用MVCC实现的Serializable隔离级别。
    + MySQL 支持全部4个隔离级别，但在具体实现时，有一些特点，比如`在一些隔离级别下是采用MVCC一致性读，但某些情况下又不是`，这些内容在后面的章节中将会做进一步介绍。

## 锁

## 锁的粒度
应尽量只锁定需要修改的那部分数据，而不是所有的资源。锁定的数据量越少，发生锁争用的可能就越小，系统的并发程度就越高。但加锁需要消耗资源，锁的各种操作，包括获取锁，检查锁是否已经解除、释放锁，都会增加系统开销。因此封锁粒度越小，系统开销就越大。
在选择封锁粒度时，需要在锁开销和并发程度之间做一个权衡。
- 行级锁
- 表级锁

### 锁的类型
- 排它锁（Exclusive）,简写为X锁，又称写锁
- 共享锁（Shared）,简写为S锁，又称读锁
- 规定：  
    + 一个事务对数据对象 A 加了 X 锁，就可以对 A 进行读取和更新。加锁期间其它事务不能对 A 加任何锁。
    + 一个事务对数据对象 A 加了 S 锁，可以对 A 进行读取操作，但是不能进行更新操作。加锁期间其它事务能对 A 加 S 锁，但是不能加 X 锁。
    + 兼容关系如下
        
			| 兼容关系 | X(排它锁) | S(共享锁) |
			| -- | -- | -- |
			| X(排它锁) | NO | NO |
			| S(共享锁) | NO | YES |
























