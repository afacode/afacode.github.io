---
layout: post
title: vuex和redux记录
date: 2019-05-18 17:57:25
categories:
  - js
tags:
  - vuex
  - redux
---

vuex和redux的用法，区别
<!-- more -->
## 状态管理
状态管理库，无论是Redux，还是Mobx，vuex这些，其本质都是为了解决状态管理混乱，无法有效同步的问题，它们都支持：

* 统一维护管理应用状态；
* 某一状态只有一个可信数据来源（通常命名为store，指状态容器）；
* 操作更新状态方式统一，并且可控（通常以action方式提供更新状态的途径）；
react 
* 支持将store与React组件连接，如react-redux，mobx-react；通常使用状态管理库后，我们将React组件从业务上划分为两类：
  * 容器组件（Container Components）：负责处理具体业务和状态数据，将业务或状态处理函数传入展示型组件；
  * 展示型组件（Presentation Components）：负责展示视图，视图交互回调内调用传入的处理函数；

## vuex

![vuex@2x-20195181406](http://imgs.afacode.top/vuex@2x-20195181406.png)
1. vuex 通过 commit 提交 mutations 修改 state. 只能进行**同步操作**，且方法名只能全局唯一
2. vuex 通过 dispatch 触发 actions, 然后由 commit 来触发 mutation 的调用, 间接更新 state。包含**同步/异步**操作，支持多个同名方法，按照注册的顺序依次触发
3. vuex 的 getters 读取 state 在操作，同 computed, **缓存**，只有相关 state 改变才会更新，**不会改变 state**

> State => (commit) => mutation=> state <br> 
​> State => (getter) => tmp(state) <br> 
​> State => (dispatch) => action => (commit) => state <br> 
### vuex/localStorage
vuex 是 vue 的状态管理器，存储的数据是响应式的。但是并不会保存起来，刷新之后就回到了初始状态，具体做法应该在vuex里数据改变的时候把数据拷贝一份保存到localStorage里面，刷新之后，如果localStorage里有保存的数据，取出来再替换store里的state
```
let defaultCity = "上海"
try {   // 用户关闭了本地存储功能，此时在外层加个try...catch
  if (!defaultCity){
    defaultCity = JSON.parse(window.localStorage.getItem('defaultCity'))
  }
}catch(e){}
export default new Vuex.Store({
  state: {
    city: defaultCity
  },
  mutations: {
    changeCity(state, city) {
      state.city = city
      try {
      window.localStorage.setItem('defaultCity', JSON.stringify(state.city));
      // 数据改变的时候把数据拷贝一份保存到localStorage里面
      } catch (e) {}
    }
  }
})

```

由于vuex里，我们保存的状态，都是数组，而localStorage只支持字符串，所以需要用JSON转换
```
JSON.stringify(state.subscribeList);   // array -> string 序列化
JSON.parse(window.localStorage.getItem("subscribeList"));    // string -> array 反序列号
```

## redux
Redux 和 React 之间没有关系。Redux 支持 React、Angular、Ember、jQuery 甚至纯 JavaScript。
* redux
  * 有Actions、Reducer、Store这三层
  * 通过createStore(reducer)得到store，换名话说store包含了reducer的逻辑实现
  * 通过store.dispath(action)去调用reducer，从而改变state
  * 通过store.getState()获取在reducer改变的state
* react-redux
  * react-redux作用就是本来没有关系的 Redux 和 React 关联在一起
  * 它有组件Provier和方法connect
  * connect将 React 的state和 Redux 的actions合并成一个对象props，再将这个对象和component生成一个新的组件
  * Provider负责将 Redux 的store当属性传connect的新组件，从面将 React 和 Redux 关联到了一起
  * 当新组件调用action的时候，Provider.store就会映射调用reducer从而改变state，当state发生改变，就会触发新组件的render，重新更新组件
* redux-thunk
  * `redux-thunk`异步
> 目录：
* src/index.js
* src/store/store.js
* src/store/actions/...
* src/store/reducers/...
* src/store/reducers/index.js
> src/index.js 引入store

```
import { Provider } from 'react-redux'
import store from './store/store'
ReactDOM.render(
  <Provider store={store}>
    <Demo />
  </Provider>, 
  document.getElementById('root')
)
```
> src/store/store.js 统一一个store

```
import  { createStore, applyMiddleware } from 'redux'
import thunk from 'redux-thunk'
import { composeWithDevTools } from 'redux-devtools-extension'
import rootReducer from './reducers'

let store = createStore(
  rootReducer, 
  composeWithDevTools(applyMiddleware(thunk))
  )
// 第二个参数为thunk中间件 用来处理函数类型的action
export default store
```
> src/store/reducers/index.js 合并多个reducer

```
import { combineReducers } from 'redux'
import productsReducer from './products-reducer'
import cartReducer from './cart-reducer'
import asyncNumReducer from './async-num-reducer'

const allReducers = {
  products: productsReducer,
  shoppingCart: cartReducer,
  asyncCount: asyncNumReducer
}
// 多个reducer合并成一个rootReducer
const rootReducer = combineReducers(allReducers)

export default rootReducer
```
> 在业务组建使用 使用`this.props.count` 读取store状态，`this.props.plus()`使用reducer

```
import { connect } from 'react-redux'
import { plus } from '../store/actions/async-num-actions'
import { addToCart } from '../store/actions/cart-actions'
const mapStateToProps = (state) => {
  return {
    count: state.asyncCount.count,
    cart: state.shoppingCart.cart
  }
}
const mapDispatchToProps = {
  plus, addToCart
}

Demo = connect(mapStateToProps, mapDispatchToProps)(Demo)
export default Demo
```



## 异同
1. 都是单向数据
2. action都可异步
3. redux是只能通过dispatch触发action，从而用reducer更新state, 类似vuex的commit

---
待更新
