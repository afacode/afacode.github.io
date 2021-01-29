---
layout: miniapp
title: 微信小程序页面跳转携带大量数据
date: 2020-10-19 17:22:28
tags:
  - wechat
  - wepy
---

## 问题
微信小程序页面跳转需要携带大量数据，使用URL数据拼接有长度限制级数据格式转化潜在问题

## 解决方式
使用wx.navigateTo(Object object)

## 代码示例
使用的wepy1.7X版本
A->B 携带大量数据过去
购物车->支付确认

Page A
```
toPay() {
  if (this.num <= 0) {
    return
  }
  let self = this
  wx.setNavigationBarTitle({
    title: '确认订单'
  })
  wx.navigateTo({
    url: `./pay`,
    events: {},
    success: function (res) {
      res.eventChannel.emit('acceptDataFromOpenerPage', {
        score: self.score,
        num: self.num,
        list: self.list.filter(val => val.choosed == true)
      })
    }
  })
},
```

Page B
```
async onLoad(e) {
  if (e.id) {
    this.score = e.redeem
    this.num = 1
    this.list.push({
      buy_number: 1,
      skuid: e.id,
      redeem: e.redeem,
      skuname: e.skuname,
      img: e.img
    })
  } else {
    let self = this
    const eventChannel = this.$wxpage.getOpenerEventChannel()
    eventChannel.on('acceptDataFromOpenerPage', function (data) {
      self.num = data.num
      self.score = data.score
      self.list = data.list
    })
    this.$apply()
  }
```

## 一些问题
> this.getOpenerEventChannel is not a function

```
wepy1.X

const eventChannel = this.$wxpage.getOpenerEventChannel()

wepy2.X

const eventChannel = this.$wx.getOpenerEventChannel()

taro 待验证
const eventChannel = this.$scope.getOpenerEventChannel()

原生  待验证
试试在json文件中加个"usingComponents": {} ，我一开始是可以用的，后来把这个去掉就报这个错误，然后我加上就又不报错了。。。

https://developers.weixin.qq.com/community/develop/doc/00088eae3c41782a2d59e8c7056800

```
