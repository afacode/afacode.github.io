---
layout: post
title: fatal 'XXX' is not a commit and a branch 'XXX' cannot be created from it
date: 2022-05-16 23:21:45
categories: 
  - tools
tags:
  - git
  - tool
---

在git新建分支并拉去上线分支代码时，出现报错 fatal: 'XXX' is not a commit and a branch 'XXX' cannot be created from it

原因是因为未将本地代码更行，检测不到git新建的线上的分支

解决方式：
```bash

    git branch -r
    
    git pull 
    
    git checkout -b 分支名 origin/分支名
```