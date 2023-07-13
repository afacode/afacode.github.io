---
layout: post
title: vue-router 使用需要添加多余参数(默认params 参数) 会有ts提示
date: 2022-01-04 23:34:55
categories:
  - js
tags:
  - vue
  - vue router
---
### 遇到的问题
vue-router 使用需要添加多余参数(默认params 参数) 会有ts提示
```js
不能将类型“{ name: string; path: string; params: { type: number; }; meta: { title: string; hidden: false; keepAlive: true; }; component: () => Promise<typeof import("*.vue")>; }”分配给类型“RouteRecordRaw”。
  对象文字可以只指定已知属性，并且“params”不在类型“RouteRecordSingleView”中。ts(2322)
```

### 解决方式
> 在src下新建vue-router.d.ts
```js
import { _RouteRecordBase } from 'vue-router'

declare module 'vue-router' {
	 interface _RouteRecordBase {
		 params?: Object, // router配置的多余字段
		 query?: Object,
	 }
}

```