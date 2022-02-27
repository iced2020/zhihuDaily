# zhihuDaily
寒假考核

## Demo Project

### 新闻加载（点赞收藏会出现提示）：

### ![新闻加载](/Users/panshenbing/Documents/GitHub/zhihuDaily/新闻加载.gif)

### 下拉刷新（并且同时加载前一天的数据）：

![下拉刷新](/Users/panshenbing/Documents/GitHub/zhihuDaily/下拉刷新.gif)

### 上拉加载：

![上拉加载](/Users/panshenbing/Documents/GitHub/zhihuDaily/上拉加载.gif)

### 伪登录：

![伪登录](/Users/panshenbing/Documents/GitHub/zhihuDaily/伪登录.gif)



### 主页构成：

顶部导航栏（navigationItem），上方图片轮播器（SDCycleScrollView），下方列表（TableView）

![image-20220227111815416](/Users/panshenbing/Documents/GitHub/zhihuDaily/主页构成.png)

其中底部采用ScrollView（自定义：允许多手势的代理）；TableView用了一个ScrollView作为容器（不然有几率卡住），最后都添加到底部的ScrollView上去

### 其他板块：

登录页面（LoginViewController）；个人页面（PersonViewController）；新闻加载页面（NewsViewController）；新闻加载页面底部控件栏（ToolBarViewController）

### 开发思路：

主页由图片轮播器和一个列表组成，顶部有登录按钮可以跳转到登录页面；登录页面由账号框和密码框组成，同时账号及密码数据可以保存到沙盒中，下一次可以直接登录；登录后主页的登录按钮变成个人按钮，可以跳转到个人页面；个人页面只做了初步处理，有头像以及退出按钮；新闻加载页面采用WKWebView，相比相比UIWebView更高效，苹果官方推荐，底部添加控件栏（ToolBarViewController），可以实现返回、点赞、（点赞数）、收藏。

### 比较重要的技术以及知识点：

图片轮播器（采用的第三方框架，但也去了解了原理，尝试自己封装（但是不太行，最后还是选择第三方框架））；

ScrollView 嵌套 TableView（scrollview 嵌套tableview 或者 tableview 嵌套tableview 最主要的一步就是 scrollview或者tableview（底层的滑动控件）要打开允许多手势的代理）；

网络数据的获取加载处理；

数据持久化（不熟）；

第三方框架的使用；

自定义view；

### 心得体会：

自己对于细节的忽略就有可能导致各种各样的bug，程序莫名其妙的崩溃；同时对于命名应该进一步加强规范（主要是英语太差实在是不知道取什么名字）；对于知识点也要进一步加强印象；为之后的学习做好铺垫；详细的注释真的可以帮助我回忆代码（有时候时间久了难免会忘记）

