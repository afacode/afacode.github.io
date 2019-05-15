---
layout: post
title: python类(学习)
date: 2017-11-16 23:07:39
categories:
  - python
tags:
  - python
  - 学习
---

[学习]python类，继承
<!-- more -->

## [学习]python类，继承
转载[https://www.yuanrenxue.com/python/python-class-inheritance.html](https://www.yuanrenxue.com/python/python-class-inheritance.html)

```
class Person:
    def __init__(self, name, age, height):
        self.name = name
        self.age = age
        self.height = height

    def look(self):
        print(self.name, 'is looking')

    def walk(self):
        print(self.name, 'is walking')

class Teacher(Person):
    def __init__(self, name, age, height):
        super().__init__(name, age, height)

    def teach(self):
        print(self.name, 'is teaching')

class Student(Person):
    def __init__(self, name, age, height):
        super().__init__(name, age, height)

    def learn(self):
        print(self.name, 'is learning')


if __name__ == '__main__':
    teacher = Teacher('Tom', 31, 178)
    s1 = Student('Jim', 12, 160)
    s2 = Student('Kim', 13, 162)

    teacher.look()
    teacher.walk()
    teacher.teach()
    print('==='*5)

    s1.look()
    s1.walk()
    s1.learn()
    print('==='*5)

    s2.look()
    s2.walk()
    s2.learn()

```


欢迎访问我的博客 &nbsp;[地址](blog.afacode.top) &nbsp; &nbsp; &nbsp;
https://blog.afacode.top