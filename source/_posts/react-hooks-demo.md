---
layout: post
title: react hooks学习
date: 2019-08-17 19:19:00
tags:
  - react
---

react hooks 学习. [FAQ](https://zh-hans.reactjs.org/docs/hooks-faq.html#which-versions-of-react-include-hooks)
<!-- more -->

## useState代替state
```
function Example(){
    const [ count , setCount ] = useState(0);
    return (
        <div>
            <p>You clicked {count} times</p>
            <button onClick={()=>{setCount(count+1)}}>click me</button>
        </div>
    )
}
```
## useEffect代替常用生命周期函数

实现类似componentWillUnmount的效果,useEffect的第二个参数，它是一个数组，数组中可以写入很多状态对应的变量，意思是当**状态值发生变化时，我们才进行解绑**。但是当传空数组[]时，就是当组件将被销毁时才进行解绑，这也就实现了componentWillUnmount的生命周期函数
```
useEffect(()=>{
        // 初始化，更新时
        return ()=>{
            // 类似于销毁时
        }
    },[]) // [] 状态发生变化，在达到条件时才触发
```
## useContext 让父子组件传值更简单
`useContext`跨越组件层级直接传递变量，实现共享
```
const CountContext = createContext()

function Parent(){
    const [ count , setCount ] = useState(0);
    return (
        <div>
            <p>You clicked {count} times</p>
            <button onClick={()=>{setCount(count+1)}}>click me</button>
            <CountContext.Provider value={count}> //共享出去
                <Child />
            </CountContext.Provider>

        </div>
    )
}
function Child() {
    // 接收
    const count = useContext(CountContext) 
    return <h2>{count}</h2>
}

```
## useReducer完成类似的Redux
useReducer可以让代码具有更好的可读性和可维护性
```
function ReducerDemo(){
    const [ count , dispatch ] =useReducer((state,action)=>{
        switch(action){
            case 'add':
                return state+1
            case 'sub':
                return state-1
            default:
                return state
        }
    },0)
    return (
       <div>
           <h2>现在的分数是{count}</h2>
           <button onClick={()=>dispatch('add')}>Increment</button>
           <button onClick={()=>dispatch('sub')}>Decrement</button>
       </div>
    )

}

```
待续
## useCallback
## useMemo
## useRef
## useImperativeHandle
## useLayoutEffect
