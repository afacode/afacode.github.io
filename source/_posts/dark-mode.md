---
layout: html
title: 一行代码支持暗黑模式
date: 2020-10-08 16:33:29
tags:
  - css
---

```
html[theme='dark-mode'] {
  filter: invert(1) hue-rotate(180deg);
}
```
filter 这个 CSS 属性将模糊或颜色偏移等图形效果应用于某个元素。这些滤镜通常用于调整图像、背景和边框的渲染。

参考：MDN Web 文档

https://developer.mozilla.org/en-US/docs/Web/CSS/filter

对于这种黑暗模式，我们将使用两个滤镜，分别是 invert 和 hue-rotate

invert 滤镜用来反转应用程序的配色方案。也就是说黑色会变成白色，白色变成黑色，所有颜色以此类推。invert() 函数作为 filter 属性的值将取 0 到 1 之间的数字，或 0％到 100％的百分比。

hue-rotate 滤镜可以帮助我们处理所有非黑色和白色的颜色。它能将色相旋转 180 度，让我们可以确保应用程序的配色方案不变，而只是减弱其颜色。

使用这种方法的唯一陷阱是，它还将反转应用程序中的所有图像、图片和视频。因此，我们将向所有图像添加相同的规则以反转效果。

```
html[theme='dark-mode'] img,
picture,
video{
    filter: invert(1) hue-rotate(180deg);
}
```
并且我们要添加一个类，以反转特定标签内的效果。

```
.invert {
    filter: invert(1) hue-rotate(180deg);
}
```
