---
layout: post
title: Nestjs 设置https
date: 2024-02-09 23:00:58
tags:
  - NestJs
---
## 只是用https

```js
import * as fs from 'fs';
 
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
 
const httpsOptions = {
  key: fs.readFileSync('/Users/afacode/localhost_ssl/blog.afacode.top.key'),
  cert: fs.readFileSync('/Users/afacode/localhost_ssl/blog.afacode.top.crt'),
};
 
async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    httpsOptions,
  });
  app.enableCors();
  // 配置了hosts文件，让blog.afacode.top指向127.0.0.1
  console.log(`https://blog.afacode.top:3000/`);
  await app.listen(3000);
}
bootstrap();
```

## http和https

```js
import * as fs from 'fs';
import * as http from "http";
import * as https from "https";
 
 
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as express from 'express';
import { ExpressAdapter } from '@nestjs/platform-express';
 
const httpsOptions = {
  key: fs.readFileSync('/Users/afacode/localhost_ssl/blog.afacode.top.key'),
  cert: fs.readFileSync('/Users/afacode/localhost_ssl/blog.afacode.top.crt'),
};
 
async function bootstrap() {
  const server = express();
 
  const app = await NestFactory.create(
    AppModule, 
    new ExpressAdapter(server)
  );
 
  app.setGlobalPrefix('api');
  app.enableCors();
 
  await app.init();
 
  console.log(`http://blog.afacode.top:3000`);
  console.log(`https://blog.afacode.top`);
  http.createServer(server).listen(3000);
  https.createServer(httpsOptions, server).listen(443);
}
bootstrap();
```

