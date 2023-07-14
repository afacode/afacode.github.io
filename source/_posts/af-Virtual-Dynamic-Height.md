---
layout: post
title: 虚拟列表（动态高度）
date: 2023-04-08 22:19:30
tags:
  - virtual
  - vue
---
## 虚拟列表（动态高度）

> `afVirtualDynamicHeight.vue`

```vue
<template>
  <div ref="virtualRefs" @scroll="_handleScroll" :style="virtualFixedHeight" class="af-virtual_fixed-height">
    <div class="af-virtual_scroll" :style="virtualScrollHeight"></div>
    <div class="af-virtual_content" :style="virtualTranslate">
      <div
        ref="virtualListRefs"
        class="content-item"
        :data-index="item.$index"
        v-for="item in virtualList"
        :key="`${item[rowKey]}_${item.$index}`"
      >
        <slot :item="item" :index="item.$index"></slot>
      </div>
    </div>
  </div>
</template>

<script>
import { unThrottle } from '@/af3.0/plugins/utils/index.js';
export default {
  name: 'afVirtualDynamicHeight',
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
      default: 15,
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

    // 距离滚动底部 多少px 触发分页
    offsetBottom: {
      type: Number,
      default: 100,
    },
  },
  data() {
    this._virtualRefs = null; // 滚动实例
    this._cacheListOption = []; // 缓存数据的高度
    this._currentStartIndex = 0; // 当前滚动的位置
    this._handleScroll = () => {}; // 节流函数
    return {
      isLoad: true, // 分页节流触发
      endIndex: 0,
      scrollTop: 0,
      startIndex: 0,
      virtualList: [],
      currentIndex: 0,
      dynamicHeight: 0, // 动态高度
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
      return `height:${this.dynamicHeight}px;`;
    },

    // 每一项高度样式
    virtualItemHeight() {
      return `height:${this.itemHeight}px;`;
    },

    // 动画
    virtualTranslate() {
      // 每次滚动的Y
      const y = this.startIndex >= 1 ? this._cacheListOption[this.startIndex - 1].offset : 0;
      return `transform:translate3d(0,${y}px,0); transform 0.01s cubic-bezier(0.25, 0.02, 0.35, 0.89) 0s`;
    },
  },
  watch: {
    list(arr) {
      if (!this.startIndex) {
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
  /**
   * 不固定高度的虚拟列表逻辑
   * 不必在意每一项的高度
   * 只要在意这个滚动列表的高度，在滚动的时候，去计算每一项的高度 ，然后去加剪总高度即可
   */
  mounted() {
    if (!this._virtualRefs) {
      this._virtualRefs = this.$refs.virtualRefs;
    }

    // 有时候父级使用v-if 的时候，第一次watch 并不会执行
    if (Array.isArray(this.list) && this.list.length) {
      this.init();
    }

    // 滚动防抖
    this._handleScroll = unThrottle(this.handleScroll, 180);
  },
  methods: {
    // 初始化数据
    init() {
      this.isLoad = true;
      this.startIndex = 0;
      this.endIndex = this.limit + this.bufferSize;
      this._cacheListOption = this.cacheVirtualList();
      this._virtualRefs && (this._virtualRefs.scrollTop = 0);
      if (Array.isArray(this.list) && this.list.length > 0) {
        this.virtualList = this.getVirtualList();
        this.getDynamicHeight();
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

    // 缓存计算高度
    cacheVirtualList() {
      const arr = [];
      // 注意这块我们用了 <= 是为了渲染x+1个元素用来在让滚动变得连续（永远渲染在判断&渲染x+2）
      for (let i = 0; i < this.virtualTotal; i++) {
        arr.push({
          currentIndex: i, // 当前位置
          isComputed: false, // 是否计算过高度
          height: this.itemHeight, // 默认高度
          offset: (i + 1) * this.itemHeight, // 所在的位置
        });
      }
      this.dynamicHeight = arr[arr.length - 1].offset;
      return arr;
    },

    // 动态计算高度
    getDynamicHeight() {
      this.clearTimeout();
      this._timeout = setTimeout(() => {
        const nodeList = this.$refs.virtualListRefs;
        let index = 0;
        let item = null; // 当前个
        let prevItem = null; // 上一个
        for (let i = 0; i < nodeList.length; i++) {
          if (!nodeList[i]) continue;
          // 当前下标
          index = nodeList[i].getAttribute('data-index');
          // 当前数据
          item = this._cacheListOption[index];
          // 如果计算过，就不计算
          if (item.isComputed) continue;
          // 自身的高度
          item.height = nodeList[i].getBoundingClientRect().height;
          // 上一个
          prevItem = this._cacheListOption[index - 1];
          // 缓存 offset = 当前个height + 上有给的offset
          item.offset = prevItem ? prevItem.offset + item.height : item.height;
          // 缓存起来
          item.isComputed = true;

          // 计算高度
          if (i == nodeList.length - 1) {
            this.getComputedList(index);
          }
        }
        this.clearTimeout();
      }, 0);
    },

    // 重新计算位置
    getComputedList(endIndex = 0) {
      let item = null;
      for (let i = endIndex; i < this._cacheListOption.length; i++) {
        if (!this._cacheListOption[i]) continue;
        item = this._cacheListOption[i];
        item.offset = this._cacheListOption[i - 1].offset + item.height;
        this._isScrollBottom = item.isComputed;
      }
      this.dynamicHeight = this._cacheListOption[this._cacheListOption.length - 1].offset;
    },

    // 滚动获取值
    handleScroll(e) {
      if (e.target !== this._virtualRefs) return false;

      // 是否开启分页
      if (this.isPaging) {
        if (
          this._cacheListOption[this.list.length - 1].offset - (e.target.scrollTop + e.target.offsetHeight) <=
          this.offsetBottom
        ) {
          // 分页节流触发
          if (this.isLoad && this.list.length < this.virtualTotal) {
            this.isLoad = false;
            this.$emit('load', e);
          }
        }
      }

      // 计算当前startIndex
      this._currentStartIndex = this.getStartIndex(e.target.scrollTop);

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
        this.getDynamicHeight();
      }
    },

    // 获取startIndex位置
    getStartIndex(scrollTop = 0) {
      return this.handleBinarySearch(this._cacheListOption, scrollTop);
    },

    // 获取当前展示区域的数据
    getVirtualList() {
      const content = [];
      let item = null;
      // 注意这块我们用了 <= 是为了渲染x+1个元素用来在让滚动变得连续（永远渲染在判断&渲染x+2）
      for (let i = this.startIndex; i <= this.endIndex; ++i) {
        if (!this.list[i]) continue;
        item = this.list[i];
        item.$index = i;
        content.push(item);
      }
      item = null;
      return content;
    },

    // 二分查找位置
    handleBinarySearch(list = [], offset = 0) {
      let low = 0;
      let mid = 0;
      let _offset = 0;
      let high = list.length - 1;

      while (low <= high) {
        // 获取中间数
        mid = Math.floor((high - low) / 2) + low;
        // 中间的位置
        _offset = list[mid].offset;
        // 如果当前滚动和某个位置相等，返回对应坐标
        if (_offset === offset) {
          return mid;
        } else if (_offset < offset) {
          // 如果当前位置小于滚动的位置，那就往后找
          low = mid + 1;
        } else {
          // 如果滚动小于当前位置，那就往前找
          high = mid - 1;
        }
      }
      // 最后返回
      return high < 0 ? 0 : high;
    },

    clearTimeout() {
      if (this._timeout) {
        clearTimeout(this._timeout);
        this._timeout = null;
      }
    },
  },
  beforeDestroy() {
    this._virtualRefs = null; // 滚动实例
    this._handleScroll = null; // 节流函数
    this._cacheListOption = []; // 缓存数据的高度
    this._currentStartIndex = 0; // 当前滚动的位置
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

  .af-virtual_scroll {
    position: relative;
  }

  .af-virtual_content {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-content: flex-start;
    overflow: hidden;
    will-change: transform;

    .content-item {
      box-sizing: border-box;
      overflow: hidden;
      background: transparent;
    }
  }
}
</style>

```

