---
layout: post
title: Vue 的 computed 和 watch 的区别
date: 2019-05-09 23:26:15
categories:
  - js
tags:
  - vue
---

Vue 的 computed 和 watch 的区别...
<!-- more -->

## computed
是一个计算属性,类似于过滤器,对绑定到view的数据进行处理
computed比较适合对多个变量或者对象进行处理后返回一个结果值，也就是数多个变量中的某一个值发生了变化则我们监控的这个值也就会发生变化，举例：购物车里面的商品列表和总金额之间的关系，只要商品列表里面的商品数量发生变化，或减少或增多或删除商品，总金额都应该发生变化。这里的这个总金额使用computed属性来进行计算是最好的选择
### get用法
```
data: {
  firstName: 'Foo',
  lastName: 'Bar'
},
computed: {
  fullName: function() {
    return this.firstName + ' ' + this.lastName
  }
}
```
### get, set用法
```
computed: {
  fullName：{
   get(){//回调函数 当需要读取当前属性值是执行，根据相关数据计算并返回当前属性的值
      return this.firstName + ' ' + this.lastName
    },
   set(val){//监视当前属性值的变化，当属性值发生变化时执行，更新相关的属性数据
       //val就是fullName的最新属性值
       console.log(val)
        const names = val.split(' ');
        console.log(names)
        this.firstName = names[0];
        this.lastName = names[1];
   }
}
```

### 缓存
在得知 computed 属性发生变化之后， Vue 内部并不立即去重新计算出新的 computed 属性值，而是仅仅标记为 dirty ，下次访问的时候，再重新计算，然后将计算结果缓存起来。

这样的设计，会避免一些不必要的计算
```
data() {
    return {
        a: 1,
        b: 2
    };
},
computed: {
    c() {
        return this.a + this.b;
    }
},
created() {
    console.log(this.c)
    
    setInterval(() => {
        this.a++
    },1000);
}
```
第一次访问 this.c 的时候，记录了依赖项 a 、 b ，虽然后续通过 setInterval 不停地修改 this.a ，造成 this.c 一直是 dirty 状态，但是由于并没有再访问 this.c ，所以重新计算 this.c 的值是毫无意义的，如果不做无意义的计算反倒会提升一些性能。


## watch
watch是一个观察,监听
### watch用法
```
data: {
    firstName: 'Foo',
    lastName: 'Bar',
    fullName: 'Foo Bar'
  },
  watch: {
     firstName: function (val) {
     this.fullName = val + ' ' + this.lastName
  },
  lastName: function (val) {
     this.fullName = this.firstName + ' ' + val
  }
}
```
### 复杂数据类型
1. 需用深度监听
2. 深度监听虽然可以监听到对象的变化,但是无法监听到具体对象里面那个属性的变化,console.log打印的结果,发现oldVal和newVal值是一样的(原因是它们索引同一个对象/数组。Vue 不会保留修改之前值的副本) [官网介绍](https://cn.vuejs.org/v2/api/#vm-watch)
3. 深度监听对应的函数名必须为`**handler**`,否则无效果,因为watcher里面对应的是对handler的调用
```
watch:{
  secondChange:{
    handler(oldVal,newVal){
      console.log(oldVal)
      console.log(newVal)
    },
    deep:true
  }
}
```
### 监听对象单个属性
1. 可以直接用`对象.属性`的方法拿到属性
2. 用computed作为中间件转化,因为computed可以取到对应的属性值
```
data() {
  return {
    first: {
      second:0
    }
  }
},
// 1.
watch: {
  first.second:function(newVal,oldVal) {
    console.log(newVal,oldVal)
  }
}

// 2. 
computed: {
  secondChange(){
    return this.first.second
  }
},
watch: {
  secondChange(){
    console.log('second属性值变化了')
  }
}
```
## computed和watch的区别

### computed
1. 是计算值，
2. 应用：就是简化tempalte里面计算和处理props或$emit的传值
3. 具有缓存性，页面重新渲染值不变化,计算属性会立即返回之前的计算结果，而不必再次执行函数

### watch 
1. 是观察的动作，
2. 应用：监听props，$emit或本组件的值执行异步操作
3. 无缓存性，页面重新渲染时值不变化也会执行