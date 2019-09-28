#!/bin/bash

hexo clean

hexo g

hexo d 

echo -e "\033[32m\n$(date)\nn文章发布成功\n\033[0m"