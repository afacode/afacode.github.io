---
layout: post
title: audio打开到上次播放的位置
date: 2020-03-15 22:28:20
tags:
---

## 需求
音频打开播放过后，再次进入需要跳到上次播放的位置

## 实现
使用vue
```
<template >
  <div class="main-box">
    <audio 
      ref="audio" 
      controls="controls"
      :src="SRC"
      @timeupdate="timeupdate" 
      @canplay="canplay"
      autoplay="autoplay">
    </audio>

  </div>

</template>

<script>
export default {
  name: 'reportDetails',
  data() {
    return {
      TYPE: "",
      SRC: "",
      TITLE: "其他",
      first: true
    }
  },
  mounted() {
    this.TYPE = this.$route.query.type;
    this.SRC = this.$route.query.src;
    this.TITLE = this.$route.query.name;
  },
  methods: {
    timeupdate(e) {
      if (localStorage.getItem(e.target.currentSrc)) {
        if (this.first && e.target.currentTime < Number(localStorage.getItem(e.target.currentSrc))) {
          this.$refs.audio.play()
          this.$refs.audio.currentTime = localStorage.getItem(e.target.currentSrc) + ''
        }
      }
      localStorage.setItem(e.target.currentSrc, e.target.currentTime);
      this.first = false
    }
  }
}
</script>

```
## 参考
[https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/audio](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/audio)

[https://www.yuque.com/chenshier/chuyi/cl0x98](https://www.yuque.com/chenshier/chuyi/cl0x98)


