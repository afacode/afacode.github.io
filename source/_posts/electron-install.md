---
layout: electron
title: 解决electron无法安装问题
date: 2019-12-28 15:42:57
tags:
  - npm
  - electron
---

## electron 无法安装解决方法

```
打开
vim ~/.npmrc

添加
electron_mirror="https://npm.taobao.org/mirrors/electron/"

source ~/.npmrc
```
