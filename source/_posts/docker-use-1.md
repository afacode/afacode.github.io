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
`阿里云镜像加速`麻烦未做
```
vim /etc/docker/daemon.json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}


service docker restart
```

## 基础操作
```
docker version

docker image ls || docker images 本地主机上的镜像

同一仓库源可以有多个 TAG
REPOSITORY:TAG 来定义不同的镜像
不指定一个镜像的版本标签，将默认使用 ubuntu:latest 镜像

docker pull REPOSITORY:TAG  获取一个新的镜像

docker search REPOSITORY  查找镜像

docker rmi REPOSITORY:TAG 删除镜像



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
docker run -t -i --name distserver imagesName /bin/bash

# -t -i  /bin/bash 进入容器
# demo  nginxserver别名 -p 端口映射 -d：表明容器的运行模式在后台 dist-docker 镜像名
docker run --name distserver -d -p 8099:80 dist-docker:1.0.0

容器停止
docker stop `CONTAINER ID`
docker kill 

容器删除
docker rm `CONTAINER ID`
dcoker rm `docker ps -a -q` 删除所有容器

深入容器
docker inspect `CONTAINER ID`


端口映射
docker run -p 2333:80 

挂存储卷()

查询容器
docker ps || docker container ls 运行中的
docker ps -a || docker container ls --all所有的

进入容器
docker exec -it 容器ID /bin/bash

退出容器
exit

查看容器日志
docker logs -f 容器ID 

容器ID映射的宿主机端口
docker port containerID 80


设置环境变量


docker container ls || docker ps 查看当前运行的容器
```

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
# 在容器启动时才进行调用
CMD 
    CMD echo "This is a test."
    
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