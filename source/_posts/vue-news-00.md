---
layout: post
title: Vue 3 将成为新的默认版本(转)
date: 2022-01-21 22:34:55
categories:
  - js
tags:
  - vue
---

作者：尤雨溪  
链接：https://zhuanlan.zhihu.com/p/460055155  
来源：知乎 
  

划重点：Vue 3 将在 **2022 年 2 月 7 日** 成为新的默认版本！  
  
请务必阅读文末的 **可能需要采取的措施** 部分，来确认你是否需要在默认版本切换之前做相应改动以避免发生异常。

本文章开放授权，在注明原文地址，内容不做修改的前提下可以随意转载。

[Markdown 源文件](https://link.zhihu.com/?target=https%3A//gist.github.com/yyx990803/bf9a625eeff8b471bf0701afb8e3fe75) | [英文原文](https://link.zhihu.com/?target=https%3A//blog.vuejs.org/posts/vue-3-as-the-new-default.html)

---

### 从库到框架

在最开始的时候，Vue 仅仅是一个运行时库。但这些年来，它已经逐步发展成了一个包含许多子项目的框架：

-   核心库，即 `vue` npm 包
-   内容足够当作一本书的文档
-   构建工具链（Vue CLI、Vue Loader 和其他支持包）
-   用于构建单页应用的路由 Vue Router
-   用于状态管理的 Vuex
-   用于调试和分析的浏览器开发者工具扩展
-   用于支持开发单文件组件的 VSCode 扩展 Vetur
-   用于进行静态风格/错误检查的 ESLint 插件
-   用于组件测试的 Vue Test Utils
-   利用 Vue 运行时功能的定制 JSX Babel 插件
-   用于静态网站生成的 VuePress

正因为 Vue 是一个社区驱动的项目，才让这一切成为可能。这些项目中的许多都是由社区成员发起，他们后来成为了 Vue 团队的成员。其余的项目最初由我发起，但现在除了核心库之外，几乎都完全由团队维护。

### Vue 3 的 “软发布”

随着核心库发布新的大版本，框架的所有其他部分也需要一起同步更新。我们还需要为 Vue 2 用户提供一个升级方案。对于 Vue 这样一个社区驱动的团队来说，这是一个巨大的工程。在 Vue 3 的核心库完成的时候，框架的其他部分要么还在 beta 状态，要么还没有开始适配 Vue 3。当时我们的决定是先发布核心库，这样早期用户可以先用起来，库和上层框架的开发者也可以先适配起来，而我们则继续更新框架的其余部分。

在这个过程中，我们依然将 Vue 2 保留为文档和 npm 安装时的默认版本。这是因为我们知道对于大部分用户来说，在 Vue 3 的其余部分完善以前，Vue 2 仍然提供了更一致且完整的体验。

### 崭新的 Vue

“软发布” 的过程比预期要长，但这个时刻终于到了：我们很高兴地宣布，Vue 3 将在 **2022 年 2 月 7 日** 成为新的默认版本。  
  
除了 Vue 核心库以外，我们还几乎改进了框架的每个方面。

-   基于 [Vite](https://link.zhihu.com/?target=https%3A//vitejs.dev/) 的极速构建工具链
-   `<script setup>` 带来的开发体验更丝滑的组合式 API 语法
-   [Volar](https://link.zhihu.com/?target=https%3A//marketplace.visualstudio.com/items%3FitemName%3Djohnsoncodehk.volar) 提供的单文件组件 TypeScript IDE 支持
-   [vue-tsc](https://link.zhihu.com/?target=https%3A//github.com/johnsoncodehk/volar/tree/master/packages/vue-tsc) 提供的针对单文件组件的命令行类型检查和生成
-   [Pinia](https://link.zhihu.com/?target=https%3A//pinia.vuejs.org/) 提供的更简洁的状态管理
-   新的开发者工具扩展，同时支持 Vue 2/Vue 3，并且提供一个[插件系统](https://link.zhihu.com/?target=https%3A//devtools.vuejs.org/plugin/plugins-guide.html)来允许社区库自行扩展开发者工具面板。  
      
    我们还彻底重写了主文档。[全新的 vuejs.org](https://link.zhihu.com/?target=https%3A//staging.vuejs.org/) (目前处于待发布状态，[中文版](https://link.zhihu.com/?target=https%3A//staging-cn.vuejs.org/)的翻译还在进行中) 将提供最新的框架概述与开发建议、针对不同背景的用户的灵活的学习路径，在整个指南与示例中都能够在选项式 API 和组合式 API 之间进行切换，以及许多新的深入章节。新文档本身的网站性能也非常优秀——我们将在不久后的另一篇博文中详细探讨一下。

### 版本切换细节

下面是我们所说的“新的默认版本”的具体细节。此外，请务必阅读文末的 **可能需要采取的措施** 部分，来确认你是否需要在默认版本切换之前做相应改动以避免发生异常。

### npm 发布标签

-   `npm install vue` 将默认安装 Vue 3。
-   所有其他官方 npm 包的 `latest` 发布标签将指向其 Vue 3 的兼容版本，包括 `vue-router`、`vuex`、`vue-loader` 和 `@vue/test-utils`。

### 官方文档与站点

所有的文档和官方站点将默认切换到 Vue 3 版本。包括：  
  
- [http://vuejs.org](https://link.zhihu.com/?target=http%3A//vuejs.org)  
- [http://router.vuejs.org](https://link.zhihu.com/?target=http%3A//router.vuejs.org)  
- [http://vuex.vuejs.org](https://link.zhihu.com/?target=http%3A//vuex.vuejs.org)  
- [http://vue-test-utils.vuejs.org](https://link.zhihu.com/?target=http%3A//vue-test-utils.vuejs.org) (将迁移到 [http://test-utils.vuejs.org](https://link.zhihu.com/?target=http%3A//test-utils.vuejs.org))  
- [http://template-explorer.vuejs.org](https://link.zhihu.com/?target=http%3A//template-explorer.vuejs.org)  
  
请注意，新的 [http://vuejs.org](https://link.zhihu.com/?target=http%3A//vuejs.org) 将是[完全重写的版本](https://link.zhihu.com/?target=https%3A//staging.vuejs.org/)，而不是目前部署在 v3.vuejs.org 的版本。  
  
这些站点当前的 Vue 2 版本将被迁移到新地址 (版本前缀表示库的各自版本，而非 Vue 核心库的版本)：  
  
- [http://vuejs.org](https://link.zhihu.com/?target=http%3A//vuejs.org) -> [http://v2.vuejs.org](https://link.zhihu.com/?target=http%3A//v2.vuejs.org) (旧的 v2 网址将自动重定向到新地址上)  
- [http://router.vuejs.org](https://link.zhihu.com/?target=http%3A//router.vuejs.org) -> [http://v3.router.vuejs.org](https://link.zhihu.com/?target=http%3A//v3.router.vuejs.org)  
- [http://vuex.vuejs.org](https://link.zhihu.com/?target=http%3A//vuex.vuejs.org) -> [http://v3.vuex.vuejs.org](https://link.zhihu.com/?target=http%3A//v3.vuex.vuejs.org)  
- [http://vue-test-utils.vuejs.org](https://link.zhihu.com/?target=http%3A//vue-test-utils.vuejs.org) -> [http://v1.test-utils.vuejs.org](https://link.zhihu.com/?target=http%3A//v1.test-utils.vuejs.org)  
- [http://template-explorer.vuejs.org](https://link.zhihu.com/?target=http%3A//template-explorer.vuejs.org) -> [http://v2.template-explorer.vuejs.org](https://link.zhihu.com/?target=http%3A//v2.template-explorer.vuejs.org)

### GitHub 仓库

_在写这篇文章时，仓库相关的变化已经生效了。_  
  
`vuejs` 组织下的所有 GitHub 仓库将把默认分支切换到 Vue 3 对应的版本。此外，以下仓库将被重命名，以删除其名称中的 `next`：  
  
- vuejs/vue-next -> [vuejs/core](https://link.zhihu.com/?target=https%3A//github.com/vuejs/core)  
- vuejs/vue-router-next -> [vuejs/router](https://link.zhihu.com/?target=https%3A//github.com/vuejs/router)  
- vuejs/docs-next -> [vuejs/docs](https://link.zhihu.com/?target=https%3A//github.com/vuejs/docs)  
- vuejs/vue-test-utils-next -> [vuejs/test-utils](https://link.zhihu.com/?target=https%3A//github.com/vuejs/test-utils)  
- vuejs/jsx-next -> [vuejs/babel-plugin-jsx](https://link.zhihu.com/?target=https%3A//github.com/vuejs/babel-plugin-jsx)  
  
此外，主文档的翻译仓库将被移至 [vuejs-translations 组织](https://link.zhihu.com/?target=https%3A//github.com/vuejs-translations)下。  
  
GitHub 会自动处理仓库的重定向，所以之前的源码与 issue 问题的链接应该仍然有效。

### 开发者工具扩展

开发者工具 v6 目前是发布到 Chrome Web Store 的 [beta 频道](https://link.zhihu.com/?target=https%3A//chrome.google.com/webstore/detail/vuejs-devtools/ljjemllljcmogpfapbkkighbhhppjdbg)下的，在版本切换后，将移至[稳定频道](https://link.zhihu.com/?target=https%3A//chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd)。  
  
目前的稳定频道仍然可用。它将被迁移到[遗留频道](https://link.zhihu.com/?target=https%3A//chrome.google.com/webstore/detail/vuejs-devtools/iaajmlceplecbljialhhkmedjlpdblhp)。

### 可能需要采取的措施

### 未指定版本的 CDN 链接

如果你通过 CDN 链接使用 Vue 2 而没有指定版本，请确保通过 `@2` 来指定一个版本范围：

```diff
- <script src="https://unpkg.com/vue"></script>
+ <script src="https://unpkg.com/vue@2"></script>

- <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.min.js"></script>
+ <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.min.js"></script>
```

注意：即使使用 Vue 3，你也应该始终在生产环境指定一个版本范围，以避免意外地加载到未来的大版本。

### npm `latest` 标签

如果你使用 `latest` 标签或 `*` 来从 npm 安装 Vue 或其他官方库，请更新为明确使用兼容 Vue 2 的版本：

```diff
{
  "dependencies": {
-   "vue": "latest",
+   "vue": "^2.6.14",
-   "vue-router": "latest",
+   "vue-router": "^3.5.3",
-   "vuex": "latest"
+   "vuex": "^3.6.2"
  },
  "devDependencies": {
-   "vue-loader": "latest",
+   "vue-loader": "^15.9.8",
-   "@vue/test-utils": "latest"
+   "@vue/test-utils": "^1.3.0"
  }
}
```