---
layout: post
title: nestjs用户角色权限
date: 2020-01-25 16:42:55
tags:
  - NestJs
  - mysql
  - typeorm
---
## 前言
默认你已经初步了解nestjs概念和使用方式。
本文使用 typeorm连接mysql，加密使用bcrypt，校验使用 password基础库，使用jsonwebtoken, 文档swagger。
本文无任何参考价值，后期完成后直接将代码发布。
视频参考 [Nestjs开发《全栈之巅》第二章 - p7-基于NestJs+Passport策略的用户登录](https://www.bilibili.com/video/BV1sJ411n7PE)
## 基础文档
[官网](https://nestjs.com/)
[nestjs 中文](https://docs.nestjs.cn/6/introduction)

## 认证（Authentication）
[authentication](https://docs.nestjs.com/techniques/authentication#authentication)
[认证](https://docs.nestjs.cn/6/techniques?id=%e8%ae%a4%e8%af%81%ef%bc%88authentication%ef%bc%89)

## 表设计
[RBCA权限表的设计](https://blog.csdn.net/qq383264679/article/details/51745522)

我问使用最简单的 用户-角色-权限
user
```
import { Entity, PrimaryGeneratedColumn, Column,
    CreateDateColumn, UpdateDateColumn, ManyToMany,
    JoinTable, JoinColumn, BeforeInsert, BeforeUpdate } from 'typeorm';
import { RoleEntity } from './role.entity';
import * as bcrypt from 'bcrypt';

@Entity('user')
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('varchar', {unique: true})
  username: string;

  @Column('varchar')
  password: string;

  @CreateDateColumn({ type: 'timestamp', name: 'create_time', comment: '创建时间' })
  createTime: Date;

  @UpdateDateColumn({ type: 'timestamp', name: 'update_time', comment: '更新时间' })
  updateTime: Date;

   // 无中间实体表的配置
   @ManyToMany(type => RoleEntity, role => role.users)
   @JoinTable({
      name: 'user_role',
      joinColumns: [
          {name: 'user_id'},
      ],
      inverseJoinColumns: [
          {name: 'role_id'},
      ],
   })
   roles: RoleEntity[];

   @BeforeInsert()
   @BeforeUpdate()
   async hashPassword() {
       this.password = await bcrypt.hash(this.password, 12);
   }

   async comparePassword(password: string) {
    return await bcrypt.compare(password, this.password);
   }
}

```

role
```
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToMany, JoinTable } from 'typeorm';
import { UserEntity } from './user.entity';
import { PermissionEntity } from './permission.entity';

@Entity('role')
export class RoleEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('varchar', {unique: true})
  name: string;

  @Column('varchar')
  alias: string;

  @Column('varchar')
  desc: string;

  @CreateDateColumn({ type: 'timestamp', name: 'create_time', comment: '创建时间' })
  createTime: Date;

  @UpdateDateColumn({ type: 'timestamp', name: 'update_time', comment: '更新时间' })
  updateTime: Date;

  @ManyToMany(type => UserEntity, user => user.roles, { cascade: true })
  users: UserEntity[];

  // 无中间实体表的配置
  @ManyToMany(type => PermissionEntity, perm => perm.roles)
  @JoinTable({
     name: 'role_perm',
     joinColumns: [
         {name: 'role_id'},
     ],
     inverseJoinColumns: [
         {name: 'perm_id'},
     ],
  })
  perms: PermissionEntity[];
}
```
permission
```
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToMany } from 'typeorm';
import { RoleEntity } from './role.entity';

@Entity('permission')
export class PermissionEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  pid: number;

  @Column()
  url: string;

  @Column()
  code: string;

  @Column()
  perms: string;

  @Column()
  name: string;

  @CreateDateColumn({ type: 'timestamp', name: 'create_time', comment: '创建时间' })
  createTime: Date;

  @UpdateDateColumn({ type: 'timestamp', name: 'update_time', comment: '更新时间' })
  updateTime: Date;

  @ManyToMany(type => RoleEntity, role => role.perms, { cascade: true })
  roles: RoleEntity[];
}
```
## 编码逻辑
用户登录后获取token, 每次请求都带token，在需要验证权限（guard）的地方，解析token，获取到用户的角色信息，在根据角色信息查看所对应的权限，查看所对应的权限是否有请求需要的权限。有就通过，没有就不通过

## 编码
local.strategy.ts
主要作用 获取到用户名和密码，查找验证用户，通过后会将用户信息挂载到request请求上，request.user。
```
import { Strategy } from 'passport-local';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy, 'local') {
  constructor(private readonly authService: AuthService) {
    // 客户端请求体传递过来的参数名称，默认为 username / password
    super({
      usernameField: 'username',
      passwordField: 'password',
    });
  }

  // 默认调用 validate() 参数为   客户端请求体传递过来的参数名称 返回用户信息
  async validate(username: string, passport: string) {
    const user = await this.authService.validateUser(username, passport);
    if (!user) {
      throw new UnauthorizedException();
    }
    return user;
  }
}
```
jwt.strategy.ts
主要作用 生成token 和验证 token
```
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { Injectable } from '@nestjs/common';
import { jwtConstants } from './constants';
import { AuthService } from './auth.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  /**
   * 这里的构造函数向父类传递了授权时必要的参数，在实例化时，父类会得知授权时，客户端的请求必须使用 Authorization 作为请求头，
   * 而这个请求头的内容前缀也必须为 Bearer，在解码授权令牌时，使用秘钥 secretOrKey: 'secretKey' 来将授权令牌解码为创建令牌时的 payload。
   */
  constructor(private readonly authService: AuthService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: jwtConstants.secret,
    });
  }

  /**
   * validate 方法实现了父类的抽象方法，在解密授权令牌成功后，即本次请求的授权令牌是没有过期的，
   * 此时会将解密后的 payload 作为参数传递给 validate 方法，这个方法需要做具体的授权逻辑，比如这里我使用了通过用户名查找用户是否存在。
   * 当用户不存在时，说明令牌有误，可能是被伪造了，此时需抛出 UnauthorizedException 未授权异常。
   * 当用户存在时，会将 user 对象添加到 req 中，在之后的 req 对象中，可以使用 req.user 获取当前登录用户。
   */
  async validate(id) {
    const user = await this.authService.findUserById(id);
    return user;
  }
}
```

role.guard.ts
有验证角色权限的逻辑
token已经在jwt.strategy.ts验证过token的有效性及将token解析挂载到了request，无用户信息直接返回。
获取到用户的角色，根据角色查看权限，在比对请求路由的权限是否在用户所属权限里面，没有就返回权限不足，有就返回用户信息
```
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Request } from 'express';

@Injectable()
export class DemoGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {} 

  canActivate(context: ExecutionContext): boolean {
    const request: Request = context.switchToHttp().getRequest();
    const user = (request as any).user;
    if (!user) { return false; }
    // 当前请求所需权限
    const perms = this.reflector.get<string[]>('perms', context.getHandler());
    if (!perms) {
      // 空， 标识不需要权限
      return true;
    }


    // 获取用户角色的权限
    const userPerms = await .... // 一个接口 到数据库获取用户角色对应的权限

    const hasPerm = () => userPerms.some((perm) => perms.includes(perm))
    return user && hasPerm();
  }
}
```






