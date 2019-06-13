---
layout: post
title: selenium 不加载图片
date: 2019-06-13 23:11:14
categories: 
  - python
tags:
  - python
  - selenium
---
## python selenium 不加载图片
```
from selenium import webdriver

chrome_options = webdriver.ChromeOptions()
prefs = {"profile.managed_default_content_settings.images":2}
chrome_options.add_experimental_option("prefs",prefs)
            
driver = webdriver.Chrome(chrome_options=chrome_options)
```