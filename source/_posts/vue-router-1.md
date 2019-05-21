---
layout: post
title: vue-router 钩子函数（路由拦截）
date: 2018-10-09 22:34:55
categories:
  - js
tags:
  - vue
  - vue router
---
[Vue Router官网](https://router.vuejs.org/zh/)

## vue-router 钩子函数（路由拦截）
有的时候，当路由跳转前或跳转后、进入、离开某一个路由前、后，需要做某些操作，就可以使用路由钩子来监听路由的变化，比如最常见的登录权限验证，当用户满足条件时，才让其进入导航，否则就取消跳转，并跳到登录页面让其登录

### 全局路由钩子
> **beforeEach, afterEach, beforeResolve**

`router.beforeResolve` 全局解析守卫(2.5.0+) 在beforeRouteEnter调用之后调用

```
router.beforeEach((to, from, next) => {
  console.log(to,from)
  if(to.matched.some(res => res.meta.requireAuth)) {
    // 判断是否需要登录权限 && 判断是否登录
  } else {
    next()
  }
})

router.beforeResolve((to, from, next) => {
  next();
})

router.afterEach((to, from) => {
    //会在任意路由跳转后执行
    // 不接受next函数
  console.log('afterEach')
})
```
* to, from, 路由对象指的是平时通过this.$route获取到的路由对象
* next() 
* next(false) url 不跳转
* next  跳转新路由，当前的导航被中断，重新开始一个新的导航
  ```
  我们可以这样跳转：next('path地址')或者next({path:''})或者next({name:''})
  且允许设置诸如 replace: true、name: 'home' 之类的选项
  以及你用在router-link或router.push的对象选项。
  ```

### 单个路由钩子
> 只有`beforeEnter`，在进入前执行，to参数就是当前路由
```
routes: [
  {
    path: '/foo',
    component: Foo,
    beforeEnter: (to, from, next) => {
      // ...
    }
  }
]
```

### 组件内路由钩子
> **beforeRouteEnter, beforeRouteUpdate(2.2), beforeRouteLeave**

> beforeRouteEnter 不能获取组件实例 this，因为当守卫执行前，组件实例被没有被创建出来，剩下两个钩子则可以正常获取组件实例 this

* beforeRouteEnter获取到this实例, 可以通过传一个回调给next来访问组件实例
```
beforeRouteEnter (to, from, next) {
  next(vm => {
    // 通过 `vm` 访问组件实例
  })
}
```

```
  beforeRouteEnter (to, from, next) {
    // 在渲染该组件的对应路由被 confirm 前调用
    // 不！能！获取组件实例 `this`
    // 因为当守卫执行前，组件实例还没被创建
  },
  beforeRouteUpdate (to, from, next) {
    // 在当前路由改变，但是该组件被复用时调用
    // 举例来说，对于一个带有动态参数的路径 /foo/:id，在 /foo/1 和 /foo/2 之间跳转的时候，
    // 由于会渲染同样的 Foo 组件，因此组件实例会被复用。而这个钩子就会在这个情况下被调用。
    // 可以访问组件实例 `this`
  },
  beforeRouteLeave (to, from, next) {
    // 导航离开该组件的对应路由时调用
    // 可以访问组件实例 `this`
  }
```

### 完整的路由导航解析流程(不包括其他生命周期)
* 触发进入其他路由。
* 调用要离开路由的组件守卫beforeRouteLeave
* 调用局前置守卫：beforeEach
* 在重用的组件里调用 beforeRouteUpdate
* 调用路由独享守卫 beforeEnter。
* 解析异步路由组件。
* 在将要进入的路由组件中调用beforeRouteEnter
* 调用全局解析守卫 beforeResolve
* 导航被确认。
* 调用全局后置钩子的 afterEach 钩子。
* 触发DOM更新(mounted)。
* 执行beforeRouteEnter 守卫中传给 next 的回调函数



欢迎访问我的博客 &nbsp;[地址](blog.afacode.top) &nbsp; &nbsp; &nbsp;
https://blog.afacode.top