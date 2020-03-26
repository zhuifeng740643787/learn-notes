# 规范
[参考文档](https://www.kancloud.cn/wubx/mysql-sql-standard/600517)

## DDL语句
- 表
    + 命名要见名知意，**禁止使用拼音首字母**
    + 必须有注释且清晰准确
    + 为了高并发，禁用外键
    + 必须有一个 自增 无符号 的主键, 且不要使用字符型
    + 字符集设定为utf8
    + 三个必加字段
        * id (unsigned INT/BIGINT 主键）
        * created_at (timestamp 创建时间)
        * updated_at (timestamp 更新时间)
- 字段
    + 字段名称都为小写，单词间以`_`分隔
    + 命名要见名知意，**禁止使用拼音首字母**
    + 必须有注释且清晰准确
    + 字符集设定为utf8，需要存储emoji字符的，则选择utf8mb4字符集
    + 尽量小的原则，节省磁盘和内存空间，如tinyint(3), int(10), char(11), varchar(50)
    + 建议不超过30-50个字段
    + 整型数据时，默认加上UNSIGNED，扩大存储范围
    + 遇到BLOB、TEXT字段，则尽量拆出去，再用主键做关联
    + 涉及精确金额相关用途时，建议扩大N倍后，*全部转成整型*存储（例如把分扩大百倍），避免浮点数加减出现不准确问题
    + 设置*默认值且NOT NULL*属性，减少存储开销及避免索引失效问题
- 安全
    + 严禁明文存储敏感数据，如密码，身份证
- 索引
    + 非唯一索引按照“i_表名_字段名称_字段名称[_字段名]”进行命名。
    + 唯一索引按照“u_表名_字段名称_字段名称[_字段名]”进行命名。
    + 索引名称使用小写
    + 字段数不超过5个
    + 唯一键不要和主键重复
    + 使用EXPLAIN判断SQL语句是否合理使用索引，尽量避免extra列出现：Using File Sort，Using Temporary
    + 合理创建联合索引（避免冗余），(a,b,c) 相当于 (a) + (a,b) + (a,b,c) 
- 例子
```sql
CREATE TABLE `article` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '分类 1、专栏 2、纪要 3、要闻 4、研报',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '发布者ID',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '状态 0、取消  1、保存未发布 2、保存并发布  3、待审核 4、审核通过 5=审核未通过',
  `title` varchar(20) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 NOT NULL COMMENT '内容',
  `keywords` varchar(50) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '关键词',
  `cover_img_md5` char(32) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '封面图MD5',
  `price` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '阅读价格(单位为分)',
  `score` decimal(3,1) unsigned NOT NULL DEFAULT '0.0' COMMENT '文章评分',
  `view_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文章点击量',
  `share_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文章分享次数',
  `labels` varchar(300) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '所属标签（多个标签id用‘,’分隔）',
  `is_original` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '是否原创1、是 0、否',
  `refer_source` varchar(50) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '转载来源',
  `refer_link` varchar(200) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '文章源地址',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序值，由大到小',
  `verify_admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '审核人id',
  `verify_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '审核时间',
  `remark` varchar(200) NOT NULL DEFAULT '' COMMENT '备注',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `i_article_created_at` (`created_at`),
  KEY `u_article_title` (`title`),
  KEY `i_article_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章';
```

## DML语句
- select
    + 禁用`*`，否则会浪费带宽和内存
    + where条件
        * 表字段不能有表达式或是函数，否则会导致不能使用索引
        * int型的字段查询时不要加引号，如order_id='1'，这样会导致不能使用索引
    + 减少或避免临时表
        * 注意：如果有一个ORDER BY子句和不同的GROUP BY子句，或如果ORDER BY或GROUP BY包含联接队列中的第一个表之外的其它表的列，则创建一个临时表
        * explain执行分析后extra部分会出现 using temporary 和 using filesort 关键字
    + 避免使用join
    + 使用存储过程、触发器、函数、events等
    + IN包含的值不超过500个
- update/delete
    + 尽量使用主键进行update和delete
    + 禁止在Update语句，将“,”写成“and”，非常危险
