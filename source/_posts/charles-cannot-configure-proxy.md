---
layout: charles
title: Charles cannot configure your proxy settings
date: 2020-06-30 15:24:36
tags:
---

## Charles cannot configure your proxy settings
```
Charles cannot configure your proxy settings while it is on a read-only volume
```
## 版本
macOS catalina 10.15.4 (19E287)

charles v4.2.8 



## 解决方法 
```
sudo chown -R root "/Applications/Charles.app/Contents/Resources"
sudo chmod -R u+s "/Applications/Charles.app/Contents/Resources"
```

## 参考
[git issues](https://github.com/autopkg/arubdesu-recipes/issues/26)

[git issues](https://github.com/autopkg/arubdesu-recipes/issues/94)

[stackoverflow](https://stackoverflow.com/questions/57613669/issue-configure-charles-proxy-on-catalina)