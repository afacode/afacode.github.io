---
layout: waiting
title: Waiting for another flutter command to release the startup lock
date: 2020-05-08 17:52:46
tags:
  - flutter
---

## Waiting for another flutter command to release the startup lock...


## 解决方式
找到flutter的环境配置地址
删除 /bin/cache/lockfile 文件

> which flutter
/Users/XXX/path/flutter/bin/flutter

> 删除 /flutter/bin/cache/lockfile 文件



