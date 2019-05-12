---
layout: post
title: git删除远程分支和本地分支
date: 2018-11-10 21:07:39
categories: 
  - tools
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

## git删除远程tag和本地tag
> 新建tag

> 上线代码需要打tag，在master分支打tag 打版本v1.0.0.0, 提交版本v1.0.0.0
  ``` 
  1. git tag -a v1.0.0.0 -m '注解打新版本v1.0.0.0'
  2. git push origin v1.0.0.0
  ```
> 删除本地tag `git tag -d v1.0.0.0`

> 删除git远程tag `git push origin --delete tag v1.0.0.0`


