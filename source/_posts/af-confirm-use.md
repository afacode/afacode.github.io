---
layout: post
title: 确认弹窗 (调用方式跟element this.$message 类似)
date: 2022-08-04 23:19:30
tags:
  - element
  - vue
---

> 比element确认弹框多了个特殊按钮`specialType`(底部可以有3个按钮)

#### 使用方式
​```javascript
// 调用方式1
this.$afConfirm('副标题')
  .then(() => {})
  .catch(() => {});

// 调用方式2
this.$afConfirm({ title: '标题', subTitle: '副标题' })
  .then(() => {})
  .catch(() => {});

// 调用方式3  删除状态
this.$afConfirm
  .delete({ title: '标题', subTitle: '副标题' })
  .then(() => {})
  .catch(() => {});

// 调用方式4  删除状态
this.$afConfirm
  .delete({ title: '标题', subTitle: '副标题', submitType: 'delete' })
  .then(() => {})
  .catch(() => {});

// 调用方式5  成功状态, 跟方式1,2 一样
this.$afConfirm
  .success({ title: '标题', subTitle: '副标题' })
  .then(() => {})
  .catch(() => {});

// 标题和副标题 render 函数 参数参考文档
// https://v2.cn.vuejs.org/v2/guide/render-function.html#createElement-%E5%8F%82%E6%95%B0
this.$afConfirm({
  title(h) {
    return h('span', { style: { color: 'red' } }, '标题');
  },
  subTitle(h) {
    return h('span', { style: { color: 'red' } }, '副标题');
  },
})
  .then(() => {})
  .catch(() => {});
```

#### 实现

> `afConfirm/afConfirm.vue`

```vue
<script>
export default {
  name: 'afConfirm',
  data() {
    this._submit = null;
    this._cancel = null;
    this._special = null;
    return {
      isConfirm: false,
      params: {
        title: '', // 可以传字符串，可以传render函数
        subTitle: '', // 可以传字符串，可以传render函数
        cancelText: '取消',
        specialText: '',
        submitText: '确定',
        cancelType: 'cancel',
        specialType: 'submit',
        submitType: 'submit',
        showCloseIcon: true,
        isCloseOnClickByModal: true,
      },
    };
  },
  methods: {
    confirm(params = {}) {
      if (!params.title && !params.subTitle) return Promise.reject({ message: '请输入要文案' });
      this.params = Object.assign(
        {
          title: '',
          subTitle: '',
          cancelText: '取消',
          specialText: '',
          submitText: '确定',
          cancelType: 'cancel',
          specialType: 'submit',
          submitType: 'submit',
          isCloseOnClickByModal: true,
        },
        params
      );
      this.isConfirm = true;
      return new Promise((resolve, reject) => {
        this._submit = resolve;
        this._special = resolve;
        this._cancel = reject;
      });
    },

    handleCancel() {
      this.isConfirm = false;
      this._cancel();
    },

    handleSpecial() {
      this.isConfirm = false;
      this._special('special');
    },

    handleSubmit() {
      this.isConfirm = false;
      this._submit('submit');
    },

    // 副标题
    getSubTitleNode(createElement) {
      const { params } = this;
      if (!params.subTitle) return null;
      if (typeof params.subTitle === 'function') {
        return <div class="confirm-subTitle">{params.subTitle(createElement)}</div>;
      }
      return <div class="confirm-subTitle">{params.subTitle}</div>;
    },

    // 标题
    getTitleNode(createElement) {
      const { params } = this;
      if (!params.title) return null;
      if (typeof params.title === 'function') {
        return <span class="confirm-title">{params.title(createElement)}</span>;
      }
      return <span class="confirm-title">{params.title}</span>;
    },
  },
  beforeDestroy() {
    this._submit = null;
    this._special = null;
    this._cancel = null;
  },
  render(createElement) {
    const { params } = this;
    return (
      <el-dialog
        append-to-body
        visible={this.isConfirm}
        onClose={() => this.handleCancel()}
        show-close={this.params.showCloseIcon}
        onCloseOnClickModal={() => params.isCloseOnClickByModal()}
        onCloseOnPressEscape={() => params.isCloseOnClickByModal()}
        custom-class="el-dialog_custom el-dialog_custom--confirm"
      >
        {/* 标题 */}
        {this.getTitleNode(createElement)}
        {/* 副标题 */}
        {this.getSubTitleNode(createElement)}
        {/* 按钮 */}
        <div slot="footer" class="flex">
          {params.cancelText ? (
            <el-button type={params.cancelType} onClick={() => this.handleCancel()}>
              {params.cancelText}
            </el-button>
          ) : null}
          {params.specialText ? (
            <el-button class="mr20" type={params.specialType} onClick={() => this.handleSpecial()}>
              {params.specialText}
            </el-button>
          ) : null}
          <el-button type={params.submitType} onClick={() => this.handleSubmit()}>
            {params.submitText}
          </el-button>
        </div>
      </el-dialog>
    );
  },
};
</script>

<style lang="scss" scoped>
::v-deep .el-dialog_custom--confirm {
  top: 25%;
  width: 350px;
  min-height: 0;
  max-height: 100%;
  margin: 0 auto;
  box-shadow: 0 20px 100px 1px $main_text_black_color_7, 0 -3px 50px 1px $main_text_black_color_5;
  border-radius: 10px;
  .confirm-title {
    display: inline-block;
    padding: 0;
    margin: 0;
    color: $main_text_black_color;
    font-family: Roboto-Bold, Roboto;
    font-size: 15px;
    font-weight: bold;
    line-height: 19px;
  }
  .el-dialog__header {
    padding: 35px 35px 0;

    .el-dialog__headerbtn {
      padding: 10px 13px;
    }
  }

  .el-dialog__body {
    flex: none;
    padding: 0 35px;
    overflow: hidden;

    .confirm-subTitle {
      padding-top: 6px;
      color: $main_text_black_color_50;
      font-family: Roboto-Regular, Roboto;
      font-size: 13px;
      font-weight: 400;
      line-height: 16px;
    }
  }

  .el-dialog__footer {
    padding: 25px 35px 30px;

    .el-button {
      // width: 90px;
      margin: 0;
    }

    .el-button--cancel {
      color: $main_text_black_color;
    }

    .el-button--delete {
      color: $main_white_color;
      box-shadow: 0 5px 30px 1px rgba(247, 51, 147, 0.05);
      border-color: $main_pink_color;
      background: $main_pink_color;

      &:hover {
        background: $main_pink_color;
      }
    }
  }
}
</style>
```



> `afConfirm/index.js`

```javascript
import afConfirm from './afConfirm.vue';

export default {
  install(Vue) {
    // extend 是构造一个组件的语法器.传入参数，返回一个组件
    const InstanceConfirm = Vue.extend(afConfirm);
    let instanceConfirm = null;

    // 实例化InstanceWxAuth组件
    const instance = () => {
      instanceConfirm = new InstanceConfirm();
      // 挂载
      document.body.appendChild(instanceConfirm.$mount().$el);
    };

    // 成功
    const afConfirm = function (params) {
      if (!instanceConfirm) instance();
      // 如果直接传入字符串
      if (params && typeof params === 'string') {
        params = { title: params, submitType: 'submit' };
      }

      // 返回Promise
      return new Promise((resolve, reject) => {
        instanceConfirm
          .confirm(params)
          .then(confirmType => {
            resolve(confirmType);
          })
          .catch(reject);
      });
    };

    // 删除
    afConfirm['delete'] = function (params) {
      // 如果直接传入字符串
      if (params && typeof params === 'string') params = { title: params };
      params.submitType = params.submitType || 'delete';
      params.isCloseOnClickByModal = params.isCloseOnClickByModal || false;
      return afConfirm(params);
    };

    // 成功
    afConfirm['success'] = function (params) {
      // 如果直接传入字符串
      if (params && typeof params === 'string') params = { title: params };
      params.submitType = params.submitType || 'submit';
      return afConfirm(params);
    };

    Vue.prototype.$afConfirm = afConfirm;
  },
};

```

> 注册

```javascript
import AfConfirm '@/***/afConfirm/index.js';
Vue.use(AfConfirm);
```

