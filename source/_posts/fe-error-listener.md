---
layout: post
title: 前端错误监控与错误上报
date: 2019-08-06 22:25:50
tags:
  - 错误上报
---

## 错误类型
1. 及时运行错误(代码错误)
> try..catch
> window.onerror
2. 资源加载错误
> object.onerror
> performance.getEntries() //加载所有的资源链接,返回数组，间接判断
> Error 事件捕获 
```
window.addEventListener('error', function(e) {
  console.log(e)
}, true)
```

> js 跨域可以拿到错误吗，返回什么，怎么处理错误
返回`类型：Script error 出错行： 0 0  内容：null`,
script 增加 `crossorigin`；js后台加`Access-Control-Allow-Origin: *`

## 错误上报：
1. Ajax
2. 利用Image对象上报

## 参考
[Tencent CDC（https://cdc.tencent.com/2018/09/13/frontend-exception-monitor-research/）](https://cdc.tencent.com/2018/09/13/frontend-exception-monitor-research/)
