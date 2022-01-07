---
layout: post
title: 关于[vuejs](https://github.com/vuejs)/**vue-next** 中使用 for 填充数组 关于代码执行速度讨论
date: 2021-11-20 18:38:22
tags:
  - fill
  - vue
---

### 关于[vuejs](https://github.com/vuejs)/**vue-next** 中使用 for 填充数组的讨论
> fill for  new Array(len) 初始化赋值

> packages/runtime-core/src/createRenderer.ts

```js
// toBePatched 数组长度

// 原有
const newIndexToOldIndexMap = []
for (i = 0; i < toBePatched; i++) newIndexToOldIndexMap.push(0)

// pr 代码
const newIndexToOldIndexMap = new Array(toBePatched).fill(0)

// 现有优化
// This is even faster (and won't require a polyfill when we do IE11 support):
const newIndexToOldIndexMap = new Array(toBePatched)
for (i = 0; i < toBePatched; i++) newIndexToOldIndexMap[i] = 0
```

讨论地址 https://github.com/vuejs/vue-next/pull/319

执行测试结果 https://jsperf.com/array-fill-vs-loop

new Array(toBePatched) 数组可开辟固定大小, 不需计算扩容

## Array.prototype.fill() 基础
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fill

```js
fill(value, start, end)

arr.fill(value[, start[, end]])

value
Value to fill the array with. (Note all elements in the array will be this exact value.)

start Optional
Start index (inclusive), default 0.

end Optional
End index (exclusive), default arr.length.
```