---
layout: flutter
title: nestjs 与 typeorm结合
date: 2020-04-06 23:33:06
tags:
  - nestjs
  - typeorm
---


```
 @BeforeInsert()
  @BeforeUpdate()
  async hashPassword() {
    this.password = await bcrypt.hash(this.password, 12);
  }
```