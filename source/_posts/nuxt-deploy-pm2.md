---
layout: post
title: nuxt服务部署SSR
date: 2019-12-18 17:38:06
tags:
  - nuxt
  - pm2
---

## nuxt 部署方式

1. nuxt generate 静态化 (预渲染) 用于静态站点的部署 没有什么要说的
2. nuxt start 服务端渲染(通过SSR)

## 本地运行

npm run build 得到.nuxt

## 需要到服务器的文件

```
.nuxt
package.json
nuxt.config.js
static
```

## 服务器安装依赖

npm install -production

## 服务器启动服务 默认 3000 端口

npm run start

## 使用 pm2 启动服务在服务端执行
```
pm2 start npm --name nuxt-demo -- start
```

## nginx 配置

```
server {
	listen 80;
	server_name afacode.top www.afacode.top; # 域名

	location / {
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_set_header Host $host;
      proxy_set_header X-Nginx-Proxy true;
      proxy_cache_bypass $http_upgrade;
      proxy_pass http://127.0.0.1:3000; # 反向代理到启动的服务
	}
}
```

## nginx 重启

```
nginx -t
service nginx reload
```

## 完了
