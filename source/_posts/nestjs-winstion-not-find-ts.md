---
layout: post
title: Property 'DailyRotateFile' does not exist on type 'typeof TransportStream'.ts(2339)
date: 2023-10-22 14:35:57
tags:
  - NestJs
  - winston
---
## 简介
nestjs项目中导入`new winston.transport.DailyRotateFile({...})`提示`Property 'DailyRotateFile' does not exist on type 'typeof TransportStream'.ts(2339)`

## 解决
```ts
import * as winston from 'winston';
// import 'winston-daily-rotate-file';
import DailyRotateFile = require("winston-daily-rotate-file");
import { WinstonModule } from 'nest-winston';

WinstonModule.forRoot({
      transports: [
        // new winston.transport.DailyRotateFile({
        new DailyRotateFile({
          dirname: `logs`, // 日志保存的目录
          filename: '%DATE%.log', // 日志名称，占位符 %DATE% 取值为 datePattern 值。
          zippedArchive: true, // 是否通过压缩的方式归档被轮换的日志文件。
          maxSize: '20m', // 设置日志文件的最大大小，m 表示 mb 。
          maxFiles: '14d', // 保留日志文件的最大天数，此处表示自动删除超过 14 天的日志文件。
          // 记录时添加时间戳信息
          format: winston.format.combine(
            winston.format.timestamp({
            	format: 'YYYY-MM-DD HH:mm:ss',
            }),
            winston.format.json(),
          ),
        }),
      ]
    }),

```