---
layout: post
title: vue2-ts支持jest测试
date: 2021-06-29 23:34:55
categories:
  - js
tags:
  - vue
  - jest
---

接上一篇文章
> 需要依赖的库
```js
jest  
@types/jest  
babel-jest

// 支持ES6
@babel/preset-env

ts支持
ts-jest
@babel/preset-typescript

vue3支持 vue-jest 版本问题
@vue/vue3-jest  // 注意对应版本 https://github.com/vuejs/vue-jest
@vue/test-utils

特殊 需要next
@vue/test-utils@next

我的版本
	"@babel/preset-env": "^7.16.7",
    "@babel/preset-typescript": "^7.16.7",
    "@types/jest": "^27.4.0",
    "@vue/test-utils": "^2.0.0-rc.18",
    "@vue/vue3-jest": "^27.0.0-alpha.4",
    "babel-jest": "^27.4.5",
    "jest": "^27.4.5",
    "ts-jest": "^27.1.2",
```

> script `"test:unit": "jest"`

[https://github.com/vuejs/vue-jest](https://github.com/vuejs/vue-jest)

| Vue version | Jest Version      | Package          |
| ----------- | ----------------- | ---------------- |
| Vue 2       | Jest 26 and below | `vue-jest@4`     |
| Vue 3       | Jest 26 and below | `vue-jest@5`     |
| Vue 2       | Jest 27           | `@vue/vue2-jest` |
| Vue 3       | Jest 27           | `@vue/vue3-jest` |

```js
babel.config.js

module.exports = {
  presets: [
    ["@babel/preset-env", { "targets": { "node": "current" } }],
    "@babel/preset-typescript",
  ]
}
```

```js
jest.config.js
对不同文件进行处理

module.exports = {
  transform: {
    '^.+\\.js$': 'babel-jest',
    '^.+\\.vue$': '@vue/vue3-jest',
    "^.+\\.(t|j)sx?$": "ts-jest"
  }
}
```

```js
tsconfig.json
新增 jest
"types": ["vite/client", "jest"]

新增 tests
"include": ["src/**/*.ts", "src/**/*.d.ts", "src/**/*.tsx", "src/**/*.vue", "tests"],
```



测试 tests/index.spec.js

```js
import { add } from './index'
import About from '../src/views/About/index.vue'
test('1+1=2', () => {
  console.log(add()) // 普通函数
  console.log(About) // 普通组件
  expect(1 + 1).toBe(2)
})
```

