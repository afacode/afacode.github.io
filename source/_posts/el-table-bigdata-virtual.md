---
layout: electron
title: 解决el-table大数据加载优化
date: 2021-7-28 23:46:57
tags:
  - vue3
  - element-plus
---

## vue3下element-plus解决el-table大数据加载优化
> vue 3.0.5

> element-plus 1.0.2-beta.40

[vue自定义指令版本差异](https://v3.cn.vuejs.org/guide/migration/custom-directives.html#_2-x-%E8%AF%AD%E6%B3%95)

使用自定义指令 局部，也可这是全局 loadmore

``` vue
<template>
  <div id="app">
    <el-table 
      height="300" 
      :data="filteredData" 
      v-loadmore="handelLoadmore"
      :data-size="table?.tableData.length"
      style="width: 100%; border: 2px solid blue" fit border row-key="id"
      stripe :highlight-current-row="true" 
      empty-text="暂无数据">
      <el-table-column prop="name" label="姓名"></el-table-column>
      <el-table-column prop="age" label="年龄"></el-table-column>
      <el-table-column prop="sex" label="性别"></el-table-column>
    </el-table>
  </div>
</template>

<script lang="ts">
  import {
    computed,
    defineComponent,
    reactive,
    ref
  } from 'vue'
  const selfDirectives = {
    loadmore: {
      created(el, binding, vnode, prevVnode) {}, // 新增
      beforeMount(el, binding, vnode) {
        console.log('loadmore beforeMount')
      },
      mounted() {},
      beforeUnmount() {}, // 新增
      unmounted() {},
      // componentUpdated → updated
      updated(el, binding, vnode, oldVnode) {
        // 设置默认溢出显示数量
          var spillDataNum = 30
          // 设置隐藏函数
          var timeout = false
          let setRowDisableNone = function (topNum, showRowNum, binding) {
            if (timeout) {
              clearTimeout(timeout);
            }
            timeout = setTimeout(() => {
              binding.value.call(
                null,
                topNum,
                topNum + showRowNum + spillDataNum
              )
            })
          }
          setTimeout(() => {
            // 其他UI框架关注 修改 获取 attr data属性
            const dataSize = vnode.props["data-size"]
            const oldDataSize = oldVnode.props["data-size"]
            if (dataSize === oldDataSize) return;
            const selectWrap = el.querySelector(".el-table__body-wrapper");
            const selectTbody = selectWrap.querySelector("table tbody");
            const selectRow = selectWrap.querySelector("table tr");
            if (!selectRow) {
              return;
            }
            const rowHeight = selectRow.clientHeight
            let showRowNum = Math.round(selectWrap.clientHeight / rowHeight);
            const createElementTR = document.createElement("tr");
            let createElementTRHeight =
              (dataSize - showRowNum - spillDataNum) * rowHeight;
            createElementTR.setAttribute(
              "style",
              `height: ${createElementTRHeight}px;`
            );
            selectTbody.append(createElementTR);

            // 监听滚动后事件
            selectWrap.addEventListener("scroll", function () {
              let topPx = this.scrollTop - spillDataNum * rowHeight;
              let topNum = Math.round(topPx / rowHeight);
              let minTopNum = dataSize - spillDataNum - showRowNum;
              if (topNum > minTopNum) {
                topNum = minTopNum;
              }
              if (topNum < 0) {
                topNum = 0;
                topPx = 0;
              }
              selectTbody.setAttribute(
                "style",
                `transform: translateY(${topPx}px)`
              );
              createElementTR.setAttribute(
                "style",
                `height: ${
                createElementTRHeight - topPx > 0
                  ? createElementTRHeight - topPx
                  : 0
                }px;`
              )
              setRowDisableNone(topNum, showRowNum, binding);
            })

          })
      }
    }
  }
  export default defineComponent({
    directives: selfDirectives,
    setup() {
      const table = reactive({
        tableData: [],
        currentStartIndex: 0,
        currentEndIndex: 30,
      })

      const getList = () => {
        let cont = 0;
        let tableData = [];
        while (cont < 100000) {
          cont = cont + 1;
          let object = {
            name: "阿发" + cont,
            age: cont,
            sex: '男'
          };
          tableData.push(object);
        }
        setTimeout(() => {
          table.tableData = tableData
        }, 0)
      }
      getList()

      const handelLoadmore = (currentStartIndex, currentEndIndex) => {
        table.currentStartIndex = currentStartIndex;
        table.currentEndIndex = currentEndIndex;
      }

      const filteredData = computed(() => {
        let list = table.tableData.filter((item, index) => {
          if (index < table.currentStartIndex) {
            return false
          } else if (index > table.currentEndIndex) {
            return false
          } else {
            return true;
          }
        })
        return list
      })
      return {
        table,
        filteredData,
        handelLoadmore,
      }
    }
  })
</script>
```

