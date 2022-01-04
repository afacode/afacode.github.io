---
layout: vue3
title: git commit 规范校验
date: 2021-07-12 22:22:34
tags:
  - vue
  - yorkie
---

> 使用yorkie `yarn add yorkie -D`

This is a fork of `husky` with a few changes
https://github.com/yyx990803/yorkie 尤大婶的

增加钩子 package.json
```json
{
  ...
  "gitHooks": {
    "commit-msg": "node scripts/verifyCommit.js"
  }
}
```
添加验证规则 scripts/verifyCommit.js
下载chalk `yarn add chalk@4.0.0 -D`
chalk5.0 后 只支持ESM  https://github.com/chalk/chalk/releases/tag/v5.0.0
```js
const chalk = require('chalk')
const msgPath = process.env.GIT_PARAMS // 获取 git msg path
const msg = require('fs').readFileSync(msgPath, 'utf-8').trim()

const commitRE = /^(revert: )?(feat|fix|docs|dx|style|refactor|perf|test|workflow|build|ci|chore|types|wip|release)(\(.+\))?(.{1,10})?: .{1,50}/
const mergeRe = /^(Merge pull request|Merge branch)/

if (!commitRE.test(msg)) {
  if (!mergeRe.test(msg)) {
    console.error(
      `  ${chalk.bgRed.white(' ERROR ')} ${chalk.red(
        `无效的commit格式.`,
      )}\n\n` +
        chalk.red(
          `  commit需要正确的格式. 例如:\n\n`,
        ) +
        `    ${chalk.green(`feat(compiler): add 'comments' option`)}\n` +
        `    ${chalk.green(
          `fix(v-model): handle events on blur (close #28)`,
        )}\n\n` +
        chalk.red(
          `  查看 https://github.com/vuejs/vue-next/blob/master/.github/commit-convention.md 更多细节.\n`,
        ),
    )
    process.exit(1)
  }
}

```

