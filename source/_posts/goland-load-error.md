---
layout: post
title: goland配置goland.vmoptions后不能启动问题解决
date: 2022-04-21 23:55:42
tags:
  - goland
  - go
---

安装的版本有一些残留的配置项

打开 Finder(访达) --> Applications(应用程序) --> Goland(idea) --> Show Package Contents(显示包内容)

Contents-->MacOS-->goland， 双击运行
显示错误 

一些文件路径找不到 jetbrains-agent.jar

`-javaagent:/Applications/GoLand.app/Contents/bin/jetbrains_agent.rar`

打开 bin 下面的 goland.vmoptions 把这行注释或者直接删除

如果还是不行

还有可能有多个goland版本残存

到这个路径 `~/Library/Application Support/JetBrains/` 下 

查看每个版本goland的goland.vmoptions配置 删除