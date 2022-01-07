---
layout: post
title: git代码分支合并(merge)，tag提交
date: 2017-08-22 07:48:19
categories: 
  - tools
tags:
  - git
  - tool
---
## git代码分支合并，tag提交
* 将自己分支代码合并到测试分支以便测试人员测试 先切换版本到dev分支
  > `git checkout dev`

* 当前dev分支在合并afacode分支的代码,出现冲突，寻找有关开发人员，手动解决冲突
  > `git merge afacode`
* 提交dev分支合并的代码到远程dev分支上
  > `git push origin dev`
* 测试通过，上线代码需要打tag,在master分支打tag 打版本v1.0.0.0
  > `git tag -a 版本号 -m '注解'`
* 提交版本v1.0.0.0到仓库
  > `git push origin v1.0.0.0`

* 更改本地branch 名称 master->main
  > git branch -M main


欢迎访问我的博客 &nbsp;[地址](blog.afacode.top) &nbsp; &nbsp; &nbsp;
https://blog.afacode.top