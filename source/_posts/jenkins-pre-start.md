---
layout: post
title: jenkins准备及安装
date: 2019-09-05 22:13:03
tags:
  - Jenkins

---
## 环境
[https://jenkins.io/zh/doc/pipeline/tour/getting-started/](https://jenkins.io/zh/doc/pipeline/tour/getting-started/)
1. centos 6.8
2. 内网环境
3. git 
4. java8
5. node
6. nginx

## ssh 连接
* 确定Linux系统可以SSH远程连接，即SSH服务已经启动。
`netstat -anp | grep :22` 出现下图表示已经启动
![01](http://imgs.afacode.top/01-201999151816.png)

若没有启动，则输入启动ssh服务命令：service sshd start 来启动ssh服务

* ssh 连接 `ssh username@ip`

## 关闭防火墙
```
service iptables stop
检查防火墙状态的命令：service iptables status    
出现 Stopped IPv4 firewall with iptables 证明防火墙已经关闭
```
## 安装JAVA环境
```
yun install java

java -version
1.8.0_151
```
## git安装及配置
```
yum install git 
git version
git config --global user.name "afacode" # 随意
git config --global user.email "afacode@abc.com" # 不一定要真实的
连续 enter
cd ~/.ssh/
ls
cat id_rsa.pub 公钥  复制到  new ssh
github登陆 setting SSH and GPG keys new ssh

测试
ssh git@github.com
Hi afacode! You've successfully authenticated
```
## Node安装
```
下载
https://nodejs.org/en/download/

cd ~
wget https://nodejs.org/dist/v10.16.3/node-v10.16.3-linux-x64.tar.xz

xz -d node-v10.16.3-linux-x64.tar.xz

tar -xf node-v10.16.3-linux-x64.tar

ln -s /root/node-v10.16.3-linux-x64/bin/node /usr/local/bin/node

ln -s /root/node-v10.16.3-linux-x64/bin/npm /usr/local/bin/npm

npm -v
6.9.0

node -v
v10.16.3
```

## 下载Jenkins
`wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war`
![04-20199915285](http://imgs.afacode.top/04-20199915285.png)


## 运行 java -jar jenkins.war --httpPort=8080
密码在上图找
访问 ip:8080
## 初始化
* 创建用户

* 推荐安装
![05-201999153328](http://imgs.afacode.top/05-201999153328.png)

* 登陆
O![07-20199915348](http://imgs.afacode.top/07-20199915348.png)


## 后续
1. jenkins的使用
2. git + jenkins + docker 的集成