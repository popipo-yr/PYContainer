
---
#PYContainer
-------------

> 由于各种需求写了这个视图控制器容器,这个容器可以包含任意其他视图控制器(包含导航控制器).容器只有两个元素,一个根视图控制器和一个子视图控制器.通过对外开放API进行切换,切换过程可使用自定义的动画,切换过程可以手动控制.


####示例:  
具体使用效果请查看Demo



### 下载安装
目前没有支持cocospods,下载PYContainer加入头文件就可使用

###使用方法
```
//创建控制器
PYAppContainerController* container = [[PYAppContainerController alloc] 
										initWithRootViewController:...];

//切换根视图控制器
[container changeRootViewController ...]

//显示或者切换子视图控制器
[container showChildViewController ...]
//隐藏子视图控制器
[container hiddenChildViewController ...]

```

### 注意事项
>如果在切换的过程中调用其他切换将会被忽略

