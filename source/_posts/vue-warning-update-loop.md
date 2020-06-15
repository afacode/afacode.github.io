---
layout: vue
title: You may have an infinite update loop in a component render function
date: 2020-06-15 16:33:47
tags:
  - vue
---

## 问题
vue for 里面数组渲染翻转 警告
You may have an infinite update loop in a component render function

## 修复
issus回复 https://github.com/vuejs/vue/issues/1153
```
<div v-for="(itemi, idxi) in productDetails.details" :key="idxi">
  <ul class="status-list">
    <li v-for="(itemx, idxx) in itemi.kdinfo.Route.reverse()" :class="idxx=== 0 ?'latest':''" :key="idxx">{{itemx.accept_time}}

    修改为 itemi.kdinfo.Route.slice().reverse()
  </ul>
  </div>
</div>
</div>
```