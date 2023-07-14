---
layout: post
title: 虚拟列表（固定高度）
date: 2023-03-28 16:19:30
tags:
  - virtual
  - vue
---

> `afVirtualFixedHeight.vue`

```vue
<template>
  <div ref="virtualRefs" @scroll="_handleScroll" :style="virtualFixedHeight" class="af-virtual_fixed-height">
    <div class="af-virtual_scroll" :style="virtualScrollHeight"></div>
    <div class="af-virtual_content" :style="virtualTranslate">
      <div
        class="content-item"
        v-for="item in virtualList"
        :style="virtualItemHeight"
        :data-index="item.$index"
        :key="`${item[rowKey]}_${item.$index}`"
      >
        <slot :item="item" :index="item.$index"></slot>
      </div>
    </div>
  </div>
</template>

<script>
import { unThrottle } from '@/**/plugins/utils/index.js';
export default {
  name: 'afVirtualFixedHeight',
  props: {
    // 列表数据
    list: {
      type: Array,
      required: true,
    },

    // 列表高度
    virtualMaxHeight: {
      type: String,
      default: '250px',
    },

    // 数据总数量
    virtualTotal: {
      type: Number,
      required: true,
    },

    // 单个高度
    itemHeight: {
      type: Number,
      default: 40,
    },

    // 默认展示条数
    limit: {
      type: Number,
      default: 10,
    },

    // 唯一标识
    rowKey: {
      type: String,
      required: true,
    },

    // 距离顶部缓冲区条数
    bufferSize: {
      type: Number,
      default: 5,
    },

    // 是否开启分页
    isPaging: {
      type: Boolean,
      default: false,
    },

    // 距离底部 多少 距离，触发分页
    offsetBottom: {
      type: Number,
      default: 100,
    },
  },
  data() {
    this._virtualRefs = null; // 滚动实例
    this._currentStartIndex = 0; // 当前滚动的位置
    this._handleScroll = () => {}; // 节流函数
    return {
      endIndex: 0,
      scrollTop: 0,
      startIndex: 0,
      virtualList: [],
      currentIndex: 0,
      isLoad: true, // 分页节流触发
    };
  },
  computed: {
    // 当前list长度
    getListCount() {
      return (Array.isArray(this.list) && this.list.length) || 0;
    },

    // 滚动可视区最大高度
    virtualFixedHeight() {
      return `max-height:${this.virtualMaxHeight};`;
    },

    // 滚动的高度
    virtualScrollHeight() {
      if (this.isPaging) {
        return `height:${this.list.length * this.itemHeight}px;`;
      }
      return `height:${this.virtualTotal * this.itemHeight}px;`;
    },

    // 每一项高度样式
    virtualItemHeight() {
      return `height:${this.itemHeight}px;`;
    },

    // 动画
    virtualTranslate() {
      if (this.scrollTop <= 0) return 'transform:translate3d(0,0,0)';
      const { itemHeight, bufferSize, currentIndex, scrollTop } = this;
      // 当前滑动offset - 当前被截断的（没有完全消失的元素）距离 - 头部缓冲区距离
      const y = scrollTop - (scrollTop % itemHeight) - Math.min(currentIndex, bufferSize) * itemHeight;
      return `transform:translate3d(0,${y}px,0); transform 0.01s cubic-bezier(0.25, 0.02, 0.35, 0.89) 0s`;
    },
  },
  watch: {
    list(arr) {
      if (!this.scrollTop && !this.startIndex) {
        if (!Array.isArray(arr) || arr.length <= 0) {
          this.virtualList = [];
        } else {
          this.init();
        }
      } else {
        this.isLoad = true;
      }
    },
  },
  mounted() {
    if (!this._virtualRefs) {
      this._virtualRefs = this.$refs.virtualRefs;
    }

    // 有时候父级使用v-if 的时候，第一次watch 并不会执行
    if (Array.isArray(this.list) && this.list.length) {
      this.init();
    }

    // 滚动防抖
    this._handleScroll = unThrottle(this.handleScroll, 150);
  },
  methods: {
    // 初始化数据
    init() {
      this.scrollTop = 0;
      this.startIndex = 0;
      this.isLoad = true;
      this.endIndex = this.limit + this.bufferSize;
      this._virtualRefs && (this._virtualRefs.scrollTop = 0);
      if (Array.isArray(this.list) && this.list.length > 0) {
        this.virtualList = this.getVirtualList();
      }

      // 判断数据是否相等
      if (!this.isPaging && this.list.length - this.virtualTotal < 0) {
        console.error(
          `当前不是分页获取数据，传入数据【list：${this.list.length}】与数据总数【virtualTotal：${this.virtualTotal}】不相等，请注意查看数据是否正确`
        );
      }
    },

    // 搜索初始化
    initSearch() {
      this.scrollTop = 0;
      this.startIndex = 0;
      this.isLoad = false;
      this.endIndex = this.limit + this.bufferSize;
      this._virtualRefs && (this._virtualRefs.scrollTop = 0);
    },

    // 滚动获取值
    handleScroll(e) {
      if (e.target !== this._virtualRefs) return false;
      this.scrollTop = e.target.scrollTop || 0;
      // 是否开启分页
      if (this.isPaging) {
        const contentLayout = this.getListCount * this.itemHeight;
        if (contentLayout - (e.target.scrollTop + e.target.offsetHeight) <= this.offsetBottom) {
          // 分页节流触发
          if (this.isLoad) {
            this.isLoad = false;
            this.$emit('load', e);
          }
        }
      }

      // 计算当前startIndex
      this._currentStartIndex = Math.floor(this.scrollTop / this.itemHeight);

      // 如果currentStartIndex 和 startIndex 不同（我们需要更新数据了）
      if (this._currentStartIndex !== this.currentIndex) {
        // 保存当前第一位
        this.currentIndex = this._currentStartIndex;

        // 重新计算开始位置 - 头部缓冲区位置
        this.startIndex = Math.max(this._currentStartIndex - this.bufferSize, 0);

        // 结束位置 = 当前位置  + 显示条数 + 缓冲区条数
        this.endIndex = Math.min(this._currentStartIndex + this.limit + this.bufferSize, this.getListCount - 1);

        // 获取数据
        this.virtualList = this.getVirtualList();
      }
    },

    // 获取当前展示区域的数据
    getVirtualList() {
      const content = [];
      // 注意这块我们用了 <= 是为了渲染x+1个元素用来在让滚动变得连续（永远渲染在判断&渲染x+2）
      for (let i = this.startIndex; i <= this.endIndex; ++i) {
        if (!this.list[i]) continue;
        this.list[i].$index = i;
        content.push(this.list[i]);
      }
      return content;
    },
  },
  beforeDestroy() {
    this._handleScroll = null;
    this._virtualRefs = null;
    this._currentStartIndex = 0;
  },
};
</script>

<style lang="scss" scoped>
.af-virtual_fixed-height {
  position: relative;
  width: 100%;
  height: 100%;
  flex: 1;
  overflow: hidden;
  overflow-y: auto;
  will-change: transform;

  .af-virtual_scroll {
    position: relative;
  }

  .af-virtual_content {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    overflow: hidden;

    .content-item {
      box-sizing: border-box;
      overflow: hidden;
      background: transparent;
    }
  }
}
</style>

```

