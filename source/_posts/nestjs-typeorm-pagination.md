---
layout: nestjs
title: NestJs 下使用 TypeORM 分页查询问题
date: 2019-11-29 23:43:27
tags:
  - NestJs
  - TypeORM
---

## NestJs 下使用 TypeORM 分页查询问题

开发应用程序时，大部分时间都需要分页功能。如果您的应用程序中有分页、页面滑块或无限滚动组件，则使用此选项。

## [官方教程](http://typeorm.io/#/select-query-builder/using-pagination)

## DEMO

```typescript
const users = await getRepository(User)
    .createQueryBuilder("user")
    .leftJoinAndSelect("user.photos", "photo")
    .take(10)
    .getManyAndCount();
```

这将会查询前10条用户及其照片的数据。

```typescript
// getManyAndCount 返回一个长度为2的元组，[0] 是分页后的数据数组， [1] 是所有数据总数
const users = await getRepository(User)
    .createQueryBuilder("user")
    .leftJoinAndSelect("user.photos", "photo")
    .skip(10)
    .getManyAndCount();
```

这将会查询除了前10条用户以外的所有人及其照片的数据。

您可以组合使用他们：

```typescript
const users = await getRepository(User)
    .createQueryBuilder("user")
    .leftJoinAndSelect("user.photos", "photo")
    .skip(5)
    .take(10)
    .getManyAndCount();
```

这将会在第6条记录开始查询10条记录，即查询6-16条用户及其照片的数据。

注意：**`take` 和 `skip` 可能看起来像 `limit` 和 `offset`，但它们不是。一旦您有更复杂的连接或子查询查询，`limit` 和 `offset` 可能无法正常工作。使用 `take` 和 `skip` 可以防止出现这些问题。**

## skip + take 与 offset + limit 的区别

当查询中存在连接或子查询时，`skip + take` 的方式总是能正确的返回数据，而 `offset + limit` 返回的数据并不是我们期望的那样。所以查询分页数据时，应该使用 `skip + take`。

