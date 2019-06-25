---
layout: post
title: mac+brew 安装 mysql
date: 2019-06-15 17:00:38
tags:
  - mysql
  - tool
---

## brew 工具，如果没有的话

```
# 安装 homebrew，是的你没看错，在终端里粘贴以下命令即可
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
## 查看mysql包情况
> 查看当前最新稳定包`brew info mysql`
![mysql msg](http://imgs.afacode.top/mac-afacode%202019-06-15%2017.15.02-2019615171527.png)

1. MYSQL的版本
2. 它存在一些冲突包，没有办法和他们共存
3. 安装后默认是没有密码的，如果你想安全一点，可以执行 `mysql_secure_installation` 来进行引导安全设置
4. 你可以将MYSQL设置为开机启动， `brew services start mysql`
5. 你也可以每次都手动启动或关闭MYSQL `mysql.server start/stop/restart`


> 查看当前包信息`brew search mysql`

## 安装mysql
> `brew install mysql` 可以在mysql后面跟指定版本`mysql@5.7`

* 如果遇到权限问题，会有提示,按照提示完成
![权限问题](http://imgs.afacode.top/mac-afacode%202019-06-15%2017.08.36-201961517166.png)
```
sudo chown -R $(whoami) /usr/local/share/man/man5 /usr/local/share/man/man7
chmod u+w /usr/local/share/man/man5 /usr/local/share/man/man
```

## MYSQL使用
* 重启 `brew service restart mysql`
* 设置为开机启动 `brew services start mysql`
* 关闭 `brew services stop mysql`
* 手动启动或关闭 `mysql.server start/stop/restart`
* 查看状态 `brew services list`
```
Name  Status  User    Plist
mysql started afacode /Users/..../Library/LaunchAgents/homebrew.mxcl.mysql.plist
```
## 设置密码
> `mysql_secure_installation` 
```
Press y|Y for Yes, any other key for No: y   //使用密码验证

LOW    Length >= 8
MEDIUM Length >= 8, numeric, mixed case, and special characters
STRONG Length >= 8, numeric, mixed case, special characters and dictionary file

Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 0  // 选择密码验证等级

New password:    // 输入新密码

Re-enter new password: 

Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : y   //是否希望继续提供密码保护

Remove anonymous users? (Press y|Y for Yes, any other key for No) : y   //删除匿名用户


Disallow root login remotely? (Press y|Y for Yes, any other key for No) : n // 是否禁止远程登录

Remove test database and access to it? (Press y|Y for Yes, any other key for No) : n  // 是否删除测试库

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y  // 刷新数据库权限

```
![安装过程](http://imgs.afacode.top/WX20190615-184621@2x-2019615184655.png)
![安装过程2](http://imgs.afacode.top/WX20190615-184558@2x-2019615184646.png)

## 登陆
> mysql -uroot -p

> show databases;

> use mysql;

> show tables;

> exit;

## navicat连接

### 报错 `2059 - Authentication plugin 'caching_sha2_password' cannot be loaded dlope`

`2059 - Authentication plugin 'caching_sha2_password' cannot be loaded: dlopen(../Frameworks/caching_sha2_password.so, 2): image not found`
![2059 error](http://imgs.afacode.top/WX20190616-100036@2x-201961610056.png)

### 解决方法
```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '密码';

FLUSH PRIVILEGES;
```

![success](http://imgs.afacode.top/WX20190616-095947@2x-201961610116.png)
