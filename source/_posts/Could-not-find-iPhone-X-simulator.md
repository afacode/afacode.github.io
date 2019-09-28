---
layout: post
title: Could not find iPhone X simulator
date: 2019-09-23 22:04:48
tags:
  - react native
---

## Could not find iPhone X simulator
> 运行 `react-native run-ios`
详情
```
Found Xcode workspace DbysDriver.xcworkspace

Could not find iPhone X simulator

Error: Could not find iPhone X simulator
    at resolve (/Users/afacode/dbysDrivers/node_modules/react-native/local-cli/runIOS/runIOS.js:149:13)
    at new Promise (<anonymous>)
    at runOnSimulator (/Users/afacode/dbysDrivers/node_modules/react-native/local-cli/runIOS/runIOS.js:134:10)
    at Object.runIOS [as func] (/Users/afacode/dbysDrivers/node_modules/react-native/local-cli/runIOS/runIOS.js:106:12)
    at Promise.resolve.then (/Users/afacode/dbysDrivers/node_modules/react-native/local-cli/cliEntry.js:117:22)

```

> 找到 `/node_modules/react-native/local-cli/runIOS/findMatchingSimulator.js`
```
if (!version.startsWith('iOS') && !version.startsWith('tvOS')) {

替换为

if (!version.startsWith('com.apple.CoreSimulator.SimRuntime.iOS') && !version.startsWith('com.apple.CoreSimulator.SimRuntime.tvOS')) {
```