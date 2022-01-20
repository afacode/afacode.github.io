---
layout: post
title: vue3.0使用vue-i18n国际化支持简单使用
date: 2021-09-19 23:34:55
categories:
  - js
tags:
  - vue
  - vue-i18n
---

## 安装
[官网](https://vue-i18n.intlify.dev/)
```js
yarn add vue-i18n@next   版本 9.0
```

## 使用
> src/main.ts
```js

import { i18n } from './local/index'

const app = createApp(App)

app.use(i18n)
```
>src/local/index.ts
```js
import { createI18n } from 'vue-i18n'

import messages from './language'

export const i18n = createI18n({
 locale: 'ja',
 fallbackLocale: 'zh',
 globalInjection: true,
 legacy: false,
 messages
})
```
>src/local/language/index.ts
```
import en from './en'
import zh from './zh'
import ja from './ja'
....

可以有更多的语言文件

export default {
 en,
 zh,
 ja,
 ...
}
```

> src/local/language/ja.ts     demo其他语言类似
```js
export default {
 message: {
   word: 'こんにちは、世界',
 },
}
```
> src/local/language/en.ts 
```js
export default {
 message: {
   word: 'hello world',
 },
}

```
> src/local/language/zh.ts 
```js
export default {
 message: {
   word: '你好世界',
 },
}
```
### 在template及 script 中使用
> 切换语言
```js
template

{{$t("message.word")}}
<el-button @click="change('zh')">中文</el-button>
<el-button @click="change('en')">英文</el-button>
<el-button @click="change('ja')">日文</el-button>


更改 语言
script

import { useI18n } from 'vue-i18n'
import { getCurrentInstance } from 'vue'
setup() {
	const { proxy } = getCurrentInstance()
	const { locale } = useI18n()

	const change = (lang) => {
		locale.value = lang
		// 或者  二选一
		proxy.$i18n.locale = lang
	}
	return {change}
}

```
