---
layout: post
title: webpack打包，文件删除
date: 2019-06-20 23:16:18
tags:
  - webpack
  - ora
  - chalk
---


## build/build.js
```
const ora = require('ora')
const rm = require('rimraf') // 删除
const chalk = require('chalk') // 颜色
const webpack = require('webpack')
const webpackConfig = require('./webpack.config')
const { resolve } = require('./utils')
const APP_ENV = process.env.APP_ENV ? process.env.APP_ENV : 'prod'

const spinner = ora(chalk.green(`${process.env.NODE_ENV}: ${APP_ENV}环境编译打包开始...`))
  .start()


rm(resolve('dist'), err => {
  if (err) throw err
  webpack(webpackConfig, (err, stats) => {
    spinner.stop()
    if (err) throw err

    process.stdout.write(stats.toString({
      colors: true,
      modules: false,
      children: false,
      chunks: false,
      chunkModules: false
    })+ '\n\n')

    if (stats.hasErrors()) {
      console.log(chalk.red.bold('编译打包失败.\n'))
      process.exit(1)
    }

    console.log(chalk.blue('打包完成.\n'))
  })  
})

```

## package.json

```
...
"scripts": {
  "dev": "cross-env NODE_ENV=development webpack-dev-server --color --config ./build/webpack.config.js",
  "start": "npm run dev",
  "build": "cross-env NODE_ENV=production node ./build/build.js",
  "build:prod": "cross-env APP_ENV=prod npm run build",
  "build:qa": "cross-env APP_ENV=qa npm run build",
  "demo": "node ./build/utils.js",
  "test": "jest"
},
...
```