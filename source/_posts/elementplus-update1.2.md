---
layout: post
title: element-plus 更新 1.2.0版本后 @element-plus/icons 的使用
date: 2021-12-10 22:07:39
tags:
  - vue
---

### element-plus 更新 1.2.0版本后 @element-plus/icons 的使用

> element-plus1.2.0 组件内的 Font Icon 向 SVG Icon 迁移，正式版本Font Icon将被弃用
> @element-plus/icons 的使用
> element-plus 升级后 需要对应的更改

> 安装|更新

```
yarn add element-plus @element-plus/icons-vue
```

> plugins/elementPlus.ts

```js
import ElementPlus from 'element-plus'
import locale from 'element-plus/lib/locale/lang/zh-cn.js'
// 样式修改
// import 'element-plus/lib/theme-chalk/index.css'
import 'element-plus/dist/index.css'
import 'dayjs/locale/zh-cn'
import * as icons from '@element-plus/icons-vue'
// 组件
export default function (app) {
  app.use(ElementPlus, { locale })
}
// ICON
export function installIcon (app) {
  Object.keys(icons).forEach(key => {
    app.component(key, icons[key])
  })
}

```

> main.ts

```js
import ElementPlus, {installIcon} from './plugins/elementPlus'

const app = createApp(App)

// 增加
installIcon(app)

```

> ICON的使用

```js
<el-icon>
   <add-location />
 </el-icon>
```
