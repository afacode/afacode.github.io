---
layout: react-native
title: react-native-splash-screen 在ios使用
date: 2019-10-26 15:48:24
tags:
  - react-native
---
## react-native-splash-screen 在ios中的使用
## 环境
```
XCode Version 10.2 (10E125)
"react": "16.8.6",
"react-native": "0.60.5",
"react-native-splash-screen": "^3.2.0",
```
## 安装
```
yarn add react-native-splash-screen
cd ios 
pod install
cd ..
```
## 使用
```
import SplashScreen from 'react-native-splash-screen'
componentDidMount() {
  SplashScreen.hide()
}
```
## 配置
添加启动图片
![启动屏1-2019103015566](http://imgs.afacode.top/启动屏1-2019103015566.png)
启用自定义启动图
![启动屏2-20191030155626](http://imgs.afacode.top/启动屏2-20191030155626.png)
![启动屏0-20191030155636](http://imgs.afacode.top/启动屏-20191030155636.png)

## [参考1](https://www.jianshu.com/p/bf907cdbcfad?_wv=1031) && [参考2](https://www.jianshu.com/p/12813a59f993)