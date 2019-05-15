---
layout: post
title: vue router
date: 2018-09-14 22:34:55
categories:
  - js
tags:
  - vue
  - vue router
---

## vue router

```
<router-link to="/foo">Go to Foo</router-link>

this.$route.params

this.$router.go(-1)
this.$router.push('/')

routes: [
    // 动态路径参数 以冒号开头
    { path: '/user/:id', component: User }
]
<div>User {{ $route.params.id }}</div>
```

vue里的路由钩子


欢迎访问我的博客 &nbsp;[地址](blog.afacode.top) &nbsp; &nbsp; &nbsp;
https://blog.afacode.top