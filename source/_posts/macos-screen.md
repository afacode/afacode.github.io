---
layout: post
title: 修改Mac系统的默认截图保存路径
date: 2019-05-21 11:43:15
categories:
  - tools
tags:
  - tool
  - macos
---
修改Mac系统的默认截图保存路径
<!-- more -->
1. 打开Terminal
> `defaults write com.apple.screencapture location ~/Pictures/screen` ~/Pictures/screen为你需要图片保存的位置

2. `killall SystemUIServer`

3. `command+shift+3` 测试

