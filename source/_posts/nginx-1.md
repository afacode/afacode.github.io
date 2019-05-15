---
layout: post
title: 域名跳转
date: 2019-05-14 23:11:29
categories:
  - linux
tags:
  - nginx
---

想让我的域名`afacode.top`默认跳转到`https://blog.afacode.top`
<!-- more -->

## 域名跳转-nginx

> ubuntu 14.04

> vim /etc/nginx/sites-available/default
```
server {
	listen 80;
	server_name www.afacode.top;
  # 跳转地址
	return 301 https://blog.afacode.top$request_uri;
}
```
> service nginx restart



欢迎访问我的博客 &nbsp;[地址](blog.afacode.top) &nbsp; &nbsp; &nbsp;
https://blog.afacode.top