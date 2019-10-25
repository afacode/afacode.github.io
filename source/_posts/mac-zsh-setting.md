---
layout: post
title: mac-zsh-setting
date: 2019-10-16 20:13:56
tags:
---

vim ~/.zshrc  
source ~/.zshrc 


```

修改主体
# ZSH_THEME="ys"
ZSH_THEME="maran"

%T	系统时间（时：分）
%*	系统时间（时：分：秒）
%D	系统日期（年-月-日）
%n	你的用户名
%B - %b	开始到结束使用粗体打印
%U - %u	开始到结束使用下划线打印
%d	你目前的工作目录
%~	你目前的工作目录相对于～的相对路径（可能在某些zsh版本可能造成乱码）
%M	计算机的主机名
%m	计算机的主机名（在第一个句号之前截断）
%l	你当前的tty

// 分解
PROMPT="%{$reset_color%}[%T] 
时间

%{$fg[red]%}%n 
用户

%{$fg[green]%}%1|%~ 
路径

%{$reset_color%}% $ "
单纯字符


# 开启颜色
autoload -U colors && colors
# 配置提示符模式。。 其实配置之前的PS1也是可以的 但是为了尊重说明文档。。。

# PROMPT="%{$fg[red]%}%n%{$reset_color%}%{$fg[green]%}%1|%~ %{$reset_color%}% $"

PROMPT="%{$reset_color%}[%T] %{$fg[red]%}%n %{$fg[green]%}%1|%~ %{$reset_color%}% $ "
#在行末显示上一命令的返回状态
RPROMPT="[%{$fg_bold[yellow]%}%?%{$reset_color%}]"

```
