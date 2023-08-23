---
layout: post
title: Web Component学习体验
date: 2023-08-02 17:57:25
categories:
  - js
tags:
  - webComponents
  - js
---

## Web Component学习体验

> [Web_components](https://developer.mozilla.org/zh-CN/docs/Web/API/Web_components)是一套不同的技术，允许你创建可重用的定制元素（它们的功能封装在你的代码之外）并且在你的 web 应用中使用它们。
>
> 直接脱离框架组件开发，更好的移植

>练习demo `afa-demo-card`

效果图

打开 链接 [https://pan.baidu.com/s/1uI3_Bxa5dYekVkYx7oQW8g?pwd=e9mc](https://pan.baidu.com/s/1uI3_Bxa5dYekVkYx7oQW8g?pwd=e9mc)

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <title>web-components</title>
</head>

<body>
  <afa-demo-card avatar="https://img1.baidu.com/it/u=1427002047,2227256907&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=575"
    name="阿发" email="lfqdalian@outlook.com"></afa-demo-card>

  <template id="afaDemoCardTemplate">
    <img src="" alt="" class="img">
    <div class="wrap">
      <p class="name"></p>
      <p class="email"></p>
    </div>

    <style>
      :host {
        display: flex;
        align-items: center;
        width: 450px;
        height: 300px;
        background: #d4d4d4;
        border: 1px solid red;
        box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.1);
        border-radius: 3px;
        overflow: hidden;
        padding: 10px;
        box-sizing: border-box;
      }

      .img {
        flex: 0 0 auto;
        width: 160px;
        height: 160px;
        vertical-align: middle;
        border-radius: 5px;
      }

      .wrap {
        box-sizing: border-box;
        padding: 20px;
        height: 160px;
      }

      .wrap>.name {
        font-size: 20px;
        font-weight: 600;
        line-height: 1;
        margin: 0;
        margin-bottom: 5px;
      }

      .wrap>.email {
        font-size: 12px;
        opacity: 0.75;
        line-height: 1;
        margin: 0;
        margin-bottom: 15px;
      }
    </style>
  </template>

  <script>
    class AfaDemoCard extends HTMLElement {
      constructor() {
        super()

        const shadowDom = this.attachShadow({ mode: 'closed' })
        const template = document.querySelector('#afaDemoCardTemplate')
        const content = template.content.cloneNode(true)

        content.querySelector('.img').setAttribute('src', this.getAttribute('avatar'))
        content.querySelector('.name').innerText = this.getAttribute('name')
        content.querySelector('.email').innerText = this.getAttribute('email')

        shadowDom.appendChild(content)
      }
    }

    window.customElements.define('afa-demo-card', AfaDemoCard)
  </script>
</body>
</html>
```