---
layout: post
title: react-native-splash-screen 在android启动屏使用
date: 2019-11-03 17:11:14
tags:
  - react-native
---
## react-native-splash-screen 在android启动屏使用
## 环境
```
XCode Version 10.2 (10E125)
"react": "16.8.6",
"react-native": "0.60.5",
"react-native-splash-screen": "^3.2.0",
```

## 安装
```
yarn add react-native-splash-screen
```

## 使用
```
import SplashScreen from 'react-native-splash-screen'
componentDidMount() {
  SplashScreen.hide()
}
```

## 配置
- 导入启动屏资源
![WX20191107-170720@2x-2019117172440](http://imgs.afacode.top/WX20191107-170720@2x-2019117172440.png)

- 引用启动屏资源
```
./android/app/src/main/res/layout 
mkdir launch_screen.xml

-----
android:background="@mipmap/launch_screen" 为启动屏资源
代码
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@mipmap/launch_screen"
    android:orientation="vertical">
</LinearLayout>
-----
```
- 在启动APP时使用 onCreate
```
/android/app/src/main/java/com/{你的项目名}/MainActivity.java

新增
------
import android.os.Bundle;

import org.devio.rn.splashscreen.SplashScreen;

public class MainActivity extends ReactActivity {

    ...
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        SplashScreen.show(this); 
        super.onCreate(savedInstanceState);
    }

    ...
}
----
```
![WX20191107-170630@2x-201911717257](http://imgs.afacode.top/WX20191107-170630@2x-201911717257.png)
