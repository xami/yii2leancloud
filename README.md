Yii 2 整合 leanCloud登陆、注册、第三方登陆
============================
基于最新的yii2 basic开发完成，集成了一些必要的扩展支持。

计划实现：登陆、注册、第三方登陆的基本逻辑。

可基于此版本再做二次开发，欢迎大家加入完善。

问题讨论，反馈QQ群：464984083

演示地址：
-------------------
http://yii2leancloud.odube.com


安装步骤：
-------------------
1、删除 basic/composer.lock，执行composer install更新依赖

2、安装数据库(`mobilePhoneNumber`配合leancloud的数据库存储本地的手机号)

``
 CREATE TABLE `users` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `username` varchar(20) NOT NULL DEFAULT '',
   `password` varchar(128) NOT NULL DEFAULT '',
   `email` varchar(128) NOT NULL,
   `mobilePhoneNumber` varchar(32) NOT NULL,
   `activkey` varchar(128) NOT NULL DEFAULT '',
   `superuser` int(1) NOT NULL DEFAULT '0',
   `status` int(1) NOT NULL DEFAULT '0',
   `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `lastvisit_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
   PRIMARY KEY (`id`),
   UNIQUE KEY `user_username` (`username`)
 ) ENGINE=InnoDB AUTO_INCREMENT=151240 DEFAULT CHARSET=utf8; 
``

3、LeanCloud后台“设置》应用选项》”勾选
 启用注册用户邮箱验证
 验证注册用户手机号码
 允许未验证手机号码用户通过短信重置密码






