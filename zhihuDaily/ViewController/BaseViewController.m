//
//  BaseViewController.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/8.
//

#import "BaseViewController.h"
#import "Model.h"//当日新闻
#import "Model2.h"//往日新闻
#import "TopModel.h"//图片轮播
#import <Masonry.h>//布局约束
#import "HMNetworkTools.h"//网络通讯工具
#import <MJRefresh.h>//刷新控件
#import "HMTableViewCell.h"//自定义的列表cell
#import "baseScrollView.h"//自定义：能够进行手势穿透
#import <SDWebImage.h>//从网络加载图片
#import <SDCycleScrollView.h>//图片轮播器
#import "LoginViewController.h"//登录页面
#import "NewsViewController.h"//新闻详情页
#import "TimeModel.h"//时间获取
#import "PersonViewController.h"//个人页面
#import "ToolBarViewController.h"//点赞数量

//宏定义 屏幕大小
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

@interface BaseViewController ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate,UIScrollViewDelegate>
//新闻列表
@property (nonatomic, strong) UITableView *tableView;
//下方新闻列表的数据
@property (nonatomic, copy) NSArray<Model *> *data;
//下方新闻列表的数据（中间变量 目的是方便转换）
@property (nonatomic, strong) NSMutableArray *testData;
//刷新控件
@property (nonatomic, strong) UIRefreshControl *refreshControl;
//轮播图
@property (nonatomic, strong) SDCycleScrollView *scrollView;
//轮播图：图片数组
@property (nonatomic, strong) NSArray *arrImg;
//轮播图：标题数组
@property (nonatomic, strong) NSArray *arrTitle;
//最底层的视图
@property (nonatomic, strong) BaseScrollView *mainScrollView;
//滚动参数
@property (nonatomic, assign) BOOL canScroll;
// 添加到scrollview上的 容器视图：必须是UIScrollView否则子滚动视图滚动到顶部时，会有一定概率卡住
@property (nonatomic, strong) UIScrollView *containerView;
@end

@implementation BaseViewController

#pragma mark - 隐藏tabBar
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 加载内容
- (void)viewDidLoad {
    [super viewDidLoad];
//    传入数据
    [Model getDataSuccess:^(NSArray<Model *> * array) {
//            NSLog(@"%@",array);
        self.data = array;
    }];
    self.canScroll = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 43)];
//    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:23];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"知乎日报";
    self.navigationItem.titleView = titleLabel;
//    设置导航右上角的按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(jumpLogin)];
    self.navigationItem.rightBarButtonItem = rightBtn;
//    显示最底层的视图
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.backgroundColor = [UIColor grayColor];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    显示图片轮播器
    [self.mainScrollView addSubview:self.scrollView];
//    显示装tableview的容器
    [self.mainScrollView addSubview:self.containerView];
//    显示tableView
    [self.containerView addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(SCREEN_WIDTH);//留出图片轮播器的位置
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //UITableView
    if ([scrollView isKindOfClass:[UITableView class]]){
        CGFloat offsetY = self.tableView.contentOffset.y;
        if (self.canScroll == NO) {
            if (offsetY <= 0) {
                scrollView.contentOffset = CGPointZero;
                self.tableView.scrollEnabled = NO;//tableView禁止滚动
                self.mainScrollView.scrollEnabled = YES;//mainScrollViewt允许滚动
                self.canScroll = YES;
            }
        }
    }
    //mainScrollView
    if ([scrollView isEqual:self.mainScrollView]) {
        CGFloat maxOffsetY = SCREEN_WIDTH;
        CGFloat offsetY = self.mainScrollView.contentOffset.y;
        if (offsetY >= maxOffsetY) {
            self.tableView.scrollEnabled = YES;//tableView允许滚动
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
            self.mainScrollView.scrollEnabled = NO;//mainScrollView禁止滚动
            self.canScroll = NO;
        }
    }
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsViewController *newsView = [[NewsViewController alloc] init];
    newsView.url = self.data[indexPath.row].url;//属性传值
    newsView.Id =self.data[indexPath.row].Id;//属性传值
    [self.navigationController pushViewController:newsView animated:YES];
}

#pragma mark - UITableViewDataSource
//设置每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

//设置一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

//具体数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reusedId = @"stories";
    HMTableViewCell *cell = (HMTableViewCell *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusedId];
    if (!cell) {
        cell = [[HMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
//   显示所有内容
    cell.news = self.data[indexPath.row];
    return cell;

}


#pragma mark -SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NewsViewController *newsView = [[NewsViewController alloc]init];
    [TopModel getDataSuccess:^(NSArray<TopModel *> * tarray) {
        newsView.Id = tarray[index].Id;
        newsView.url = tarray[index].url;
        [self.navigationController pushViewController:newsView animated:YES];
    }];
    // 清理缓存
    [SDCycleScrollView clearImagesCache];
}


#pragma mark - lan加载
- (UITableView *) tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//初始化并设置分组显示（Groupd）不分组(plain）
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        // 设置回调（一旦进入刷新状态，就调用 target 的 action，也就是调用 self 的 loadNewData 方法）
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableView;
}

- (SDCycleScrollView *)scrollView {
    if (!_scrollView) {
        //图片轮播初始化方式
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) imageURLStringsGroup:self.arrImg];
        //背景色
        _scrollView.backgroundColor = [UIColor whiteColor];
        //代理方法
        _scrollView.delegate = self;
        //当前分页控件小图标颜色
        _scrollView.currentPageDotColor = [UIColor blueColor];
        //其他分页控件小图标颜色
        _scrollView.pageDotColor = [UIColor grayColor];
        //自动滚动时间间隔,默认2s
        _scrollView.autoScrollTimeInterval = 5;
        //是否自动滚动, 默认YES
        _scrollView.autoScroll = YES;
//        轮播图片的ContentMode, 默认为UIViewContentModeScaleToFill
//        _scrollView.bannerImageViewContentMode = UIViewContentModeCenter;
        //是否无限循环,默认YES;否则滚动到第四张图就不再滚动了
        _scrollView.infiniteLoop = YES;
        //翻页的位置
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //显示图片、文字
        [TopModel getDataSuccess:^(NSArray<TopModel *> * tarray) {
                self.arrImg = @[tarray[0].image,tarray[1].image,tarray[2].image,tarray[3].image,tarray[4].image];
                self.arrTitle = @[tarray[0].title,tarray[1].title,tarray[2].title,tarray[3].title,tarray[4].title];
                self.scrollView.imageURLStringsGroup = self.arrImg;
                self.scrollView.titlesGroup = self.arrTitle;
        }];
        _scrollView.titleLabelHeight = 56;//修改文本框高度
        _scrollView.titleLabelTextFont = [UIFont boldSystemFontOfSize:16];//修改字体大小
        //在SDCollectionViewCell中添加自动换行        _titleLabel.numberOfLines
    }
    return _scrollView;
}

- (BaseScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _mainScrollView.delegate = self;//一定要设置代理！！不然无法使用代理方法
        _mainScrollView.showsVerticalScrollIndicator = NO;//隐藏导航条
        _mainScrollView.directionalLockEnabled =YES;//每次只在一个方向上滚动
        _mainScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT+SCREEN_WIDTH);//设置滚动范围
        _mainScrollView.bounces = YES;//禁止回弹（刷新需要允许）
        //下拉刷新
        _mainScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//        //上拉刷新
//        _mainScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _mainScrollView;
}

- (UIScrollView *)containerView{
    if (!_containerView ) {
        _containerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH, self.view.frame.size.width, self.view.frame.size.height)];
        _containerView.backgroundColor = [UIColor redColor];
    }
    return _containerView;
}


#pragma mark - 各种调用方法
//加载时调用
- (void)loadNewData{
    if (self.data == nil) {
        [Model getDataSuccess:^(NSArray<Model *> * array) {
            self.data = array;
        }];
    }
    self.testData = [[NSMutableArray alloc] init];
    [Model2 getDataSuccess:^(NSArray * _Nonnull array2) {
        [self.testData addObjectsFromArray:self.data];
        [self.testData addObjectsFromArray: array2];
        self.data = self.testData;
    }];
}

//设置setData方法
- (void)setData:(NSArray <Model *> *)data{
    _data = data;
    //当获取数据在展示数据之后时，重新加载
    [self.tableView reloadData];
    //停止刷新
    [self.mainScrollView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

// 跳转到登录界面
- (void)jumpLogin {
    LoginViewController *vc = [[LoginViewController alloc] init];
//    vc.view.backgroundColor = [UIColor blackColor];
    // 跳转到下一个页面时隐藏tabBar
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController pushViewController:vc animated:YES];
}

// 跳转到下一个界面
- (void)jumpPerson {
    PersonViewController *vc = [[PersonViewController alloc] init];
//    vc.view.backgroundColor = [UIColor blackColor];
    // 跳转到下一个页面时隐藏tabBar
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
