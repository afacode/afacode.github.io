---
layout: miniapp
title: 小程序wxs new Date() 不能使用
date: 2021-01-15 14:49:46
tags:
---

## 小程序wxs获取时间方式

在小程序wxs文件使用 new Date() 获取时间报错

## 解决方式
使用 getDate() 代替 new Date()
```
module.exports = {
  delHtmlTag: function (str) {
    var reg = getRegExp("<[^>]+>", "g");
    var result = str.replace(reg, '');
    return result;
  },
  formatDate: function(time) {
    var date = getDate(time)
    return date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()
  },
}

```
