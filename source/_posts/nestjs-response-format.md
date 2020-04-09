---
layout: post
title: NestJs返回统一的数据格式
date: 2020-02-09 11:00:58
tags:
  - NestJs
---

## 返回的数据格式
### 直接返回的数据格式
```
{
  "username": "string",
  "access_token": "XXX"
}
```
### 自己包装返回的数据格式
> 成功的格式
```
{
  "data": {
    "username": "string",
    "access_token": "XXX"
  },
  "code": 0,
  "message": "请求成功"
}
```

> 出错后的格式
```
{
  "statusCode": 401,
  "data": {
    "error": "Client Error"
  },
  "message": "请求失败",
  "code": 1,
  "url": "/api/auth/profile"
}
```

## 拦截全部的错误请求,统一返回格式
src/core/filter/http-exception.filter';
```
日志代码去掉
import { ArgumentsHost, Catch, ExceptionFilter, HttpException, HttpStatus } from '@nestjs/common';
import { Request, Response } from 'express';
import { Logger } from '../../utils/log4js';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    const logFormat = `Request original url: ${request.originalUrl} Method: ${request.method} IP: ${request.ip} Status code: ${status} Response: ${exception.toString()}`;
    Logger.info(logFormat);

    const message = exception.message.message ? exception.message.message : `${status >= 500 ? 'Service Error' : 'Client Error'}`;
    const errorResponse = {
      statusCode: status,
      data: { error: message },
      message: '请求失败',
      code: 1, // 自定义code
      url: request.originalUrl, // 错误的url地址
    };
    // 设置返回的状态码、请求头、发送错误信息
    response.status(status);
    response.header('Content-Type', 'application/json; charset=utf-8');
    response.send(errorResponse);
  }
}


```

main.ts 全局引入
```
...
import { HttpExceptionFilter } from './core/filter/http-exception.filter';

async function bootstrap() {
  ...
  // 全局注册错误的过滤器
  app.useGlobalFilters(new HttpExceptionFilter());
}
bootstrap();
```

## 统一请求成功的返回数据
src/core/interceptor/transform.interceptor.ts
```
日志代码去掉
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { Logger } from '../../utils/log4js';

@Injectable()
export class TransformInterceptor implements NestInterceptor {
  public intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.getArgByIndex(1).req;
    return next.handle().pipe(
      map(data => {
        const logFormat = `
          Request original url: ${req.originalUrl}
          Method: ${req.method}
          IP: ${req.ip}
          User: ${JSON.stringify(req.user)}
          Response data: ${JSON.stringify(data)}
         `;
        Logger.info(logFormat);
        Logger.access(logFormat);

        return {
          data,
          code: 0,
          message: '请求成功',
        };
      }),
    );
  }
}
```
> main.ts 全局注册
```
...
import { TransformInterceptor } from './core/interceptor/transform.interceptor';

async function bootstrap() {
  ...
  // 全局注册拦截器
  app.useGlobalInterceptors(new TransformInterceptor());
  ...
}
bootstrap();
```


