---
layout: post
title: React does not recognize the computedMatch prop on a DOM element
date: 2019-06-11 23:05:58
categories:
  - js
tags:
  - react-router
  - react
---

完整的警告是：
Warning: React does not recognize the computedMatch prop on a DOM element. If you intentionally want it to appear in the DOM as a custom attribute, spell it as lowercase computedmatch instead. If you accidentally passed it from a parent component, remove it from the DOM element.

> 版本：

```
"react": "^16.8.6",
"react-dom": "^16.8.6",
"react-redux": "^7.0.3",
"react-router-dom": "^5.0.1",
```

**引起警告的原因是**： 在`react-router-dom`的`<Switch>`中使用了`<div>`

解决办法很简单，把`<Switch>`增加一层`<Fragment>`就行了
```

render() {
    return (
      <Switch>
+       <Fragment>
        <div className="App">
          <header className="App-header">  
            <Link to='/'>Home</Link>
            <Link to='/about'>About</Link>
            <Link to='/users'>Users</Link>
            <Route exact path='/' component={Index} />
            <Route exact path='/about' component={About} />
            <Route exact path='/users' component={Users} />
          </header>
        </div>
+       </Fragment>
      </Switch>
    )
```

