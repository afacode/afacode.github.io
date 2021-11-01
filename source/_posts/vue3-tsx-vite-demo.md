---
layout: vue3
title: 搭建基于vite支持typescript/jsx的vue3.0环境
date: 2021-06-22 23:22:12
tags:
  - vue
---

## 基础模板

```
yarn create vite vite-tsx-demo --template vue-ts

cd vite-tsx-demo
yarn
yarn dev
```

## 引入sass

```
yarn add -D sass
```

## 引入jsx/tsx

```javascript
yarn add -D @vitejs/plugin-vue-jsx
```

> vite.config.ts

```tsx
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx' // 新增

export default defineConfig({
  plugins: [
    vue(),
    vueJsx() // 新增
  ]
})
```

## 使用

> 简单组件 Demo.tsx

```
export const Demo = () => <h1>123</h1>
```

> 需要修改组件 tree.tsx

```vue
import { defineComponent, PropType, ExtractPropTypes } from 'vue'

interface TreeItem {
  label: string
  children?: TreeData
}
type TreeData = Array<TreeItem>

const treeProps = {
  data: {
    type: Array as PropType<TreeData>,
    default: () => [],
  }
}

type TreeProps = ExtractPropTypes<typeof treeProps>

export default defineComponent({
  name: 'OTree',
  props: treeProps,
  setup(props: TreeProps) {
    return () => {
      return <div class="tree">
        {props.data.map(item => <div>{item.label}</div>)}
      </div>
    }
  }
})
```


