---
layout: post
title: vue组件之间的通信
date: 2019-04-14 22:34:55
categories:
  - js
tags:
  - vue
---

vue组件之间的通信:父-->子、子-->父、非父子
<!-- more -->

[vue组件间通信六种方式（完整版）](https://segmentfault.com/a/1190000019208626?_ea=11267445)转载

## vue组件之间的通信
[vue.js官网prop](https://cn.vuejs.org/v2/guide/components-props.html)
(不谈vuex)
### 父-->子 props
prop是单向绑定
> Prop 类型

- `String`
- `Number`
- `Boolean`
- `Array`
- `Object`
- `Date`
- `Function`
- `Symbol`

> Prop 验证
```
props: {
  // 基础的类型检查 (`null` 和 `undefined` 会通过任何类型验证)
  propA: Number,
  // 多个可能的类型
  propB: [String, Number],
  propC: {
    type: Number,
    required: true,  // 必填
    default: 100 //带有默认值的数字
  },
  // 带有默认值的对象
  propE: {
    type: Object,
    // 对象或数组默认值必须从一个工厂函数获取
    default: function () {
      return { message: 'hello' }
    }
  },
  // 自定义验证函数
  propF: {
    validator: function (value) {
      // 这个值必须匹配下列字符串中的一个
      return ['success', 'warning', 'danger'].indexOf(value) !== -1
    }
  }
}
```


```
**父组件代码**
传递静态或动态
<template>
    <header-box 
      :titleTxt="showTitleTxt" 
      name="My journey with Vue"></header-box>
    <blog-post ></blog-post>
</template>
<script>
    import Header from './header'
    export default {
        name: 'index',
        components: {
            'header-box': Header
        },
        data () {
            return {
                showTitleTxt: '首页'
            }
        }
    }
</script>
```

```
**子组件代码**
<template>
    <header>
        {{thisTitleTxt}}-
        {{name}}
    </header>
</template>
<script>
    export default {
        name: 'header-box',
        props: {
            titleTxt: String,
            name: String
        },
        data () {
            return {
                thisTitleTxt: this.titleTxt
            }
        }
    }
</script>
```

### 子-->父
> 子组件向父组件传递分为两种类型。
1、子组件改变父组件传递的props（你会发现通过props中的Object类型参数传输数据，可以通过子组件改变数据内容。这种方式是可行的，但是不推荐使用，因为官方定义prop是单向绑定）
2、通过$on和$emit

1. 不推荐
> 父组建代码同上

```
**子组件代码**
<template>
    <header @click="changeTitleTxt">
        {{thisTitleTxt.name}}
    </header>
</template>
<script>
    export default {
        name: 'header-box',
        props: {
            titleTxt: Object
        },
        data () {
            return {
                thisTitleTxt: this.titleTxt.name
            }
        },
        metheds: {
            changeTitleTxt () {
                this.titleTxt.name = '切换'
            }
        }
    }
</script>
```
2. *通过$on,$emit* 
```
*通过$on,$emit*
**父组件代码**
<template>
    <div id="counter-event-example">
      <p>{{ total }}</p>
      <button-counter v-on:increment="incrementTotal"></button-counter>
</div>
</template>
<script>
    import ButtonCounter from './buttonCounter'
    export default {
        name: 'index',
        components: {
            'button-conuter': ButtonCounter
        },
        data () {
            return {
                total: 0
            }
        },
        methods: {
            incrementTotal (val) {
                打印值分别是 val
                this.total++
            }
        }
    }
</script>
```
incrementTotal
```
**子组件代码**
<template>
    <button @click="incrementCounter">{{counter}}</button>
</template>
<script>
    export default {
        name: 'button-counter',
        data () {
            return {
                counter: 0
            }
        },
        metheds: {
            incrementCounter () {
                // 可传额外参数 this.$emit('increment',this.counter, true);
                this.$emit('increment')
                this.counter++
            }
        }
    }
</script>
```
### 非父子，比如兄弟组建
> 通过使用一个空的Vue实例作为中央事件总线，（这里也可以使用app实例，而不需要新建一个空Vue实例）

```
**main.js**
let bus = new Vue()
Vue.prototype.bus = bus
或者
**main.js**
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App },
  beforeCreate () {
    Vue.prototype.bus = this
  }
})
```

```
**header组件传递给footer**
<template>
    <header @click="changeTitle">{{title}}</header>
</template>
<script>
export default {
    name: 'header',
    data () {
        return {
            title: '头部'
        }
    },
    methods: {
        changeTitle () {
            this.bus.$emit('toChangeTitle','首页')
        }
    }
}
</script>
```


```
**footer组件**
<template>
    <footer>{{txt}}</footer>
</template>
<script>
export default {
    name: 'footer',
    mounted () {
        this.bus.$on('toChangeTitle', function (title) {
            console.log(title)
        })
    },
    data () {
        return {
            txt: '尾部'
        }
    }
}
```


欢迎访问我的博客 &nbsp;[地址](blog.afacode.top) &nbsp; &nbsp; &nbsp;
https://blog.afacode.top

