---
layout: vue3
title: vue3.0 Composition  script-setup
date: 2021-03-20 23:48:12
tags:
  - vue
---

## vue3.0 Composition  script-setup

```
<!-- 标准组件格式 -->
<script lang="ts">
  import { defineComponent } from 'vue'
  export default defineComponent({
    setup() {
      // 要给 template 用的数据需要 return 出来才可以
      return {}
    },
  })
</script>


// script-setup 直接使用
<script setup lang="ts">
  // ...
</script>
```

**components**引用 

- 需要先导入组件

```html
import Header from './Header.vue'
export default defineComponent({
	// 需要通过 components 才能启用子组件
    components: {
        Header,
    }
})
```

- script-setup

```
<script setup lang="ts">
  import Header from './Header.vue'
</script>
```

> 其他的变量、函数，以及 onMounted 等生命周期，还有像 watch 、 computed 等监听/计算功能，都跟原来一样定义就可以了，没有太大的区别



>props && emits

- 标准组件格式

```
父组件
<template>
  <content :name="name" @change-name="changeName" />
</template>

<script lang="ts">
  import { defineComponent, ref } from 'vue'
  import Content from './Content.vue'

  export default defineComponent({
    components: {
      Content,
    },
    setup() {
      const name = ref<string>('afacode')
      const changeName = (val: string): void => {
        name.value = val
      }

      return {
        name,
        changeName,
      }
    },
  })
</script>

子组件
<script lang="ts">
  import { defineComponent } from 'vue'

  export default defineComponent({
    props: ['name'],
    emits: ['changeName'],
    setup(props, { emit }) {
       emit('changeName', '阿发')
    },
  })
</script>

```

- script-setup

```
父组件
<template>
  <Child :name="name" @change-name="changeName" />
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import Child from './Child.vue'
  
  const name = ref<string>('afacode')
  const changeName = (val: string): void => {
  	name.value = val
  }
</script>

子组件
<script setup lang="ts">
import { defineEmit } from 'vue'
// props比较复杂.在后续
defineProps(['name'])
const emit = defineEmit(['chang-name'])
emit('chang-name', '阿发')
</script>
```

### defineProps && defineEmit

> defineProps 是一个方法，内部返回一个对象，也就是挂载到这个组件上的所有 props ，它和普通的 props 用法一样，如果不指定为 prop， 则传下来的属性会被放到 attrs 那边去

```
import { defineProps } from 'vue'
const props = defineProps(['name', 'userInfo', 'tags'])

console.log(props.name)
```

使用 `string[]` 数组作为入参，把 prop 的名称作为数组的 item 传给 defineProps

- 类型检查

使用 JavaScript 原生构造函数进行类型规定

```
defineProps({
  name: String,
  userInfo: Object,
  tags: Array,
})

defineProps({
  name: {
    type: String,
    required: false,
    default: 'afacode',
  },
  userInfo: Object,
  tags: Array,
})
```

使用 TypeScript 的类型注解



和 ref 等 API 的用法一样，defineProps 也是可以使用尖括号 <> 来包裹类型定义，紧跟在 API 后面，另外，由于 defineProps 返回的是一个对象（因为 props 本身是一个对象），所以尖括号里面的类型还要用大括号包裹，通过 `key: value` 的键值对形式表示，如：

```ts
defineProps<{
  name: string // 小写
  phoneNumber: number
  userInfo: object
  tags: string[]
}>()

userInfo 是一个对象，你可以简单的指定为 object，也可以先定义好它对应的类型，再进行指定

interface UserInfo {
  id: number
  age?: number
}

defineProps<{
  name: string // 小写
  phoneNumber: number
  userInfo: UserInfo
  tags: string[]
}>()


设置可选参数的默认值，这个暂时不支持，不能跟 TS 一样指定默认值

如果需要默认指定，并且无需保留响应式的话，我自己测试是可以按照 ES6 的参数默认值方法指定

const { name = 'afacode' } = defineProps<{
  name?: string
  tags: string[]
}>()
```



> defineEmit

```ts
// 获取 emitconst emit = defineEmit(['chang-name'])// 调用 emitemit('chang-name', '阿发')
```

> useContext

```ts
// 标准context 组件的执行上下文setup(props, context) {}// script-setupimport { useContext } from 'vue'const ctx = useContext()// 打印 attrsconsole.log(ctx.attrs)
```



> expose 对外暴露接口|属性 (一般无用)

```
const ctx = useContext()
ctx.expose({  
  someMethod() {    
    console.log('some HelloWorld')  
}})

================================

<AMap @toAddr="getAddr"  ref="hw"/>
const hw = ref(null)hw.value.someMethod()
```
