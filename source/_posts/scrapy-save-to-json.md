---
layout: post
title: scrapy导出JSON格式
date: 2019-06-18 23:13:34
tags:
  - scrapy 
  - json
---
## 创建json保存的pipeline
```
import json
import codecs # 可以处理好编码，避免各种编码繁杂工作

class JsonPipeline(object):
  def __init__(self):
    self.file = codecs.open('demo.json', 'w', encoding='utf-8')
  
  def process_item(self, item, spider):
    line = json.dumps(dict(item), ensure_ascii=False) + "\n"
    self.file.write(line)
    return item
  
  def spider_closed(self, spider):
    self.file.close()

```

## Scrapy自带写入json

scrapy.exports中提供的导出方式:
```
[
  'BaseItemExporter', 
  'PprintItemExporter', 
  'PickleItemExporter',        
  'CsvItemExporter', 
  'XmlItemExporter', 
  'JsonLinesItemExporter',     
  'JsonItemExporter', 
  'MarshalItemExporter'
]
```


```
from scrapy.exporters import JsonItemExporter

def __init__(self): 
  self.file = open('demo.json', 'wb') 
  self.exporter = JsonItemExporter(self.file, encoding="utf-8", ensure_ascii=False) 
  self.exporter.start_exporting() 

def start_exporting(self):
  self.file.write(b"[\n")

def finish_exporting(self):
  self.file.write(b"\n]")

def close_spider(self, spider): 
  self.exporter.finish_exporting() 
  self.file.close() 

def process_item(self, item, spider): 
  self.exporter.export_item(item) 
  return item

```

> 在settings 设置 ITEM_PIPELINES 开启