---
layout: post
title: oh-my-zsh更新出错
date: 2019-12-16 08:50:39
tags:
---

## 报错

```
[Oh My Zsh] Would you like to update? [Y/n]: y
Updating Oh My Zsh
error: cannot pull with rebase: You have unstaged changes.
error: please commit or stash them.
There was an error updating. Try again later?
```

## 原因

我的主题更改没有提交

## 解决

```
1. cd ~/.oh-my-zsh

2. git status

On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   themes/ys.zsh-theme

no changes added to commit (use "git add" and/or "git commit -a")

3. git add .

git commit -m "主题更改"

4. git stash

5. upgrade_oh_my_zsh

6. git stash pop

```
