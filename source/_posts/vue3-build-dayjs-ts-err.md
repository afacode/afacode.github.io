---
layout: vue3
title: 前端typescript 引入dayjs打包是报错线上不可用Cannot call a namespace ('dayjs')
date: 2021-06-20 22:10:12
tags:
  - vue
---
## 前端typescript 引入dayjs打包是报错线上不可用Cannot call a namespace ('dayjs')

> `Cannot call a namespace ('dayjs')`

官方示例

```tsx
import * as dayjs from 'dayjs'
import * as isLeapYear from 'dayjs/plugin/isLeapYear' // import plugin
import 'dayjs/locale/zh-cn' // import locale
dayjs.extend(isLeapYear) // use plugin
dayjs.locale('zh-cn') // use locale

export const formateTime = (timestamp) => {
  let t = new Date(timestamp)
  return dayjs(t).format('YYYY-MM-DD')
}
```

线上报错 `e.extend error`

修改为

```
import dayjs from 'dayjs'
import isLeapYear from 'dayjs/plugin/isLeapYear' // import plugin
import 'dayjs/locale/zh-cn' // import locale
dayjs.extend(isLeapYear) // use plugin
dayjs.locale('zh-cn') // use locale

export const formateTime = (timestamp) => {
  let t = new Date(timestamp)
  return dayjs(t).format('YYYY-MM-DD')
}
```