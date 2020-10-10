---
layout: wxparse
title: 使用[wxParse](https://github.com/icindy/wxParse)小程序富文本解析img图片遇到的问题
date: 2020-08-20 18:03:19
tags:
  - 小程序
---

## 使用[wxParse](https://github.com/icindy/wxParse)小程序富文本解析img图片遇到的问题

小程序需要使用微信公众号的文章,微信文章图片源使用的是data-src,还有其他来源文章图片有可能无src。
使用wxParse解析富文本图片无src属性是会报错，微信公众号文章图片地址为data-src,错误定位在

![01](http://imgs.afacode.top/image-20200820173729229.png)

![02](http://imgs.afacode.top/image-20200820173758727.png)

只需要修改一行代码
```
var imgUrl = node.attr.src || node.attr['data-src'] || [];
```

![03](http://imgs.afacode.top/image-20200820174254891.png)