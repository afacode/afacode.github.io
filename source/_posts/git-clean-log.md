---
layout: post
title: git 清空所有(历史)commit记录
date: 2017-05-11 22:34:45
categories: 
  - tools
tags:
  - git
  - tool
---
## git 清空所有(历史)commit记录
例如: 将代码提交到git仓库，将一些敏感信息提交，所以需要删除提交记录以彻底清除提交信息，以得到一个干净的仓库且代码不变

* > `git checkout --orphan tmp_branch` tmp_branch 临时的分支
* > `git add -A` 或 `git add .` 
* > `git commit -m "删除git历史，整理第一次提交"`
* > `git branch -D master` 删除分支
* > `git branch -m master` 重命名tmp_branch为master
* > `git push -f origin master` 强制推送到远程


欢迎访问我的博客 &nbsp;[地址](blog.afacode.top) &nbsp; &nbsp; &nbsp;
https://blog.afacode.top