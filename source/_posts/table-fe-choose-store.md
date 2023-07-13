---
layout: post
title: 基于el-table前端存储选中行一起提交数据
date: 2022-06-22 23:21:45
categories: 
  - tools
tags:
  - el-table
  - javascript
---

## 需求
> el-table选中数据😓分页切换，改变搜索条件等操作原有的选项不会保存。需满足原油选中数据能够记录保存。

## 代码实现
> 前端自己维护选中数据，分装一个

tableSelection.js

```js
import { Loading } from 'element-ui';
import { uniDebounce } from '@/components/plugins/utils/index.js';
class TableSelection {
  constructor(options) {
    // 记录选中的参数
    this.cacheSelection = {};
    // 记录选中的数量
    this.cacheSelectionTotal = 0;
    // 数据的唯一key
    this.rowKey = options.rowKey || 'storeId';
    // 接口返回的唯一key 例如： res.data.list 如果没有默认给''
    this.dataKey = options.dataKey || '';
    // 接口请求
    this.getTableList = options.getTableList || null;
    // 总条数
    this.pageTotal = 0;
    // 表格数据
    this.tableData = [];
    // table实例
    this.tableRefs = null;
    // 接口参数
    this.tableSearch = {};
    // 是否全选
    this.isCheckAll = false;
    // 是否半选
    this.isIndeterminate = false;
    // 记录反选
    this.invertSelection = {};
    // 是否是搜索
    this.isSearch = false;
    // 定时器
    this.timer = null;
    // 记录搜索的全选状态
    this.invertSearchTotal = null;
    // 记录当前分页
    this.invertPage = [];
    // 记录当前是否初始化过
    this.isInvertInit = true;
    // 记录搜索的全选
    this.invertSearchList = [];
    // loading 实例
    this.loading = null;
    // loading DOM
    this.loadTarget = options.loadTarget || null;
  }

  /**
   * 初始化数据
   * @param {*} params
   */
  init({ isFirst, tableData, echoList, tableRefs, params, pageTotal, callback }) {
    try {
      this.tableData = tableData;
      this.tableRefs = tableRefs;
      this.tableSearch = { ...params };
      !this.pageTotal && (this.pageTotal = pageTotal);
      // 第一次初始化,需要回显数据，如果不需要不需要走下面初始化
      if (isFirst) {
        this._initFirstSelection(echoList, callback);
      } else {
        this._initSelection(params, pageTotal, callback);
      }
    } catch (error) {
      console.error(error);
      alert(error.message || '初始化失败-init');
    }
  }

  /**
   * 全选事件
   * @param {Boolean} isCheck 是否全选
   * @param {Function} fn 回调
   */
  handleCheckAll = uniDebounce(function (isCheck = false, fn = null) {
    try {
      this.isCheckAll = isCheck;
      // 修改状态
      if (isCheck) {
        this.isIndeterminate = false;
      }

      // 如果是全选
      if (isCheck && !this.isIndeterminate) {
        console.log('----------全选--------');
        this._handleCacheSearchList(fn);
        return false;
      }

      // 全选后反选
      if (this.isIndeterminate) {
        console.log('----------反选--------');
        this._handleCheckAllTable(fn);
        fn && fn(this._handleCallBack());
        return false;
      }

      // 如果是搜索全选，反选
      if (this.isSearch && this.cacheSelectionTotal >= this.pageTotal && !isCheck) {
        this._getSearchNoSelection(fn);
        return false;
      }

      // 取消全选
      console.log('取消全选');
      this._handleNoCheckAllTable(fn);
    } catch (error) {
      console.error(error);
      alert(error.message || '全选事件报错：handleCheckAll');
    }
  }, 300);

  /**
   * 单选事件
   * @param {Array} selection 选中的数据
   * @param {Object} row 选中的单个
   * @param {Function} fn 回调
   */
  handleCheckSingle = uniDebounce(function (selection, row, fn) {
    try {
      if (this.cacheSelection[row[this.rowKey]]) {
        this.cacheSelection[row[this.rowKey]] = null;
        this.invertSelection[row[this.rowKey]] = row;
        this.cacheSelectionTotal -= 1;
        this.isSearch && (this.invertSearchTotal += 1);
      } else {
        this.cacheSelection[row[this.rowKey]] = row;
        this.invertSelection[row[this.rowKey]] = null;
        this.cacheSelectionTotal += 1;
        this.isSearch && (this.invertSearchTotal -= 1);
      }

      this._handleCheckStatus(this.cacheSelectionTotal, fn);
    } catch (error) {
      console.error(error);
      alert(error.message || '单选事件报错：handleCheckSingle');
    }
  }, 300);

  /**
   * 当前页选中事件
   * @param {Array} selection 选中的数据
   * @param {Function} fn 回调
   */
  handleCheckPageAll = uniDebounce(async (selection, fn) => {
    try {
      if (selection.length > 0) {
        selection.forEach(row => {
          if (!this.cacheSelection[row[this.rowKey]]) {
            this.cacheSelection[row[this.rowKey]] = row;
            this.isSearch && (this.invertSearchTotal -= 1);
          }
          this.invertSelection[row[this.rowKey]] = null;
        });
      } else {
        this.tableData.forEach(row => {
          if (this.cacheSelection[row[this.rowKey]]) {
            this.cacheSelection[row[this.rowKey]] = null;
            this.isSearch && (this.invertSearchTotal += 1);
          }
          this.invertSelection[row[this.rowKey]] = row;
        });
      }

      this._toCalculateSelectionTotal().then(total => {
        this._handleCheckStatus(total, fn);
      });
    } catch (error) {
      console.error(error);
      alert(error.message || '当前页选中事件报错：handleCheckPageAll');
    }
  }, 300);

  /**
   * 确定返回
   * @param {*} fn
   */
  handleSubmit(fn, isReset = false) {
    try {
      if (this.cacheSelectionTotal <= 0) {
        fn && fn([]);
        this._handleNoCheckAllTable();
        return false;
      }
      const list = [];
      Object.keys(this.cacheSelection).forEach(key => {
        if (this.cacheSelection[key] && !this.invertSelection[key]) {
          list.push(this.cacheSelection[key]);
        }
      });
      fn && fn(list);
      if (isReset) return false;
      this._handleNoCheckAllTable();
      this.invertPage = [];
    } catch (error) {
      console.error(error);
      alert(error.message || '数据保存失败');
    }
  }

  /**
   * 下拉返回
   */
  handleSelect(fn) {
    try {
      if (this.cacheSelectionTotal <= 0) {
        fn && fn([]);
        return false;
      }
      const list = [];
      Object.keys(this.cacheSelection).forEach(key => {
        if (this.cacheSelection[key] && !this.invertSelection[key]) {
          list.push(this.cacheSelection[key]);
        }
      });
      fn && fn(list);
    } catch (error) {
      console.error(error);
      alert(error.message || '数据保存失败');
    }
  }

  /**
   * 销毁数据
   */
  destroy() {
    console.warn('销毁数据');
    this.reset();
    this.loading = null;
    this.tableRefs = null;
    this.loadTarget = null;
    this.tableSearch = {};
  }

  /**
   * 重置数据
   */
  reset() {
    console.warn('重置数据');
    this.cacheSelection = {};
    this.cacheSelectionTotal = 0;
    this.pageTotal = 0;
    this.tableData = [];
    this.isCheckAll = false;
    this.isIndeterminate = false;
    this.invertSelection = {};
    this.isSearch = false;
    this.invertSearchTotal = null;
    this.invertPage = [];
    this.isInvertInit = true;
    this._clearTimeout();
  }

  /**
   * 函数带_ 全都是私有方法
   */

  /**
   * 需要回显数据，第一次初始化
   */
  async _initFirstSelection(echoList, callback) {
    try {
      this.invertSearchList = [];
      this.cacheSelection = await this._formatArrayToObject(this.rowKey, echoList);
      this.cacheSelectionTotal = (Array.isArray(echoList) && echoList.length) || 0;
      this.isCheckAll = this.cacheSelectionTotal === this.pageTotal && this.pageTotal > 0;
      this.isIndeterminate = this.cacheSelectionTotal > 0 && this.cacheSelectionTotal < this.pageTotal;
      if (Array.isArray(echoList) && echoList.length > 0) {
        this._handleInitCheck();
      }
      callback && callback(this._handleCallBack());
    } catch (error) {
      console.error(error);
      alert(error.message || '第一次初始化：_initFirstData');
    }
  }

  /**
   * 初始化数据
   */
  _initSelection(params, pageTotal, callback) {
    try {
      // 判断
      this.isSearch = !(this.pageTotal === pageTotal);
      // 搜索条件
      if (this.isSearch) {
        this.isCheckAll = false;
        this.isIndeterminate = !!this.cacheSelectionTotal;
        // console.log('-------------',this.cacheSelectionTotal);
        this.isInvertInit = this.invertPage.indexOf(params.pageIndex) !== -1;
        this.invertPage.push(params.pageIndex);
        this.isInvertInit && pageTotal && this._handleCheckStatus(this.cacheSelectionTotal, callback);

        // 记录搜索的数据总数
        if (params.pageIndex === 1) {
          this.invertSearchTotal = pageTotal;
          this.invertPage = [];
        }
      } else {
        // 非搜索条件
        this.invertPage = [];
        this.isInvertInit = false;
        this.invertSearchTotal = null;
        this.isCheckAll = this.cacheSelectionTotal >= this.pageTotal && this.cacheSelectionTotal > 0;
        this.isIndeterminate = this.pageTotal > this.cacheSelectionTotal && this.cacheSelectionTotal > 0;
        callback && callback(this._handleCallBack());
      }

      // 选中
      this._handleInitCheck();
    } catch (error) {
      console.error(error);
      alert(error.message || '初始化：_initSelection');
    }
  }

  /**
   * 判断是全选还是单个选择
   */
  _handleInitCheck() {
    this._clearTimeout();
    this.timer = setTimeout(() => {
      // console.log(this.isCheckAll, '全选还是单选');
      if (this.isCheckAll) {
        this._handleCheckAllTable();
      } else {
        this._handleCheckSingleTable();
      }
      this._clearTimeout();
    }, 0);
  }

  /**
   * 清除定时器
   */
  _clearTimeout() {
    if (this.timer) {
      clearTimeout(this.timer);
      this.timer = null;
    }
  }

  /**
   * 全选
   */
  _handleCheckAllTable(fn) {
    try {
      const selection = this.tableData;
      if (!Array.isArray(selection) || selection.length <= 0) return false;
      if (!this.isCheckAll) {
        this._getSearchNoSelection(fn);
        return;
      }
      for (let i = 0; i < selection.length; i++) {
        if (!this.cacheSelection[selection[i][this.rowKey]]) continue;
        this.cacheSelection[selection[i][this.rowKey]] = selection[i];
        this.tableRefs && this.tableRefs.toggleRowSelection(selection[i], true);
      }
    } catch (error) {
      alert(error.message || '全选报错：_handleCheckAllTable');
    }
  }

  /**
   * 单个选中
   */
  _handleCheckSingleTable() {
    try {
      const selection = this.tableData;
      if (!Array.isArray(selection) || selection.length <= 0) return false;
      for (let i = 0; i < selection.length; i++) {
        if (!this.cacheSelection[selection[i][this.rowKey]]) continue;
        this.tableRefs && this.tableRefs.toggleRowSelection(selection[i], true);
        // 搜索记录当前 选中
        !this.isInvertInit && (this.invertSearchTotal -= 1);
      }
    } catch (error) {
      console.error(error);
      alert(error.message || '单选报错：_handleCheckSingleTable');
    }
  }

  /**
   * 取消全选
   */
  _handleNoCheckAllTable(fn) {
    try {
      if (this.isSearch) {
        // console.log(this.invertSearchList.length, '---------取消搜索全选----------');
        this.isCheckAll = false;
        this.isIndeterminate = this.cacheSelectionTotal > 0;
        // 如果当前是搜素全选，然后反选
        if (this.cacheSelectionTotal - this.invertSearchTotal <= 0 && !this.invertSearchList.length) {
          this.isIndeterminate = false;
          this.cacheSelection = {};
          this.cacheSelectionTotal = 0;
        } else {
          this.cacheSelectionTotal = this.cacheSelectionTotal - this.invertSearchList.length;
          this.invertSearchList.forEach(item => {
            this.cacheSelection[item[this.rowKey]] = null;
          });
          this.invertSearchList = [];
          this.isIndeterminate = this.cacheSelectionTotal > 0;
        }
      } else {
        // console.log('---------取消全选----------');
        this.isCheckAll = false;
        this.isIndeterminate = false;
        this.cacheSelection = {};
        this.invertSelection = {};
        this.cacheSelectionTotal = 0;
      }
      this.tableRefs && this.tableRefs.clearSelection();
      fn && fn(this._handleCallBack());
    } catch (error) {
      console.error(error);
      alert(error.message || '取消全选报错：_handleNoCheckAllTable');
    }
  }

  /**
   * 搜索如果是全选，就请求所有搜索数据
   * @param {*} fn 回调更新
   */
  async _handleCacheSearchList(fn) {
    try {
      let selection = [];
      // 搜索全选不缓存
      if (!this.isSearch && this.isCheckAll && this.invertSearchList.length >= this.pageTotal && this.pageTotal) {
        selection = this.invertSearchList;
      } else {
        selection = await this._getTableList();
        // if (this.tableRefs) {
        //   this.invertSearchList = this.isSearch ? [] : selection;
        //   // /!this.tableRefs &&
        // } else
        // 如果是全选,还是搜索,缓存
        if (this.isCheckAll && this.isSearch) {
          this.invertSearchList = selection;
        }
        // console.log(this.invertSearchList.length, '----------------');
      }
      // console.log(selection);
      for (let i = 0; i < selection.length; i++) {
        this.cacheSelection[selection[i][this.rowKey]] = selection[i];
        // 清除
        if (this.invertSelection[selection[i][this.rowKey]]) {
          this.invertSelection[selection[i][this.rowKey]] = null;
        }
      }
      this._handleCheckAllTable();
      this._toCalculateSelectionTotal().then(() => {
        fn && fn(this._handleCallBack());
      });
    } catch (error) {
      console.error(error);
      alert(error.message || '搜索全选报错：_handleCacheSearchList');
    }
  }

  /**
   * 全选后，搜索反选
   */
  _getSearchNoSelection(fn) {
    try {
      this._getTableList().then(selection => {
        for (let i = 0; i < selection.length; i++) {
          if (this.cacheSelection[selection[i][this.rowKey]]) {
            this.cacheSelectionTotal -= 1;
            this.cacheSelection[selection[i][this.rowKey]] = null;
          }
        }

        this.isCheckAll = false;
        this.isIndeterminate = this.cacheSelectionTotal > 0;
        this.invertSearchTotal = selection.length;
        this.tableRefs && this.tableRefs.clearSelection();
        fn && fn(this._handleCallBack());
        // this._handleNoCheckAllTable(fn);
      });
    } catch (error) {
      console.error(error);
      alert(error.message || '搜索全选报错：_getSearchNoSelection');
    }
  }

  /**
   * 处理全选单选状态
   */
  _handleCheckStatus(total, fn) {
    if (this.isSearch) {
      // 记录当前搜索总共多少条，然后点击勾上或取消，就加减，当这个搜索总数为0，那就说明是全选
      this.isCheckAll = !!(this.invertSearchTotal <= 0 && this.tableData.length);
      this.isIndeterminate = !!(
        (this.invertSearchTotal > 0 && this.tableData.length) ||
        (this.tableData.length <= 0 && total)
      );
    } else {
      this.isCheckAll = total >= this.pageTotal && total > 0;
      this.isIndeterminate = total < this.pageTotal && total > 0;
    }
    fn && fn(this._handleCallBack());
  }

  /**
   * 回调函数
   */
  _handleCallBack() {
    //把this.cacheSelection转换为array
    let cacheSelection = [];
    for (let key in this.cacheSelection) {
      if (Object.prototype.hasOwnProperty.call(this.cacheSelection, key) && this.cacheSelection[key]) {
        cacheSelection.push(this.cacheSelection[key]);
      }
    }
    return {
      isCheckAll: this.isCheckAll,
      isIndeterminate: this.isIndeterminate,
      selectionTotal: this.cacheSelectionTotal,
      selectionTable: cacheSelection,
    };
  }

  /**
   * 动态计算选中的数量
   */
  _toCalculateSelectionTotal() {
    return new Promise((resolve, reject) => {
      let total = 0;
      for (let key in this.cacheSelection) {
        if (Object.prototype.hasOwnProperty.call(this.cacheSelection, key) && this.cacheSelection[key]) {
          total += 1;
        }
      }
      this.cacheSelectionTotal = Math.max(0, total);
      resolve(total);
    });
  }

  /**
   * 请求接口
   */
  _getTableList() {
    return new Promise((resolve, reject) => {
      this.showLoad();
      const search = Object.assign(this.tableSearch, { pageSize: 100000, pageIndex: 1 });
      this.getTableList(search)
        .then(res => {
          // console.log(this.dataKey);
          if (this.dataKey) {
            if (!res.data || !Array.isArray(res.data[this.dataKey]) || !res.data[this.dataKey]) {
              res.data = { [this.dataKey]: [], total: 0 };
            }
            resolve(res.data[this.dataKey]);
          } else {
            if (!res.data || !Array.isArray(res.data)) res.data = [];
            resolve(res.data);
          }
          this.hideLoad();
        })
        .catch(err => {
          reject(err);
          this.hideLoad();
        });
    });
  }

  /**
   * 数组转化对象
   * @param {*} field 字段
   * @param {*} list 数组
   * @returns
   */
  _formatArrayToObject(field, selection) {
    if (!field) throw new Error('请传入转化的【key】');
    if (!Array.isArray(selection) || selection.length <= 0) return {};
    return selection.reduce((prev, next) => {
      prev[next[field]] = next;
      return prev;
    }, {});
  }

  /**
   * 显示load
   */
  showLoad() {
    this.loading && this.hideLoad();
    if (this.loadTarget) {
      this.loading = Loading.service({
        target: this.loadTarget,
        text: '数据加载中...',
        background: 'rgba(0,0,0,0.2)',
      });
    }
  }

  /**
   * 隐藏load
   */
  hideLoad() {
    if (this.loading) {
      let timer = setTimeout(() => {
        this.loading.close();
        this.loading = null;

        if (timer) {
          clearTimeout(timer);
          timer = null;
        }
      }, 500);
    }
  }
}

export default TableSelection;
```
## 使用

```js
import TableSelection from 'XXXX/tableSelection.js'
const tableSelection = new TableSelection({
  dataKey: 'list',
  rowKey: 'id',
  loadTarget: '#ID',
  getTableList: API,
});
// 数据请求
getAPI(isFirst = false) {
    API().then(
        // 获取到数据
        this.$nextTick(() => {
            this.initMultiple(isFirst);
        });
    )
}

// 清除选中的数据
tableSelection.reset();
// 选中的数据提交
tableSelection.handleSubmit(list => {})
// 更新数据
updateParameter(res) {
    this.isCheckAll = res.isCheckAll; // 全选状态
    this.selectionTotal = res.selectionTotal; // 选中几条
    this.isIndeterminate = res.isIndeterminate; // 半选状态
},
// 当前页面-全选、反选
handleSelectAll(selection) {
    tableSelection.handleCheckPageAll(selection, this.updateParameter);
},
// 单选选中
handleSelect(selection, row) {
    tableSelection.handleCheckSingle(selection, row, this.updateParameter);
},
// 全选
handleChangeAll(isCheckAll) {
    tableSelection.handleCheckAll(isCheckAll, this.updateParameter);
},
// 全选初始化
initMultiple(isFirst) {
    tableSelection.init({
    isFirst,
    params: this.search,
    echoList: this.echoId,
    pageTotal: this.pageTotal,
    tableData: this.tableData,
    callback: this.updateParameter,
    tableRefs: this.$refs.tableRef.tableRefs,
    });
},
```
