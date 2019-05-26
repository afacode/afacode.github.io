---
layout: post
title: Mac Python Selenium+WebDriver(chromedriver)安装下载
date: 2019-05-25 22:21:55
categories: 
  - python
tags:
  - python
  - selenium
  - webDriver
  - chromedriver
---
Selenium 是一个开源测试框架，用来对web应用(比如网站)做自动化测试用的，因为它可以驱动浏览器，诸如Chrome，Firefox，IE等，所以可以较为真实的模拟人自动去点击网站的各个按钮，翻页，填写表单等，这样节省了很多测试时间
<!-- more -->
## selenium安装
> pip3 install selenium 
> pip3 list 查看
## chromedriver安装
### 下载
[chromedriver下载地址|镜像](http://npm.taobao.org/mirrors/chromedriver/) 注意chrome对应的版本
### 配置
* 将可执行文件配置到环境变量或将文件移动到属于环境变量的目录里

```
sudo mv chromedriver /usr/local/bin
或修改~/.profile文件
export PATH="$PATH:/usr/local/bin/chromedriver"
source ~/.profile
```
### 验证
命令行下直接执行chromedriver命令了打印出
> chromedriver
```
Starting ChromeDriver 74.0.3729.6 (255758eccf3d244491b8a1317aa76e1ce10d57e9-refs/branch-heads/3729@{#29}) on port 9515
Only local connections are allowed.
Please protect ports used by ChromeDriver and related test frameworks to prevent access by malicious code.
```
![mac-afacode 2019-05-25 22.31.15-2019525223137](http://imgs.afacode.top/mac-afacode%202019-05-25%2022.31.15-2019525223137.png)
## 简单使用
```
from selenium import webdriver

browser = webdriver.Chrome()

browser.get('https://www.baidu.com')
print(browser.page_source)
browser.close()
```