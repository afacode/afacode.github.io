---
layout: post
title: electron启动报`Electron failed to install correctly,`
date: 2023-11-03 21:19:30
tags:
  - electron
---

### electron启动报`Electron failed to install correctly,`

报错详情

```shell
.pnpm\electron@27.1.0\node_modules\electron\index.js:17
    throw new Error('Electron failed to install correctly, please delete node_modules/electron and try installing again');
```

解决方式

`node node_modules/electron/install.js`
