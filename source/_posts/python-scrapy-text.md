---
layout: post
title: scrapy爬虫总体笔记记录
date: 2019-05-27 23:53:25
categories: 
  - python
tags:
  - python
  - scrapy
  - mysql
  - mongodb
---
scrapy爬虫 - 记忆笔记 - 只供自己查找
<!-- more -->

## 安装
`pip3 install scrapy`
## 使用
### 创建项目
`scrapy startproject example`
### 创建爬虫
`scrapy genspider book_spider`
### 运行 
` scrapy crawl book_spider -o books.csv`

## 选择器(提取数据)
### css
[css选择器](http://www.scrapyd.cn/doc/146.html)
```
# 选中所有的img
>>> response.css('img')
# 选中div后代中的img（后代元素包括子代、孙代等）
>>> response.css('div img')
# 选中body子元素中的div元素
>>> response.css('body>div')
# 选中包含style属性的元素
>>> response.css('[style]')
# 选中属性id值为images-1的元素
>>> response.css('[id=images-1]')
# 选中CLASS属性包含img的a元素
>>> response.css('a.img')
# 选中CLASS属性包含img的元素
>>> response.css('.img')
# 选中所有a的文本
>>> response.css('a::text').extract()
# 选中所有a的href属性文本 extract_first()
>>> response.css('a::attr(href)').extract()
```
### regx
### Splash
Splash 是 Scrapy 官方推荐的 JavaScript 渲染引擎，是一款轻量级的无界面浏览器，类似于 PhantomJS
> pip3 install scrapy-splash

* SplashRequest,用户只需使用scrapy_splash.SplashRequest（替代scrapy.Request）提交请求即可
```
from scrapy_splash import SplashRequest
SplashRequest()
```
* 下面是 SplashRequest 构造器方法中的一些常用参数。 
    * ① url ：与scrapy.Request中的url相同，也就是待爬取页面的url（注意，不是Splash服务器地址）。
    * ② headers: 与scrapy.Request中的headers相同。
    * ③ cookies：与scrapy.Request中的cookies相同。
    * ④ args：传递给Splash的参数（除url以外），如wait、timeout、images、js_source等。

---
* 创建项目
* setting.py
```
# 1. Splash服务器地址
SPLASH_URL = 'http://localhost:8050'

# 2. 开启Splash的两个下载中间件并调整HttpCompressionMiddleware的次序
DOWNLOADER_MIDDLEWARES = {
'scrapy_splash.SplashCookiesMiddleware': 723,
'scrapy_splash.SplashMiddleware': 725,
'scrapy.downloadermiddlewares.httpcompression.HttpCompressionMiddleware': 810,
}

# 3. 设置去重过滤器
DUPEFILTER_CLASS = 'scrapy_splash.SplashAwareDupeFilter'

# 4. 用来支持cache_args（可选）
SPIDER_MIDDLEWARES = {
'scrapy_splash.SplashDeduplicateArgsMiddleware': 100,
}
```
* 修改Spider
`# 把 ScrapyRequest(url) 改为SplashRequest(url, args={'images':0,'timeout'=3})`


### xpath
[xpath](http://www.scrapyd.cn/doc/186.html)
## spider 函数解析
### 请求(打开页面)   
```
...
class simpleUrl(scrapy.Spider):
    name = "simpleUrl"
    start_urls = ['http://books.toscrape.com/']
    或者
    def start_requests(self):
        urls = [ #爬取的链接由此方法通过下面链接爬取页面
    		 'http://lab.scrapyd.cn/page/1/',
    		 'http://lab.scrapyd.cn/page/2/',
    	]
    	for url in urls:
    		#发送请求
    		 yield scrapy.Request(url=url, callback=self.parse)
    
    def parse(self, response):
...
```
### 抓取数据
* 有些数据信息需要提取两个页面才能完成，那么如何把上一个def中的数据，传入下一个def中呢
```
# 构造字典 meta={'_book_item':book_item}，通过scrapy.Request传入
# 下一个def 通过book_item = response.meta['_book_item']获得数据
def parse(self, response):
    ...
    yield scrapy.Request(url, headers= {'User-Agent':'Mozilla/5.0'}, callback=self.book_parse, meta={'_book_item':book_item})

def parse_book(self, response):
    book_item = response.meta['_book_item']
```
* scrapy 爬网站 显示 Filtered offsite request to 错误

官方对这个的解释，是你要request的地址和allow_domain里面的冲突，从而被过滤掉。可以停用过滤功能
`yield Request(url, callback=self.parse_item, dont_filter=True)`

## 中间件(pipeline)
1. Item Pipeline 可以处理、存储数据
2. 处理从 spider 发送的，由Item 封装的数据
3. 页面数据抓取用spider解析，其他用Item Pipeline
4. 主要的三个模块： 
    * ① process_item(item, spider)：处理数据 
    * ② open_spider(self, spider)：打开文件或数据库 
    * ③ close_spider(self, spider)：关闭文件或数据库
    * 
5. 处理数据步骤： 
    * ① 打开pipelines.py，修改文件 
    * ② 打开setting.py，修改配置文件

### 图片下载中间件
打开`pipeline.py`进行中间件编写，这里的话主要继承了scrapy的：`ImagesPipeline`这个类，我们需要在里面实现：`def get_media_requests(self, item, info)`这个方法，这个方法主要是把蜘蛛yield过来的图片链接执行下载
```
class ImagespiderPipeline(ImagesPipeline):

    def get_media_requests(self, item, info):
        # 循环每一张图片地址下载，若传过来的不是集合则无需循环直接yield
        for image_url in item['imgurl']:
            yield Request(image_url)
        
```
> 设置，启动图片下载 `settings`

```
#图片存储位置
IMAGES_STORE = 'D:\ImageSpider'
#启动图片下载中间件
ITEM_PIPELINES = {
   'ImageSpider.pipelines.ImagespiderPipeline': 300,
}
```
### 图片重命名、放入不同文件夹
`ImagesPipeline`的一些实现，你会发现里面有这么一个方法：`def file_path(self, request, response=None, info=None)` 这个方法便是图片重命名以及目录归类的方法，我们只需要重写里面的一些内容，便可轻松实现scrapy图片重命名，图片保存不同目录
```
import re
class ImagespiderPipeline(ImagesPipeline):
    ...
    # 重命名，若不重写这函数，图片名为哈希，就是一串乱七八糟的名字
    def file_path(self, request, response=None, info=None):

        # 提取url前面名称作为图片名。
        image_guid = request.url.split('/')[-1]
        # 接收上面meta传递过来的图片名称
        name = request.meta['name']
        # 过滤windows字符串，不经过这么一个步骤，你会发现有乱码或无法下载
        name = re.sub(r'[？\\*|“<>:/]', '', name)
        # 分文件夹存储的关键：{0}对应着name；{1}对应着image_guid
        filename = u'{0}/{1}'.format(name, image_guid)
        return filename
```
### 图片防盗链下载 `middlewares.py`
```
from scrapy import signals


class AoisolasSpiderMiddleware(object):

    def process_request(self, request, spider):
        '''设置headers和切换请求头'''
        referer = request.url
        if referer:
            request.headers['referer'] = referer
```

### mysql 
 版本 `>3.4` PyMySQL，  `2 - <3.4` MySQLdb 


> pip3 install pymysql

* 必须实现 `process_item(self, item, spider)` 方法

这个方法有两个参数，一个是item，一个是spider。item就是爬取到的数据，执行完数据库插入之后，需要执行返回，也就是需要：return item，无论你是插入mysql、mongodb还是其他数据库，都必须实现这么一个方法
* `open_spider(self, spider)` 爬虫打开时执行
* `close_spider(self, spider)` 爬虫关闭时执行
    > 根据自己的需要，按需实现，并非必须方法！

> 新建 MySQLPipline.py mysql中间件

```
import pymysql.cursors


class MySQLPipeline(object):
    def __init__(self):
        # 连接数据库
        self.connect = pymysql.connect(
            host='127.0.0.1',  # 数据库地址
            port=3306,  # 数据库端口
            db='scrapyMysql',  # 数据库名
            user='root',  # 数据库用户名
            passwd='root',  # 数据库密码
            charset='utf8',  # 编码方式
            use_unicode=True)
        
        # 通过cursor执行增删查改
        self.cursor = self.connect.cursor()

    def process_item(self, item, spider):
        self.cursor.execute(
            """insert into chuanke(name, type, view, price ,teacher, url)
            value (%s, %s, %s, %s, %s, %s)""",#纯属python操作mysql知识，不熟悉请恶补
            (item['name'],# item里面定义的字段和表字段对应
             item['type'],
             item['view'],
             item['price'],
             item['teacher'],
             item['url']))
             
        # 提交sql语句
        self.connect.commit()
        
        return item  # 必须实现返回
```
> settings.py启用MySQLPipline

```
ITEM_PIPELINES = {
    'scrapyMysql.MySQLPipeline.MySQLPipeline': 1,
     #格式为：'项目名.文件名.类名'：优先级（越小越大）
}
```
### mongodb
> pip3 install pymongo
* 创建Pipeline,类似mysql。 InputmongodbPipeline

```
import pymongo
class InputmongodbPipeline(object):

    def __init__(self):
        # 建立MongoDB数据库连接
        client = pymongo.MongoClient('127.0.0.1', 27017)
        # 连接所需数据库,ScrapyChina为数据库名
        db = client['ScrapyChina']
        # 连接所用集合，也就是我们通常所说的表，mingyan为表名
        self.post = db['mingyan']

    def process_item(self, item, spider):
        postItem = dict(item)  # 把item转化成字典形式
        self.post.insert(postItem)  # 向数据库插入一条记录
        return item  # 会在控制台输出原item数据，可以选择不写
```
> setting.py

```
ITEM_PIPELINES = {
   'InputMongodb.inputMongodbPipeline.InputmongodbPipeline': 300,
}
```
scrapy存入mongodb比起存入mysql要简单得多，我们不用创建表，只需在程序里面创建相应库名、表名即可

## 部署 scrapyd 
在每台Linux机子上安装好scrapyd，并开启scrapyd服务；然后我们在windows客户端，也就是开发爬虫的这台电脑，安装上scrapyd的客户端`scrapyd-client`，通过scrapyd-client把不同网站的爬虫发送到不同的服务器，然后我们只需在windows上就行**修改、启动、停止**爬虫操作，更自动化的是scrapyd给我提供了很python接口，我们可以通过python编程控制蜘蛛的运行
> pip3 install scrapyd-client 安装在开发机

* scrapyd的话一般安装在Linux上面，负责开启Linux端口，供scrapyd-client调用
> pip3 install scrapyd 




