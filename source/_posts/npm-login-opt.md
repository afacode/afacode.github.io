---
layout: post
title: Enter one-time password from your authenticator app 解决
date: 2022-01-2 22:28:15
tags:
  - npm
---

## Enter one-time password from your authenticator app 解决

npm 安全规则

npm login 登录需要 OTP authenticator

[操作文档](https://docs.npmjs.com/configuring-two-factor-authentication)

```
登录  npmjs.com 后在我的 account 

enable 2FA

选择

Two-Factor Authentication

扫描 二维码 使用 身份验证器 

我是用 识别二维码 https://chrome.google.com/webstore/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai/related?hl=zh-CN

获得6位code验证
填写到下面

通过后 会有 5个 字符串 保存好

在以后需要 otp 的地方使用

```
[身份验证器 ](https://chrome.google.com/webstore/detail/authenticator/bhghoamapcdpbohphigoooaddinpkbai/related?hl=zh-CN)

### 发布 npm 包流程(捎带)
```
npm login

需要 one-time password
按照上面获取 otp

npm publish
再次输入 otp

一般就行
```
> 发布带@开头公共包
> `npm publish --access public`

#### npm 源问题
```
config set registry https://registry.npmjs.org

或者发布登录用

npm login  --registry https://registry.npmjs.org/

npm publish  --registry https://registry.npmjs.org/

```