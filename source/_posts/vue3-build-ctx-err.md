---
layout: vue3
title: Vue3 Composition项目打包上生产后 ctx, refs 无法获取DOM节点
date: 2021-06-20 23:48:12
tags:
  - vue
---
## Vue3 Composition项目打包上生产后 ctx, refs 无法获取DOM节点

Vue3项目打包上生产后，`const { ctx } = getCurrentInstance()`无法获取路由/全局挂载对象问题, 导致getCurrentInstance代表上下文，即当前实例。

ctx相当于Vue2的this, 但是需要特别注意的是ctx代替this只适用于**开发**阶段，如果将项目打包放到生产服务器上运行，就会出错，ctx无法获取路由和全局挂载对象的。此问题的解决方案就是使用**proxy替代ctx**

**

```js
- const { ctx } = getCurrentInstance()
+ const { proxy } = getCurrentInstance()

const enterDialog = () => {
    // 获取dom节点
    proxy.$refs.roleForm.validate(async (valid) => {
    if (valid) {
    	let res
        if (isEdit.value) {
        	res = await EditRole(form)
        } else {
        res = await addRole(form)
        }
        if (res.meta.success) {
        	getList()
        	dialogFormVisible.value = false
        	initForm()
        }
    }
})
```

> 或者 不使用 getCurrentInstance

```js
<el-form
	:model="form"
	:rules="rules"
    label-position="top"
    ref="menuFormRef"
    >
...
    
const menuFormRef = ref<null | HTMLInputElement>(null)
    
const enterDialog = () => {
    const menuForm = unref(menuFormRef)
    if (!menuForm) return
    menuForm.validate(async valid => {
        if (valid) {
            let res
            if (isEdit.value) {
                res = await UpdateMenu(form)
            } else {
                res = await addMenu(form)
            }
            if (res.meta.success) {
                getTree()
                closeDialog()
            }
        } else {}
    })
}
return {
    ....
    getCurrentInstance,
    enterDialog,
}
```



在使用 第三方UI组件库时,如element-plus使用 实现如**vue2.0 this.$confirm this.$message**,两种方式

```js
在使用的页面引入
import { ElMessageBox } from 'element-plus'
ElMessageBox.confirm("此操作将永久删除所有角色下该菜单, 是否继续?", "提示", {
	confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning"
}).then(async () => {
}).catch((e) => {})

或者
const { proxy } = getCurrentInstance()
proxy.confirm("此操作将永久删除所有角色下该菜单, 是否继续?", "提示", {
	confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning"
}).then(async () => {
}).catch((e) => {})

```