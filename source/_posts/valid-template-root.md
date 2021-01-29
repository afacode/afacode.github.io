---
layout: post
title: The template root requires exactly one element.eslint-plugin-vue
date: 2020-11-16 15:01:17
tags:
---

## vue3 template下多个根节点代码提示警告
> The template root requires exactly one element.eslint-plugin-vue
```
[vue/valid-template-root]
The template root requires exactly one element.eslint-plugin-vue
```
![](https://www.otimes.com/group1/M00/00/4E/cjez0F-yJjWASijOAAB4ANqhW84021.png)


## 解决方式
项目根路径新建, 重新打开项目 cmd+p: >reload
.vscode/setting.json
```
{
  "vetur.validation.template": false
}
```
![](https://www.otimes.com/group1/M00/00/4E/cjez0F-yJjWAbYlgAAAfqH-Af4E411.png)
