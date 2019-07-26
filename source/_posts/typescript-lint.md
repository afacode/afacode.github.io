---
layout: post
title: TypeScript代码检查
date: 2019-07-24 21:13:21
tags:
    - typescript
    - eslint
    - tslint
---

目前 TypeScript 的代码检查主要有两个方案：使用 `TSLint` 或使用 `ESLint + typescript-eslint-parser`
<!-- more -->

## ESLint
由于 ESLint 默认使用 [Espree](https://github.com/eslint/espree) 进行语法解析，无法识别 TypeScript 的一些语法，故我们需要安装 `typescript-eslint-parser` 替代掉默认的解析器.

由于 `typescript-eslint-parser` 对一部分 `ESLint` 规则支持性不好，故我们需要安装 `eslint-plugin-typescript`，弥补一些支持性不好的规则
### 安装
```
npm install eslint --save-dev
npm install typescript-eslint-parser --save-dev
npm install eslint-plugin-typescript --save-dev
npm install --save-dev eslint-plugin-react # 检查 tsx 文件
```
### 配置文件
一般为根目录`.eslintrc.js` 或 `.eslintrc.json`
```
module.exports = {
    parser: 'typescript-eslint-parser',
    plugins: [
        'typescript'
    ],
    rules: {
        // @fixable 必须使用 === 或 !==，禁止使用 == 或 !=，与 null 比较时除外
        'eqeqeq': [
            'error',
            'always',
            {
                null: 'ignore'
            }
        ],
        // 类和接口的命名必须遵守帕斯卡命名法，比如 PersianCat
        'typescript/class-name-casing': 'error'
    }
}
```
以上配置中，我们指定了两个规则，其中 eqeqeq 是 ESLint 原生的规则（它要求必须使用 === 或 !==，禁止使用 == 或 !=，与 null 比较时除外），typescript/class-name-casing 是 eslint-plugin-typescript 为 ESLint 增加的规则（它要求类和接口的命名必须遵守帕斯卡命名法，比如 PersianCat）

## 检查
检查整个项目的 ts 文件
package.json
```
"scripts": {
    "eslint": "eslint src --ext .ts, tsx"
}
```
> `npm run eslint`

## TSLint

### 安装
```
npm install --save-dev tslint

```
### 配置文件
`tslint.json`
```
{
    "rules": {
        // 必须使用 === 或 !==，禁止使用 == 或 !=，与 null 比较时除外
        "triple-equals": [
            true,
            "allow-null-check"
        ]
    },
    "linterOptions": {
        "exclude": [
            "**/node_modules/**"
        ]
    }
}
```


## 检查
检查整个项目的 ts 文件
`package.json`
```
"scripts": {
    "tslint": "tslint --project . src/**/*.ts src/**/*.tsx",
}
```
> `npm run eslint`





[来源](https://ts.xcatliu.com/engineering/lint)
