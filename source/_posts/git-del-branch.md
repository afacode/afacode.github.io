---
layout: post
title: git删除远程分支和本地分支
date: 2018-11-10 21:07:39
categories: 
  - tools
  - git 
tags:
  - tool
  - git
---

## git删除远程分支和本地分支
当我们集体进行项目时，将自定义分支push到主分支master之后，如何删除远程的自定义分支呢
> 1. `git branch -a` 查看所有分支
`remote/origin/master`表示的是远程分支
> 2. 删除远程分支   
`git push origin --delete demo`   可以删除远程分支demo
> 3. 删除本地分支
> - 3.1 切换到master分支 `git checkout  master`
> - 3.2 `git branch -D demo` 可以删除本地demo分支（在主分支中）


