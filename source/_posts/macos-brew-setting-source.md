---
layout: post
title: MacOS HomeBrew更新慢的问题(替换国内源)
date: 2019-11-02 17:00:32
tags:
  - macos
---
## 替换brew.git
```
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
```

## 换homebrew-core.git
```
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
```

## 更新
> brew update

## 国内源
```
清华大学源：
https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

中科大源：
https://mirrors.ustc.edu.cn/brew.git
https://mirrors.ustc.edu.cn/homebrew-core.git

```
