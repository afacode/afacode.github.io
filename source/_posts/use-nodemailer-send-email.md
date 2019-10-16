---
layout: post
title: nodemailer 简单使用
date: 2019-10-13 08:55:01
tags:
---

## nodemailer 简单使用
```
ts 
import * as nodemailer from 'nodemailer';

async function main() {
    const testAccount = await nodemailer.createTestAccount();

    const transporter = nodemailer.createTransport({
        // host: 'smtp.qq.com',
        // https://nodemailer.com/smtp/well-known/
        service: 'qq',
        port: 465,
        secure: true, // true for 465, false for other ports
        auth: {
            user: 'lfqdalian@qq.com', // 使用的邮箱
            pass: '', // POP3/SMTP服务授权码，不是密码
        },
    });

    // send mail with defined transport object
    const mailOptions = {
        from: '"afacode" <lfqdalian@qq.com>',
        to: 'lfqdalian@sina.com, lfqdalian@outlook.com',
        subject: 'Hello ✔',
        // text: 'Hello world?',
        html: '<b>Hello world? nodemailer</b>', // html body
    };
    const info = await transporter.sendMail(mailOptions);

    console.log('Message sent: %s', info.messageId);

}

main().catch(console.error);

```
