---
layout: post
title: nestjs中使用typeorm-model-generator将数据库生成数据模型
date: 2019-12-06 11:03:19
tags:
  - node
  - NestJs
  - typeorm
---

## 安装
> `npm install -g typeorm-model-generator`

## package.json
```
...
"script": {
  "db": "rm -rf entities & npx typeorm-model-generator -h localhost -d nest -p 3306 -u root -x root -e mysql -o entities --noConfig true --ce pascal --cp camel"
}
...
```

- `rm -rf entities`表示先删除文件夹entities
- `npx typeorm-model-generator`如果全局安装了就不需要加npx没有全局安装就加上去
- `-h 数据库地址 -d 数据库名字 -p 端口 -u 用户名 -x 密码 -e 数据库类型`
- -o entities表示输出到指定的文件夹
- `--noConfig true`表示不生成ormconfig.json和tsconfig.json文件
- `--ce pascal`表示将类名转换首字母是大写的驼峰命名
- `--cp camel`表示将数据库中的字段比如create_at转换为createAt
- -a表示会继承一个BaseEntity的类,根据自己需求加


## 运行
> npm run db

