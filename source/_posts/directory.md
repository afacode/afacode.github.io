---
layout: vscode
title: vscode Could not create temporary directory 权限被拒绝
date: 2019-11-15 09:03:15
tags:
  - vscode
---

## Mac VSCode 更新失败解决方法
`Could not create temporary directory: 权限被拒绝`

## 解决方式
`sudo chown $USER ~/Library/Caches/com.microsoft.VSCode.ShipIt/`

> 重启之后，再更新
