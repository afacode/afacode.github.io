---
layout: post
title: pm2基础使用及简单配置
date: 2019-12-18 14:34:42
tags:
  - node
  - pm2
---

## 安装

`npm install -g pm2`

## 常用命令

```
pm2 list

pm2 start app.js
pm2 restart app_name/id
pm2 stop app_name/id
pm2 delete app_name/id

pm2 log
pm2 info
pm2 monit

pm2 start app.js -i 4  # 后台运行pm2，启动4个app.js
                         # 也可以把'max' 参数传递给 start
                         # 正确的进程数目依赖于Cpu的核心数目
pm2 start app.js --name my-api # 命名进程
pm2 list               # 显示所有进程状态
pm2 monit              # 监视所有进程
pm2 logs               # 显示所有进程日志
pm2 stop all           # 停止所有进程
pm2 restart all        # 重启所有进程
pm2 reload all         # 0 秒停机重载进程 (用于 NETWORKED 进程) 0 秒停机重载：这项功能允许你重新载入代码而不用失去请求连接。
pm2 stop 0             # 停止指定的进程
pm2 restart 0          # 重启指定的进程
pm2 startup            # 产生 init 脚本 保持进程活着
pm2 web                # 运行健壮的 computer API endpoint (http://localhost:9615)
pm2 delete 0           # 杀死指定的进程
pm2 delete all         # 杀死全部进程

```

> 运行进程的不同方式

```
--watch：监听应用目录的变化，一旦发生变化，自动重启。如果要精确监听、不见听的目录，最好通过配置文件。
-i --instances：启用多少个实例，可用于负载均衡。如果-i 0或者-i max，则根据当前机器核数确定实例数目。
--ignore-watch：排除监听的目录/文件，可以是特定的文件名，也可以是正则。比如--ignore-watch="test node_modules "some scripts""
-n --name：应用的名称。查看应用信息的时候可以用到。
-o --output <path>：标准输出日志文件的路径。
-e --error <path>：错误输出日志文件的路径。

pm2 start app.js -i max    # 根据有效CPU数目启动最大进程数目
pm2 start app.js -i 3      # 启动3个进程
pm2 start app.js -x        #用fork模式启动 app.js 而不是使用 cluster
pm2 start app.js -x -- -a 23   # 用fork模式启动 app.js 并且传递参数 (-a 23)
pm2 start app.js --name serverone  # 启动一个进程并把它命名为 serverone
pm2 stop serverone       # 停止 serverone 进程
pm2 start app.json        # 启动进程, 在 app.json里设置选项
pm2 start app.js -i max -- -a 23   #在--之后给 app.js 传递参数
pm2 start app.js -i max -e err.log -o out.log  # 启动 并 生成一个配置文件

```

## 简单配置
启动 `pm2 start pm2.conf.json`

pm2.conf.json
```
{
  "apps": [{
    "name"        : "fis-receiver",  // 应用名称
    "script"      : "./bin/www",  // 实际启动脚本
    "cwd"         : "./",  // 当前工作路径
    "watch": [  // 监控变化的目录，一旦变化，自动重启
      "bin",
      "routers"
    ],
    "ignore_watch" : [  // 从监控目录中排除
      "node_modules",
      "logs",
      "public"
    ],
    "watch": true, // 是否监听重启，
    "instances": 4, // 几核，多进程 多进程之间内存无法共享，使用redis共享数据
    "error_file" : "./logs/app-err.log",  // 错误日志路径
    "out_file"   : "./logs/app-out.log",  // 普通日志路径
    "log_date_format": "YYYY-MM-DD HH:mm:ss", // 日志输出时间格式
    "env": {
        "NODE_ENV": "production"  // 环境参数，当前指定为生产环境
    }
  }]
}
```
