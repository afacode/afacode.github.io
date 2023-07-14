---
layout: post
title: 基于qrcode给二维码上面加图片/icon等,并支持下载
date: 2022-10-22 23:19:30
tags:
  - qrcode
  - vue
---

#### 实现

> `afQrcode.vue`

```html
<template>
  <div class="-qrcode">
    <div class="qrcode-box">
      <canvas :width="imgWidth" :height="imgWidth" ref="canvas" id="canvas"></canvas>
    </div>
    <img :src="dataUrl" :alt="downloadTitle" :title="downloadTitle" />
  </div>
</template>

<script>
import QRCode from 'qrcode';
const TYPES = ['image/png', 'image/jpeg', 'image/webp'];

export default {
  name: 'iccQrcode',
  props: {
    imgMargin: {
      type: Number,
      default: 2,
    },
    // 二维码实际大小
    imgWidth: {
      type: Number,
      default: 400,
    },
    type: {
      type: String,
      validator: type => TYPES.includes(type),
      default: 'image/png',
    },
    url: {
      type: String,
      default: '',
    },
    // 下载名称
    downloadTitle: {
      type: String,
      default: '二维码',
    },
    // 显示中间logo url
    logoUrl: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      dataUrl: '',
      qrLogoSize: 80, //logo size
    };
  },
  watch: {
    url(val) {
      if (val) {
        this.toDataURL();
      } else {
        this.dataUrl = '';
      }
    },
  },
  mounted() {
    this.url && this.toDataURL();
  },

  methods: {
    downLoadImg() {
      if (!this.dataUrl) return;
      this.downloadFile({
        type: 'link',
        fileType: 'png',
        title: this.downloadTitle,
        link: this.dataUrl,
      });
    },
    toDataURL() {
      QRCode.toDataURL(this.url, { width: this.imgWidth, margin: this.imgMargin })
        .then(dataUrl => {
          this.dataUrl = dataUrl;
          if (this.logoUrl) {
            this.$nextTick(() => {
              this.makeCode(dataUrl);
            });
          }
        })
        .catch(err => this.$emit('error', err));
    },
    makeCode(dataUrl) {
      const canvas = this.$refs.canvas;
      const that = this;
      // 生成二维码-img
      const qrCodeImg = new Image();
      // 生成logo-img
      const logoImg = new Image();
      // 画二维码里的logo 在canvas里进行拼接
      const ctx = canvas.getContext('2d');
      qrCodeImg.src = dataUrl;
      qrCodeImg.onload = () => {
        // 绘制二维码
        ctx.drawImage(qrCodeImg, 0, 0, that.imgWidth, that.imgWidth);
        //设置logo大小 设置获取的logo将其变为圆角以及添加白色背景
        ctx.fillStyle = '#fff';
        ctx.beginPath();
        const logoPosition = (that.imgWidth - that.qrLogoSize) / 2; //logo相对于canvas居中定位
        const h = that.qrLogoSize + 10; //圆角高 10为基数(logo四周白色背景为10/2)
        const w = that.qrLogoSize + 10; //圆角宽
        const x = logoPosition - 5;
        const y = logoPosition - 5;
        const r = 5; //圆角半径
        ctx.moveTo(x + r, y);
        ctx.arcTo(x + w, y, x + w, y + h, r);
        ctx.arcTo(x + w, y + h, x, y + h, r);
        ctx.arcTo(x, y + h, x, y, r);
        ctx.arcTo(x, y, x + w, y, r);
        ctx.closePath();
        ctx.fill();
        ctx.restore(); //需要编辑canvas内容则需要写入
        this.imgUrlToBase64(this.logoUrl).then(res => {
          logoImg.src = res;
          // logoImg.src = this.logoUrl + '?time=' + new Date().valueOf();
          // logoImg.setAttribute('crossOrigin', 'anonymous');
          // 绘制logo
          logoImg.onload = () => {
            ctx.drawImage(logoImg, logoPosition, logoPosition, that.qrLogoSize, that.qrLogoSize);
            // 赋值链接
            this.dataUrl = canvas.toDataURL();
          };
        });
      };
    },
    imgUrlToBase64(url) {
      return new Promise((resolve, reject) => {
        if (!url) {
          reject('请传入url内容');
        }
        if (/\.(png|jpe?g|gif|svg)(\?.*)?$/.test(url)) {
          // 图片地址
          const image = new Image();
          // 设置跨域问题
          image.setAttribute('crossOrigin', 'anonymous');
          // 图片地址
          image.src = url + '?time=' + new Date().valueOf();
          image.onload = () => {
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');
            canvas.width = image.width;
            canvas.height = image.height;
            ctx.drawImage(image, 0, 0, image.width, image.height);
            // 获取图片后缀
            const ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
            // 转base64
            const dataUrl = canvas.toDataURL(`image/${ext}`);
            resolve(dataUrl || '');
          };
        } else {
          // 非图片地址
          reject('非(png/jpe?g/gif/svg等)图片地址');
        }
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.qrcode-box {
  display: none;
  img {
    display: none;
  }
}
.qrcode,
img {
  width: 100%;
  height: 100%;
}
</style>
```

#### 使用

```vue
<af-qr-code
   class="code-info"
   :downloadTitle="downloadTitle"
   ref="qrCodeUrl"
   :url="shareUrl"
   :isLogo="true"
    :logoUrl="activityLogo"
/>
// 下载二维码
downloadFileFn() {
      this.$refs.qrCodeUrl.downLoadImg();
    },
```

