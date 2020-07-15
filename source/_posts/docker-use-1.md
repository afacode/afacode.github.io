---
layout: post
title: docker使用
date: 2019-09-05 23:37:31
tags:
  - docker 
---
## 安装
```
apt-get update
apt-get install -y docker.io
```
## 配置镜像源
`阿里云镜像加速`
```
vim /etc/docker/daemon.json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}


service docker restart
```

## 镜像
```
docker version

查看本地主机上的镜像
docker image ls || docker images 

同一仓库源可以有多个 TAG
REPOSITORY:TAG 来定义不同的镜像
不指定一个镜像的版本标签，将默认使用 ubuntu:latest 镜像

docker pull REPOSITORY:TAG  获取一个新的镜像

docker search REPOSITORY  查找镜像

镜像别名 
docker image tag REPOSITORY:TAG  newImage:v1
docker tag 原镜像名称：TAG  新镜像：TAG

删除镜像
docker rmi REPOSITORY:TAG 
docker image rm REPOSITORY:TAG
docker image rm IMAGE-ID


docker run REPOSITORY:TAG

创建镜像:(构建镜像)
docker build 

更新镜像: 
更新镜像之前，我们需要使用镜像来创建一个容器
1.从已经创建的容器中更新镜像，并且提交这个镜像
2.使用 Dockerfile 指令来创建一个新的镜像

```

## 容器
```
容器运行
docker run -d --name distserver imagesName /bin/bash

-it  /bin/bash 进入容器
--name 命名
-p 端口映射 
-d：表明容器的运行模式在后台 
dist-docker 镜像名
docker run --name distserver -d -p 8099:80 dist-docker:1.0.0

容器停止
docker stop `CONTAINER ID`
docker kill 

启动
docker start CONTAINER ID

docker stats  查看CPU


容器删除
docker rm `CONTAINER ID`
dcoker rm `docker ps -a -q` 删除所有容器

深入容器
docker inspect `CONTAINER ID`

获取容器IP
docker inspect 5003a6cecaf1 | grep IPAddress


端口映射
docker run -p 2333:80 

挂存储卷()

查询容器
docker ps || docker container ls 运行中的
docker ps -a || docker container ls --all所有的

进入容器
docker exec -it 容器ID /bin/bash

docker attach 容器ID

退出容器
exit

查看容器日志
docker logs -f 容器ID 

容器ID映射的宿主机端口
docker port containerID 80


设置环境变量


docker container ls || docker ps 查看当前运行的容器

将容器内容拷贝至主机
docker cp containerID:/home/demo.html /Users/afacode/private/

docker run  参数
-d
--name
-p 
-v 数据挂载
-e 配置环境


多个容器数据卷相互共享，实际是备份
--volumes-from mysql01

docker run -d -p 3307:3306 -v /home/mysql/conf:/etc/mysql/conf.d -v /home/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw --name mysql01  mysql:5.7

docker run -d -p 3307:3306 --volumes-from mysql01 -e MYSQL_ROOT_PASSWORD=my-secret-pw --name mysql01  mysql:5.7


多个MySQL或者Redis实现数据共享

容器之间配置信息的相互传递，数据卷生命周期一直持续到没有人使用容器为止

```

## 容器数据卷
* 容器内产生的数据，同步到本地。需要数据共享。将容器内目录挂载到本地


```
docker run -v
-v 主机目录：容器内目录

docker run -it -v /home/test:/home  centos /bin/bash
容器内/home目录会同步到本机/home/test
反之同理 双向绑定


多个容器数据卷相互共享，实际是备份
--volumes-from mysql01

docker run -d -p 3307:3306 -v /home/mysql/conf:/etc/mysql/conf.d -v /home/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw --name mysql01  mysql:5.7

docker run -d -p 3307:3306 --volumes-from mysql01 -e MYSQL_ROOT_PASSWORD=my-secret-pw --name mysql01  mysql:5.7


多个MySQL或者Redis实现数据共享

容器之间配置信息的相互传递，数据卷生命周期一直持续到没有人使用容器为止
```

### MySQL数据持久化

```
docker pull mysql:5.7

docker images

docker run -d -p 3307:3306 -v /home/mysql/conf:/etc/mysql/conf.d -v /home/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw --name mysql-demo  mysql:5.7
```

具名挂载和匿名挂载

```
匿名挂载 是只指定容器内路径，没有指定本机路径

docker run -d -v 

查看所有卷
docker volume ls
这种事匿名挂载
local               6ae0f43ce8eab7c422d4f83cebbbb3e2b801bdcacea7fb1aaabc59fb5296a96c

具名挂载 
docker run -d -v juming-nginx:/etc/nginx nginx:latest


查看卷 
docker volume inspect VOLUME-NAME

[
    {
        "CreatedAt": "2020-07-13T03:12:37Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/6ae0f43ce8eab7c422d4f83cebbbb3e2b801bdcacea7fb1aaabc59fb5296a96c/_data",
        "Name": "6ae0f43ce8eab7c422d4f83cebbbb3e2b801bdcacea7fb1aaabc59fb5296a96c",
        "Options": null,
        "Scope": "local"
    }
]

所有没有指定卷的路径时，都是在 /var/lib/docker/volumes/****/_data



如何确定是 具名挂载，匿名挂载还是指定路径挂载

-v 容器内路径           匿名挂载
-v 卷名:容器内路径      具名挂载
-v 本机路径:容器内路径   指定路径挂载


拓展
读写权限
ro readonly  只读  路径内文件只能通过本机操作，不能通过容器内操作
rw readwrite



docker run -d -v juming-nginx:/etc/nginx:ro nginx:latest

docker run -d -v juming-nginx:/etc/nginx:rw nginx:latest

```


## 网络


## 自定义镜像
```
镜像构建
1. docker commit
docker commit containerID afacode/newImage
docker commit -m="A new image" --author="afacode <afacode@outlook.com>" containerID afacode/newImage:Tag

2. docker build 

docker build -t hello-docker:1.0.0 ./   --no-cache

docker build -t hello-docker:1.0.0 -f /var/test/Dockerfile

-t 参数用来指定镜像的文件名称镜像的名字hello-docker，版本号1.0.0,  
./  找当前目录的Dockerfile
--no-cache 不使用缓存
镜像构建过程中会按照Dockerfile的顺序依次执行，每执行一次指令 Docker 会寻找是否有存在的镜像缓存可复用，如果没有则创建新的镜像。如果不想使用缓存，则可以在docker build时添加--no-cache=true选项。

构建历史
docker history imageID

镜像打TAG
docker tag 
为本地镜像打标签，tag 不写默认为 latest
docker image tag [imageName] [username]/[repository]:[tag]
docker tag hello-docker afacode/hello-docker

镜像推送
docker push 
docker image push [username]/[repository]:[tag]
docker push afacode/hello-docker
```
## [Dockerfile](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
```
# 指定基础镜像
FROM 
    FROM <image>
    FROM <image>:<tag>
    FROM <image>@<digest>

# 维护者信息
MAINTAINER
    MAINTAINER afacode
    MAINTAINER afacode@outlook.com
    MAINTAINER afacode <afacode@outlook.com>

WORKDIR
通过WORKDIR设置工作目录后，Dockerfile中其后的命令RUN、CMD、ENTRYPOINT、ADD、COPY等命令都会在该目录下执行。在使用docker run运行容器时，可以通过-w参数覆盖构建时所设置的工作目录。


# 构建镜像时执行的命令
RUN
    RUN <command>

# 将本地文件添加到容器中，tar类型文件会自动解压(网络压缩资源不会被解压)，可以访问网络资源，类似wget
ADD
# 功能类似ADD，但是是不会自动解压文件，也不能访问网络资源
COPY
# 在容器启动时才进行调用，cmd只有最后一个会生效
CMD 
    CMD echo "This is a test."

ENTRYPOINT  在容器启动时才进行调用 可以追加命令

ONBUILD

    
# 设置环境变量
ENV
# 指定于外界交互的端口
EXPOSE
    EXPOSE 80 443
    EXPOSE 8080
# 用于指定持久化目录
一个卷可以存在于一个或多个容器的指定目录，该目录可以绕过联合文件系统，并具有以下功能：
1 卷可以容器间共享和重用
2 容器并不一定要和其它容器共享卷
3 修改卷后会立即生效
4 对卷的修改不会对镜像产生影响
5 卷会一直存在，直到没有任何容器在使用它
VOLUME
    VOLUME ["/data"]
    VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2"
```

## [自己发布的练习镜像](https://hub.docker.com/search?q=afacode&type=image)
## [学习书籍:第一本docker书](https://pan.baidu.com/s/1b4Jr_ut4FfR90asXuzWX5g) 密码 `fnoj`

## 练习Demo
```
mkdir hello-docker
1. 创建文件
touch inde.html
<h1>Hello docker</h1>

创建一个Dockerfile文件
FROM nginx
COPY ./index.html /usr/share/nginx/html/index.html
EXPOSE 80

2. 打包镜像
cd hello-docker/ # 进入刚刚的目录
docker image build ./ -t hello-docker:1.0.0 # 打包镜像
基于路径./（当前路径）打包一个镜像，镜像的名字是hello-docker，版本号是1.0.0。该命令会自动寻找Dockerfile来打包出一个镜像

3. 运行容器
docker container create -p 2333:80 hello-docker:1.0.0
docker container start xxx # xxx 为上一条命令运行得到的结果

4. 预览
浏览器打开127.0.0.1:2333，你应该能看到刚刚自己写的index.html内容

5 查看当前运行的容器
docker container ls || docker ps

6. 进入容器内部
docker container exec -it xxx /bin/bash # xxx 为容器ID

```