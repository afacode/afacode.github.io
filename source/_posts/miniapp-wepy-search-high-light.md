---
layout: post
title: 小程序搜索结果全文关键字高亮
date: 2019-07-31 22:44:18
tags:
  - wechat
  - wepy
---

## 问题
小程序动态数据全文关键字高亮

## 解决思路
得到搜索结果，使用数据副本
1. 使用正则匹配高亮关键词,
2. 在切割为数组，
数据显示时， 
3. 将数组循环输出 判断是否有高亮关键词增加特殊样式

## 注意事项
复制数据时注意使用深度拷贝
使用JSON.parse(JSON.stringify(realDataList))拷贝数据特殊数据会有bug
参考[https://www.jianshu.com/p/ad3750e8db26](https://www.jianshu.com/p/ad3750e8db26)

## 代码实现
本人使用 wepy

```
<template>
<view class="section">
    <view class="view-search">
        <input class="view-search-input" value="{{keyName}}" placeholder="输入搜索关键词" bindinput="bindInput" maxlength="11" />
    </view>
      <view wx:for="{{listDataCopy}}" wx:key="*this" style='border:1rpx solid #FAFAFA;'>
            <view class='oneText'>
                  <text wx:for="{{item.fund_name}}" wx:key="{{index}}" class="{{item == keyName ? 'searchHigh' : '' }}">{{item}}</text>
            </view>
            <view class='oneText'>
            <text wx:for="{{item.fund_id}}" wx:key="{{index}}" class="{{item == keyName ? 'searchHigh' : '' }}">{{item}}</text>
            </view>
      </view>
</view>

</template>

<script>
export default class Rice extends wepy.page {
  data = {
    keyName: null,
    listData: [
      {"id":"1", "fund_id": "150084", "fund_name": "广发深证100指数分级B" },
      { "id": "2",  "fund_id": "450011", "fund_name": "国富研究精选混合" },
      { "id": "3", "fund_id": "000008", "fund_name": "嘉实中证500ETF联接" }
    ], // 内容原始数组
    listDataCopy: [], // 用来搜索的复制数组
  }
  methods = {
    bindInput(e) {
      this.keyName = this.trim(e.detail.value)
      this.searchTap()
    },   
  }
  trim(s) { 
    return s.replace(/(^\s*)|(\s*$)/g, "");
  }
  getInf(str, key) {
    return str.replace(new RegExp(`${key}`, 'g'), `%%${key}%%`).split('%%')
  }
  searchTap() {
    const realDataList = this.listData
    let copyDataList =  JSON.parse(JSON.stringify(realDataList))
    for (let i = 0; i < realDataList.length; i++) {
      let single =  realDataList[i]
      let singleCopy = copyDataList[i]
      singleCopy["fund_name"] = this.getInf(single["fund_name"], this.keyName)
      singleCopy["fund_id"] = this.getInf(single["fund_id"], this.keyName)
    }
    this.listDataCopy = copyDataList
  }
  onLoad() {
    this.token_access = this.$parent.globalData.token_access
  }
}
</script>

<style lang="less">
.view-search {
  padding: 12rpx 30rpx;
  box-sizing: border-box;
  position: relative;
}
.view-search-input {
  height: 70rpx;
  line-height: 70rpx;
  border: 2rpx solid #ccc;
  border-radius: 10rpx;
  box-sizing: border-box;
  padding: 0px 70rpx 0px 20rpx;
  font-size: 32rpx;
}
.searchHigh {
  color: #ff0000;
}
.oneText {
    line-height: 50rpx;
    margin: 15;
    text-align: left;
    color: #9B9B9B;
    font-size: 32rpx;
    text-indent:1rem;
}
.currentText {
    color: #0099FF;
}
</style>
```

