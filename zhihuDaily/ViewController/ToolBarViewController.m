//
//  ToolBarViewController.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/21.
//

#import "ToolBarViewController.h"
#import "HMNetworkTools.h"
#import <Masonry.h>//布局约束
#import "BaseViewController.h"
#import "MBProgressHUDTool.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define toolbarHeight   46
@interface ToolBarViewController ()
@property (nonatomic, strong) UIToolbar *mToolbar;
@property (nonatomic, strong) UIBarButtonItem *itemFirst;
@property (nonatomic, strong) UIBarButtonItem *itemSecond;
@property (nonatomic, strong) UIBarButtonItem *itemThird;
@property (nonatomic, strong) UIBarButtonItem *itemFourth;
@property (nonatomic, strong) NSNumber *popularity;
@property (nonatomic, strong) NSString *popularityNum;
@property (nonatomic, strong) UILabel *lab;
@end

@implementation ToolBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化toolbar,注意这里CGRectMake前两个参数是toolbar的坐标，也就是其左上角的坐标点，x比较好理解，y需要通过计算得到
    self.mToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, toolbarHeight)];
    //初始化itemFirst,itemSecond,itemThird并修改一下图片的渲染模式（不然图片是蓝色的）
    //ps：图标图片应该采用矢量图吧 目前是直接挖的图片与bar还有色差
    self.itemFirst = [[UIBarButtonItem alloc] initWithImage:[self reSizeImage:[UIImage imageNamed:@"back.jpg"] toSize:CGSizeMake(80, 50)] style:UIBarButtonItemStyleDone target:self action:@selector(exit)];
    self.itemSecond = [[UIBarButtonItem alloc] initWithImage:[self reSizeImage:[UIImage imageNamed:@"like.jpg"] toSize:CGSizeMake(45, 45)] style:UIBarButtonItemStyleDone target:self action:@selector(like)];
    self.itemThird = [[UIBarButtonItem alloc] initWithImage:[self reSizeImage:[UIImage imageNamed:@"star.jpg"] toSize:CGSizeMake(45, 45)] style:UIBarButtonItemStyleDone target:self action:@selector(star)];
    [self getdata];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", self.popularity);
        self.itemFourth = [[UIBarButtonItem alloc] init];
        self.popularityNum = [self.popularity stringValue];
        self.itemFourth.title = self.popularityNum;
        //FlexibaleSpacekec初始化要注意了，并没有我们想的FlexibaleSpacekec这个控件，而是UIBarButtonItem的一种
        UIBarButtonItem *flexibaleSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //将itemFirst、itemSecond等UIBarButtonItem添加到UIToolbar，并使用FlexibleSpace优化布局
        //总结一下Flexible Space:它能够让item之间的控件弹性变化，保证item之间的间距都是一样的
        self.mToolbar.items = @[self.itemFirst, flexibaleSpaceItem,self.itemSecond, flexibaleSpaceItem, self.itemFourth, flexibaleSpaceItem,self.itemThird, flexibaleSpaceItem];
        [self.view addSubview:self.mToolbar];
        });
}

- (void)getdata{
    //https://news-at.zhihu.com/api/3/story-extra/该新闻id
    NSString *str = @"story-extra/";
    NSString *string1 = [NSString stringWithFormat:@"%@",self.Id];
    NSString *string2 = [NSString stringWithFormat:@"%@%@", str,string1];
    [[HMNetworkTools SharedManager]
     GET:string2
     parameters:nil
     headers:nil
     progress:^(NSProgress * _Nonnull downloadProgress) {
        }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取返回的数组
        //实际上返回的的数据类型是NSNumber
        NSNumber *like = responseObject[@"popularity"];
        if (like == nil) {
            self.popularity = 0;
        }else{
        self.popularity = like;
        }
        }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error");
        }];
}

//修正图片的大小
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - 退出
- (void)exit{
    //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
    BaseViewController *baseVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    //返回到上一页面
    [self.navigationController popToViewController:baseVC animated:true];
}

#pragma mark - 喜欢/取消喜欢 收藏/取消收藏
- (void)like{
    self.itemSecond.image = [self reSizeImage:[UIImage imageNamed:@"liked.jpg"] toSize:CGSizeMake(45, 45)];
    self.itemSecond.action = @selector(unLike);
    self.popularity = [NSNumber numberWithInt:[self.popularity intValue] + 1];
    self.popularityNum = [self.popularity stringValue];
    self.itemFourth.title = self.popularityNum;
    [MBProgressHUDTool showMessage:@"点赞成功"];
}

- (void)unLike{
    self.itemSecond.image = [self reSizeImage:[UIImage imageNamed:@"like.jpg"] toSize:CGSizeMake(45, 45)];
    self.itemSecond.action = @selector(like);
    self.popularity = [NSNumber numberWithInt:[self.popularity intValue] - 1];
    self.popularityNum = [self.popularity stringValue];
    self.itemFourth.title = self.popularityNum;
    [MBProgressHUDTool showMessage:@"取消点赞"];
}

- (void)star{
    self.itemThird.image = [self reSizeImage:[UIImage imageNamed:@"stared.jpg"] toSize:CGSizeMake(45, 45)];
    self.itemThird.action = @selector(unStar);
    [MBProgressHUDTool showMessage:@"收藏成功"];
}

- (void)unStar{
    self.itemThird.image = [self reSizeImage:[UIImage imageNamed:@"star.jpg"] toSize:CGSizeMake(45, 45)];
    self.itemThird.action = @selector(star);
    [MBProgressHUDTool showMessage:@"取消收藏"];
}

@end
