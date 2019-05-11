---
layout: post
title: node(koa2)微信公众号接口认证
date: 2019-01-13 19:13:32
categories: 
  - node
tags:
  - node
  - koa
  - 微信公众号
---

## node(koa2)微信公众号接口认证
使用微信测试号, 花生壳内网穿透, <br>
需要注意 token 两边都是自定义, 需要保持一致

### 代码实现
```js
const Koa = require('koa')
const sha1 = require('sha1')

const app = new Koa()

const config = {
  wechat: {
    appID: '', //填写你自己的appID
    appSecret: '',  //填写你自己的appSecret
    token: ''  //填写你自己的token
  }
}

app.use(async (ctx) => {
  const token = config.wechat.token
  const signature = ctx.request.query.signature
  const nonce = ctx.request.query.nonce
  const timestamp = ctx.request.query.timestamp
  const echostr = ctx.request.query.echostr
  let str = [token, timestamp, nonce].sort().join('')
  const sha = sha1(str)
  ctx.body = sha === signature ? echostr + '' : 'failed'
})

app.listen(8999, () => {
  console.log('node started port 8999')
})
```
### 点击验证,显示配置成功即可 [测试地址](https://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index)
