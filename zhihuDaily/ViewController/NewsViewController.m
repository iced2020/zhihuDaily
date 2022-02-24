//
//  NewsViewController.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/12.
//

#import "NewsViewController.h"
#import <WebKit/WebKit.h>// WKWebView（相比UIWebView更高效，苹果官方推荐）
#import <Masonry.h>//布局约束
#import "BaseViewController.h"
#import "MBProgressHUDTool.h"//提示框
#import "ToolBarViewController.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define toolbarHeight   46

@interface NewsViewController ()<WKUIDelegate, WKNavigationDelegate,UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation NewsViewController

#pragma mark - lifeCircle
//隐藏顶部导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    MBProgressHUD *hud = [MBProgressHUDTool showActivityMessage:@"加载中..."];
    [hud hideAnimated:YES  afterDelay:1.0]; // 1秒后移除
}

//恢复顶部导航栏
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc]init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.hidden = YES;//先隐藏 广告屏蔽后再展示
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    //添加下方的bar
    ToolBarViewController *secondVc = [[ToolBarViewController alloc] init];
    secondVc.Id = self.Id;
    secondVc.view.frame = CGRectMake(0, SCREEN_HEIGHT - toolbarHeight, SCREEN_WIDTH, toolbarHeight);
    [self addChildViewController:secondVc];
    [self.view addSubview:secondVc.view];
    
//    如果是加载HTML：
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
//   //    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
//       [self.view addSubview:webView];
//       webView.UIDelegate = self;
//       webView.navigationDelegate = self;
//   NSString *strHTML = @"HTML内容";
//       [webView loadHTMLString:strHTML baseURL:nil];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //屏蔽最顶部打开知乎日报和最底部进入知乎（去除页面”广告“元素）
    [webView evaluateJavaScript:@"document.getElementsByClassName('Daily')[0].remove();document.getElementsByClassName('    view-more')[0].remove();" completionHandler:nil];
// 移除控件有一个动画，会出现一闪而过的移除的动画，体验不太好。可以在WKWebView加载内容之前先进行隐藏，然后在block中显示，并且显示的时候要做一个延时
    dispatch_time_t delayTime =dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50/*延迟执行时间*/*NSEC_PER_MSEC));
    dispatch_after(delayTime,dispatch_get_main_queue(), ^{
        self.webView.hidden = NO;//展示页面
    });
// PS： 时间对于单位换算
// NSEC_PER_SEC 1000000000ull     多少纳秒 = 1秒         1秒 = 10亿纳秒
// NSEC_PER_MSEC 1000000ull       多少纳秒 = 1毫秒       1毫秒 = 100万纳秒
// USEC_PER_SEC 1000000ull        多少微秒 = 1秒         1秒 = 100万微秒
// NSEC_PER_USEC 1000ull          多少纳秒 = 1微秒       1微秒 = 1000 纳秒

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{

}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{

}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

     NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

@end
