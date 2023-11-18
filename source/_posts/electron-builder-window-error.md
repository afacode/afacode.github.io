---
layout: post
title: electron-builder在window下打包报错
date: 2023-11-04 22:20:33
tags:
  - electron
  - electron-builder
---

### electron-builder在window下打包报错

报错详情

```
\.pnpm\app-builder-lib@24.6.4\node_modules\app-builder-lib\src\asar\asarFileChecker.ts:7
    return new Error(`${messagePrefix} "${relativeFile}" in the "${asarFile}" ${text}`)
           ^
Error: Application entry file "background.js" in the "****\release\win-unpacked\resources\app.asar" does not exist.
```

解决方式: `electron-builder`增加win字段配置

```json
打包配置
config: {
  # 新增
  win: {
  	artifactName: '${productName}-${platform}-${arch}-${version}.${ext}',
  }
}
```