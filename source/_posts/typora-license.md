---
layout: post
title: 2024使用Typora免费使用(mac)
date: 2024-07-05 21:13:21
tags:
    - Typora
---

- 版本1.8.10 (7132) 请在官网支持[https://typoraio.cn](https://typoraio.cn)

## 下载安装

## 判断是否已激活 
- 找到Typora安装目录对应文件
```js
/Applications/Typora.app/Contents/Resources/TypeMark/page-dist/static/js/LicenseIndex.XX.XXX.chunk.js

// 查找
e.hasActivated="true"==e.hasActivated,
// 替换为
e.hasActivated="true"=="true",
```
保存失败的话复制一份代码 修改 替换

## 关闭激活弹窗
```js
/Applications/Typora.app/Contents/Resources/TypeMark/page-dist/license.html

// 查找
</body></html>
// 修改为
</body><script>window.onload=function(){setTimeout(()=>{window.close();},5);}</script></html>

```

## 去除右下角未激活提示
- 可以找对应的语言
```js
/Applications/Typora.app/Contents/Resources/TypeMark/locales/zh-Hans.lproj/Panel.json

// 查找
"UNREGISTERED":"未激活"
// 修改为
"UNREGISTERED":" "

```

- 如果有能力的话支持下Typora作者