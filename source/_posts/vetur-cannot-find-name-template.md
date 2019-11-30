---
layout: vetur
title: (vetur) cannot find name template
date: 2019-11-30 11:11:14
tags:
  - vscode
---

## 环境

```
vscode

Version: 1.40.2
Commit: f359dd69833dd8800b54d458f6d37ab7c78df520
Date: 2019-11-25T14:52:45.129Z
Electron: 6.1.5
Chrome: 76.0.3809.146
Node.js: 12.4.0
V8: 7.6.303.31-electron.0
OS: Darwin x64 18.2.0


vetur: 0.22.6

language: wpy(wepy小程序)
```

## 报错

```
...
vetur: cannot find name 'template'
...

```

![报错](http://imgs.afacode.top/WechatIMG22-2019113011147.png)

## 问题

```
script 未指定lang类型
```

![问题](http://imgs.afacode.top/WechatIMG23-20191130111418.png)

## 解决

```
...
<script lang="js">
...
</script>
...
```

![解决](http://imgs.afacode.top/WechatIMG24-20191130111425.png)
