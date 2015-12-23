#为测试而生的初始化数据库命令

#如果有awesome数据库，就删除掉
drop database if exists blessingSMS;
#重新建立一个awesome数据库
create database blessingSMS;
#把awesome切换为当前用数据库
use blessingSMS;
#给'www-data'@'127.0.0.1'用户设置awesome数据库下所有表以select，insert，update，delete 的权限
grant select, insert, update, delete on blessingSMS.* to 'www-data'@'127.0.0.1' identified by 'www-data';
#创建表sms
create table sms (
    `id` varchar(50) not null,
    `category_name` varchar(50) not null,
    `category_id` varchar(50) not null,
    `content` varchar(500) not null,
    `created_at` real not null
) engine=innodb default charset=utf8;
