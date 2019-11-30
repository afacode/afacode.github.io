---
layout: target
title: target与currentTarget的区别
date: 2019-11-25 19:58:25
tags:
---

## [转载：三言两语之js事件、事件流以及target、currentTarget、this那些事](https://www.cnblogs.com/54td/p/5936816.html)

## 异同
1. target:触发事件的某个具体对象，只会出现在事件流的目标阶段（谁触发谁命中，所以肯定是目标阶段）
2. currentTarget:绑定事件的对象，恒等于this，可能出现在事件流的任意一个阶段中
3. 通常情况下terget和currentTarget是一致的，我们只要使用target即可，但有一种情况必须区分这三者的关系，那就是在父子嵌套的关系中，父元素绑定了事件，单击了子元素（根据事件流，在不阻止事件流的前提下他会传递至父元素，导致父元素的事件处理函数执行），这时候currentTarget指向的是父元素，因为他是绑定事件的对象，而target指向了子元素，因为他是触发事件的那个具体对象



