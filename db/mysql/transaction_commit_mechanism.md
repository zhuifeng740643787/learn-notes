# 事务提交机制
- [参考文档1](https://qidawu.github.io/2018/10/27/mysql-transaction-autocommit/)
- [参考文档2](https://www.cnblogs.com/kerrycode/p/8649101.html)

## 自动提交机制
- **在 InnoDB，所有用户活动都发生在事务中**
- 默认采用事务自动提交（autocommit）机制
    + 也就是说，***如果不是显式开启一个事务，则每条 SQL 语句都形成独立事务***。如果该语句执行后没有返回错误，MySQL 会自动执行 COMMIT。但如果该语句返回错误，则根据错误情况执行 COMMIT 或 ROLLBACK。
    + 如何关闭自动提交机制
        * `SET AUTOCOMMIT = 0`
    + 关闭后，会话将始终开启一个事务。直到你显式提交或回滚该事务后，一个新事务又被开启。
    + 如果一个关闭了 autocommit 的会话没有显式提交事务，然后会话被关闭，MySQL 将回滚该事务。
    + 有一些命令，在执行之后会强制执行 COMMIT 提交当前的活动事务。例如：
        * ALTER TABLE
        * LOCK TABLES
    + 对于显性事务start transaction或begin， 在自动提交模式关闭（关闭隐式提交）的情况下，开启一个事务上下文。首先数据库会 ***隐式提交之前的还未被提交的操作***，同时开启一个新事务。
