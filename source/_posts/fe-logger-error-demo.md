---
layout: post
title: 前端埋点及js错误上报demo
date: 2023-05-28 22:19:30
tags:
  - javscript
---

## 前端埋点及js错误上报demo

`后期发布npm包`继续完善 (如添加键盘事件，当前运行环境，数据报警，通知等，统计页面点击热点生成热力图。。。)

>主要技术点

- 路由导航history模式 重写pushState， replaceState
- js错误上报主要监听 `window.addEventListener('error')`, `promise`使用`window.addEventListener('unhandledrejection')`监听
- 数据上报使用`navigator.sendBeacon`, 优势[sendBeacon](https://developer.mozilla.org/zh-CN/docs/Web/API/Navigator/sendBeacon)比[`XMLHttpRequest`](https://developer.mozilla.org/zh-CN/docs/Web/API/XMLHttpRequest)的优势
- DOM事件上报

> 使用

```js
new LoggerAndError({
  ...
})

可选参数
export interface DefaultOptions {
  uuid: string | undefined,
  postUrl: string | undefined,
  historyRouter: boolean,
  hashRouter: boolean,
  domLogger: boolean,
  jsError: boolean,
  sdkVersion: string | number,
  extra: Record<string, any> | undefined,
}                      
```

> 目录结构

```
dist // 打包结果
	index.cjs.js
	index.d.ts
	index.esm.js
	index.js
src
	core
		index.ts
	types
		index.ts
rollup.config.js
package.json
tsconfig.json
```

> rollup配置

```js
import path from 'path'
import ts from 'rollup-plugin-typescript2'
import dts from 'rollup-plugin-dts'

export default [{
  input: './src/core/index.ts',
  output: [
    // esModule  import export
    {
      file: path.resolve(__dirname, './dist/index.esm.js'),
      format: 'es'
    },
    // commonjs  require exports
    {
      file: path.resolve(__dirname, './dist/index.cjs.js'),
      format: 'cjs'
    },
    // UMD => AMD CMD global
    {
      input: './src/core/index.ts',
      file: path.resolve(__dirname, './dist/index.js'),
      format: 'umd',
      name: 'logger'
    },
  ],
  plugins: [
    ts()
  ]
}, {
  input: './src/core/index.ts',
  output: {
    file: path.resolve(__dirname, './dist/index.d.ts'),
    format: 'es'
  },
  plugins: [
    dts()
  ]
}];
```

> src/core/index.ts

```typescript
import { Options, DefaultOptions, LoggerAndErrorConfig, PostLoggerAndErrorData } from "../types"

const MouseEventList: string[] = ['click', 'dblclick', 'mousedown', 'mouseup', 'mouseenter', 'mouseout', 'mouseenter'];
export default class LoggerAndError {
  public opt: Options
  private version: string;
  public constructor(options: Options) {
    this.opt = Object.assign(this.init(), options)
    this.installEvent()
  }

  private init(): DefaultOptions {
    this.version = LoggerAndErrorConfig.version
    // 重写 history

    window.history['pushState'] = this.createHistoryEvent('pushState')
    window.history['replaceState'] = this.createHistoryEvent('replaceState')

    return <DefaultOptions>{
      sdkVersion: this.version,
      historyRouter: false,
      hashRouter: false,
      jsError: false,
      domLogger: false,
    }
  }

  private createHistoryEvent = <T extends keyof History>(type: T): () => any => {
    const original = history[type]

    return function(this: any) {
      var e = new Event(type)
      window.dispatchEvent(e)
      const res = original.apply(this, arguments)
      return res
    }
  }

  private installEvent() {
    if (this.opt.historyRouter) {
      this.captureEvents(['pushState', 'replaceState', 'popstate'], 'history-pv')
    }
    if (this.opt.hashRouter) {
      this.captureEvents(['hashchange'], 'hash-pv')
    }
    if (this.opt.domLogger) {
      this.domEvents()
    }
    if (this.opt.jsError) {
      this.jsError()
    }
  }

  private captureEvents<T>(MouseEventList: string[], targetKey: string, data?: T) {
    MouseEventList.forEach(event => {
      window.addEventListener(event, () => {
        this.sendLoggerAndError({event, targetKey, data})
      })
    })
  }

  private domEvents() {
    MouseEventList.forEach(event => {
      window.addEventListener(event, (e) => {
        const target = e.target as HTMLElement
        const targetKey = target.getAttribute('target-key')
        if (targetKey) {
          this.sendLoggerAndError({
            targetKey,
            event,
          })
        }
      })
    })
  }

  public setUuid<T extends DefaultOptions['uuid']>(uuid: T) {
    this.opt.uuid = uuid
  }

  public seExtra<T extends DefaultOptions['extra']>(extra: T) {
    this.opt.extra = extra
  }

  private jsError() {
    this.errorEvent()
    this.promiseReject()
  }

  private errorEvent() {
    window.addEventListener('error', (event) => {
      this.sendLoggerAndError({
        targetKey: 'message',
        event: 'error',
        message: event.message,
        detail: event
      })
    })
  }

  private promiseReject() {
    window.addEventListener('unhandledrejection', (event) => {
      event.promise.catch(error => {
        this.sendLoggerAndError({
          targetKey: 'reject',
          event: 'promise',
          message: error
        })
      })
    })
  }

  public sendLoggerAndError<T extends PostLoggerAndErrorData>(data: T) {
    this.postData(data)
  }

  private postData<T>(data: T) {
    const params = Object.assign(this.opt, data, {time: new Date().getTime})
    let headers = {
      type: 'application/x-www-form-urlencoded'
    }
    let blob = new Blob([JSON.stringify(params)], headers)

    navigator.sendBeacon(this.opt.postUrl, blob)
  }
}

```

> package.json

```json
{
  "main": "dist/index.cjs.js",
  "module": "dist/index.esm.js",
  "browser": "dist/index.js",
  "scripts": {
    "build": "rollup -c",
  },
  "devDependencies": {
    "rollup": "^2.76.0",
    "rollup-plugin-dts": "^4.2.2",
    "rollup-plugin-typescript2": "^0.32.1",
    "typescript": "^4.7.4"
  }
}
```