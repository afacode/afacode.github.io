---
layout: post
title: 抽象语法树AST
date: 2020-04-14 21:11:21
tags:
  - AST
---

[原文-【你应该了解的】抽象语法树AST](https://juejin.im/post/5e942d926fb9a03c7d3d07a4)
作者：[skFeTeam](https://skfeteam.github.io/)
链接：https://juejin.im/post/5e942d926fb9a03c7d3d07a4

## 什么是抽象语法树
- AST（Abstract Syntax Tree）是源代码的抽象语法结构树状表现形式。下面这张图示意了一段JavaScript代码的抽象语法树的表现形式。
## 抽象语法树的作用
- IDE的错误提示、代码格式化、代码高亮、代码自动补全等
- JSLint、JSHint、ESLint对代码错误或风格的检查等
- webpack、rollup进行代码打包等
- Babel 转换 ES6 到 ES5 语法
- 注入代码统计单元测试覆盖率

## AST解析器
### JS Parser解析器
AST是如何生成的？
- 能够将JavaScript源码转化为抽象语法树（AST）的工具叫做JS Parser解析器。

JS Parser的解析过程包括两部分
- 词法分析（Lexical Analysis）：将整个代码字符串分割成最小语法单元数组
- 语法分析（Syntax Analysis）：在分词基础上建立分析语法单元之间的关系

常见的AST parser
- 早期有uglifyjs和esprima
- Espree，基于esprima，用于eslint
- Acorn，号称是相对于esprima性能更优，体积更小
- Babylon，出自acorn，用于babel
- Babel-eslint，babel团队维护，用于配合使用ESLint

### 词法分析（Lexical Analysis）
语法单元是被解析语法当中具备实际意义的最小单元，简单的来理解就是自然语言中的词语。

Javascript 代码中的语法单元主要包括以下这么几种：
- 关键字：例如 var、let、const等
- 标识符：没有被引号括起来的连续字符，可能是一个变量，也可能是 if、else 这些关键- 字，又或者是 true、false 这些内置常量
- 运算符： +、-、 *、/ 等
- 数字：像十六进制，十进制，八进制以及科学表达式等
- 字符串：因为对计算机而言，字符串的内容会参与计算或显示
- 空格：连续的空格，换行，缩进等
- 注释：行注释或块注释都是一个不可拆分的最小语法单元
- 其他：大括号、小括号、分号、冒号等
### 语法分析（Syntax Analysis）
组合分词的结果，确定词语之间的关系，确定词语最终的表达含义，生成抽象语法树。
### 示例
[见原文](https://juejin.im/post/5e942d926fb9a03c7d3d07a4#heading-6)
### 工具网站
[见原文](https://juejin.im/post/5e942d926fb9a03c7d3d07a4#heading-7)

## AST in Babel
### Babel的运行原理
Babel的工作过程经过三个阶段，parse、transform、generate
- parse阶段，将源代码转换为AST
- transform阶段，利用各种插件进行代码转换
- generator阶段，再利用代码生成工具，将AST转换成代码

Parse-解析

- Babel 使用 @babel/parser 解析代码，输入的 js 代码字符串根据 ESTree 规范生成 AST
- Babel 使用的解析器是 babylon

Transform-转换
- 接收 AST 并对其进行遍历，在此过程中对节点进行添加、更新及移除等操作。也是Babel- 插件接入工作的部分。
- Babel提供了@babel/traverse(遍历)方法维护AST树的整体状态，方法的参数为原始AST和自定义的转换规则，返回结果为转换后的AST。

Generator-生成
- 代码生成步骤把最终（经过一系列转换之后）的 AST 转换成字符串形式的代码，同时还会创建源码映射（source maps）。
- 遍历整个 AST，然后构建可以表示转换后代码的字符串。
- Babel使用 @babel/generator 将修改后的 AST 转换成代码，生成过程可以对是否压缩以及是否删除注释等进行配置，并且支持 sourceMap。

## Demo with esprima
了解了babel的运行原理，我们根据babel的三个步骤来动手写一个demo，加深对AST的理解。
https://juejin.im/post/5e942d926fb9a03c7d3d07a4#heading-10

## 思考题
> 假设a是一个对象，var a = { b : 1}，那么a.b和a['b'] ，哪个性能更高呢？

a.b和a['b']的写法，大家经常会用到，也许没有注意过这两种写法会有性能差异。事实上，有人做过测试，两者的性能差距不大，a.b会比a['b']性能稍微好一点。那么，为什么a.b比a['b']性能稍微好一点呢？
我认为，a.b可以直接解析b为a的属性，而a['b']可能会多一个判断的过程，因为[]里面的内容可能是一个变量，也可能是个常量。

https://juejin.im/post/5e942d926fb9a03c7d3d07a4#heading-12








