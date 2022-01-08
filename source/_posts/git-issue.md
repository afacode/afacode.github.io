---
layout: post
title: git常见操作
date: 2021-08-03 23:06:39
tags:
  - tool
  - git
---

- git remote 远程仓库关联 更改远程仓库地址
```
远程仓库关联
git remote add origin git@****.git

更改远程仓库地址
git remote set-url gitee git@****.git

关联多个远程仓库
git remote add 新名字 git@****.git

git remote -v

远程分支信息
git remote show git@****.git
git ls-remote git@****.git
```

- 撤销
```

```
- git 配置
```
git config --list --show-origin

git config --list

全局配置用户信息
git config --global user.name ****
git config --global user.emial ****@**.com

// 查看特定一项
git config user.name
```
- git branch 分支
```
新建 test
git branch test

切换
git checkout test

新建并切换到 issus
git checkout -b issus

删除分支
git branch -d issue54

删除远程分支
git push origin --delete issue55

查看分支
git branch 
git branch -a
分支的最后一次提交
git branch -v 

已经合并了的分支 未合并分支
git branch --merged
git branch --no-merged


重命名分支 将 test->dev  在test分支下
git branch -m dev
```
- git merge 合并
```
将 issue52 分支合并到 test
在test分支下执行
git merge issue52
```
- git tag
```
git tag -a v0.0.1 -m 'add tag v0.0.1'

git push origin v0.0.1

删除tag
git tag -d v0.0.1
线上
git push origin --delete tag v0.0.1

git tag
```

- git fetch 与 git pull 区别
```
git fetch 将远程代码 拉去 并不会自动 合并代码

git pull 是  git fetch && git merge 又可以会合并失败，需要手动处理

```
- git强制推送远程
`git push -f origin issue44`
- git 清空历史 commit
```
git checkout --orphan tmp

git add .   或者 git add -A

git commit -m "reset init"

git branch -D master

git branch -m master
```
- 清除要忽略文件的提交记录
```
删除暂存区的文件
本地文件也会删除
git rm filename
git commit -m 'del'

git push origin master


提交删除记录
git add -A
git commit -m 'del'

git push origin master

```
- 将push到远程的文件删除，但本地不删除 (如环境配置文件)
```
git rm -r --cache .dev // .dev 文件
git comit -m "del origin config"
git push origin master
```
- 代码回滚
```
git log

git reset --hard commitid
```
- rebase 与 merge区别
```
效果相同，历史记录不同
merge会有三方合并记录
rebase没有， 相当于融合


rebase提供解决冲突的方法：
1.跟merge一样解决，然后git add 标示已解决冲突
2.git rebase --continue 标示继续变基，解决完成
3.如果不想要这次rabase，可以使用git rebase --abort 放弃这次变基操作，回到rebase之前
```
- 暂停当前分支工作，去完成其他工作
```
git stash save "暂停保存"  
git stash save -m "暂停保存"  
git stash save -u "暂停保存"  
git stash save -a "暂停保存"  

-a表示all，是不仅仅把新加入的代码文件放入暂存区，还会把用.gitignore忽略的文件放入暂存区。如果想不影响被忽略的文件，那就要用-u，表示untracked files

git stash list

恢复的是最近的一次改动
git stash pop

git stash pop stash@{id}  // 0 1 2  

删除
git stash drop stash@{id}

所有清除
git  stash clear
```
- git commit 撤销 commit
```
写的代码仍然保留，撤销commit，并且撤销git add
默认参数
git reset --mixed HEAD^ ====== git reset HEAD^


仅仅是撤回commit操作，代码仍然保留 不撤销git add
git reset --soft HEAD^

撤销commit，撤销git add 
注意完成这个操作后，就恢复到了上一次的commit状态 自己写的代码没了
git reset --hard HEAD^
```
- 刚才提交完commit,发现commit写的有问题，修改本次commit 
`git commit -amend`
-  或者刚更改的文件又需要小的修改而不增加多余的commit数量
```
git add .
git commit -amend
```