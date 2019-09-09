---
layout: post
title: docker学习-mac
date: 2019-08-26 22:19:30
tags:
  - docker
---
## 下载
[官方](https://docs.docker.com/docker-for-mac/install/)
[阿里云](http://mirrors.aliyun.com/docker-toolbox/mac/docker-for-mac/)
## [文档](https://docs.docker.com/docker-for-mac/)

##  Docker和传统虚拟化的区别
![WX2019](http://imgs.afacode.top/WX20190826-200550@2x-201982620652.png)

## 镜像加速
> Docker for mac 应用图标 -> Perferences... -> Daemon -> Registry mirrors
修改完成之后，点击 Apply & Restart 按钮
```
网易加速器：http://hub-mirror.c.163.com

官方中国加速器：https://registry.docker-cn.com

ustc的镜像：https://docker.mirrors.ustc.edu.cn

https://dockerhub.azk8s.cn,

https://reg-mirror.qiniu.com,
```
![mac-afacode-2019826201540](http://imgs.afacode.top/mac-afacode%202019-08-26%2020.15.13-2019826201540.png)
> docker info 查看是否配置成功
```
...
Registry Mirrors:
  http://hub-mirror.c.163.com/
  https://registry.docker-cn.com/
...
```
## [常用命令](https://docs.docker.com/engine/reference/commandline/docker/)
## 各个关系
镜像
容器
利用 Dockerfile 来创建镜像
![WX2019](http://imgs.afacode.top/WX20190826-202306@2x-2019826202354.png)

