---
layout: post
title: 通过给定的选择器来获取对象中的值(js)
date: 2021-08-08 23:28:15
tags:
  - js
---

### 通过给定的选择器来获取对象中的值
> 需求
```js
输入一个
const obj = {
	selector: {to: {val: "asdasd"}},
	user: {name: "afacode"},
	target: [1, 2, {a: "demo"}]
}
get(obj, "selector.to.val", "target[0]", "user.name")
输出 [ 'asdasd', 1, 'afacode' ]
实现 get()
```

```js
const obj = {
	selector: {to: {val: "asdasd"}},
	user: {name: "afacode"},
	target: [1, 2, {a: "demo"}]
}

function get(from, ...selectors) {
	const n = selectors.map(s => {
		return s
			.replace(/\[(\w+)\]/g, ".$1")
			.split(".")
			.reduce((prev, cur) => {
				return prev && prev[cur]
		}, from)
	})
	return n
}
const c = get(obj, "selector.to.val", "target[0]", "user.name")

console.log(c)
```