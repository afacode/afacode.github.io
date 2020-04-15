---
layout: post
title: NestJs简单实现文件上传
date: 2020-04-15 19:35:57
tags:
  - NestJs
  - swagger
---
## 简介
nestjs + swagger
## file.module.ts
```
import { Module } from '@nestjs/common';
import { FileController } from './file.controller';
import { FileService } from './file.service';
import { MulterModule } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import dayjs = require('dayjs');
import * as nuid from 'nuid';

@Module({
  imports: [
    MulterModule.register({
      storage: diskStorage({
        // 配置文件上传后的文件夹路径
        destination: `./public/uploads/${dayjs().format('YYYY-MM-DD')}`,
        filename: (req, file, cb) => {
          // 在此处自定义保存后的文件名称
          const filename = `${nuid.next()}.${file.mimetype.split('/')[1]}`;
          return cb(null, filename);
        },
      }),
    }),
  ],
  controllers: [FileController],
  providers: [FileService],
})
export class FileModule {}
```
## file.controller.ts
```
import { Controller, Post, UploadedFile, UseInterceptors } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiConsumes, ApiNotImplementedResponse, ApiBody } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { FileUploadDto } from './dto/upload.dto';

@ApiTags('文件上传')
@Controller('file')
export class FileController {

  @ApiOperation({summary: '文件上传，接收 multipart/form-data 的数据'})
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    description: '文件上传',
    type: FileUploadDto,
  })
  @UseInterceptors(FileInterceptor('file'))
  @Post('upload')
  uploadFile(@UploadedFile() file) {
    return file;
  }
}

```
## upload.dto.ts
```
import { ApiProperty } from '@nestjs/swagger';

export class FileUploadDto {
  @ApiProperty({ type: 'string', format: 'binary' })
  file: any;
}

```

## main.ts
```
import { join } from 'path';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    cors: true,
  });

  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  // 可以直接访问文件 如：http://localhost:3000/public/uploads/2020-04-15/36T4NJ0P3UQCIU3GFRMARZ.jpeg
  // 配置 public 文件夹为静态目录，以达到可直接访问下面文件的目的
  const rootDir = join(__dirname, '..');
  app.use('/public', express.static(join(rootDir, 'public')));

  // 设置所有 api 访问前缀
  app.setGlobalPrefix('/api');
  // 使用全局拦截器打印出参
  app.useGlobalInterceptors(new TransformInterceptor());
  // 过滤处理 HTTP 异常
  // AllExceptionsFilter 要在 HttpExceptionFilter 的上面，
  // 否则 HttpExceptionFilter 就不生效了，全被 AllExceptionsFilter 捕获了
  app.useGlobalFilters(new AllExceptionFilter());
  app.useGlobalFilters(new HttpExceptionFilter());

  // 接口文档 swagger 参数
  const options = new DocumentBuilder()
    .setTitle('角色权限管理')
    .setDescription('角色权限')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, options);
  SwaggerModule.setup('doc', app, document);

  await app.listen(port);
  Logger.log(`http://localhost:${port}`, '服务启动成功');
}
bootstrap();

```


## 前端
```
<template>
  <div class="">
    <el-upload action="http://localhost:3000/api/file/upload" drag>
      <i class="el-icon-upload" />
      <div class="el-upload__text">
        将文件拖到此处，或<em>点击上传</em>
      </div>
    </el-upload>
  </div>
</template>
```
