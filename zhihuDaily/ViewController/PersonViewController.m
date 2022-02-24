//
//  PersonViewController.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/20.
//

#import "PersonViewController.h"
#import "BaseViewController.h"
#import <Masonry.h>//布局约束

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
@interface PersonViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong)UIButton *exitButton;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-SCREEN_WIDTH/2);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
    [self.view addSubview:self.exitButton];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(SCREEN_WIDTH/5);
        make.width.mas_equalTo(315);
        make.height.mas_equalTo(52);
    }];
}

#pragma mark - lan加载
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor greenColor];
        _imageView.image = [UIImage imageNamed:@"login.jpg"];;
    }
    return _imageView;
}

- (UIButton *)exitButton{
    if (_exitButton == nil) {
        _exitButton = [[UIButton alloc]init];
        _exitButton.frame =CGRectMake(30, 360, 315, 52);
        //给控件加圆角
        _exitButton.layer.cornerRadius = 25;
        [_exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
        [_exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitButton setTitle:@"退出登录中..." forState:UIControlStateHighlighted];
        _exitButton.backgroundColor = [UIColor blueColor];
    }
    return _exitButton;
}

#pragma mark - 退出登录
- (void)exit{
    //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
    BaseViewController *baseVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    //返回到上一页面
    [self.navigationController popToViewController:baseVC animated:true];
    baseVC.navigationItem.rightBarButtonItem.title = @"登录";
    baseVC.navigationItem.rightBarButtonItem.action = @selector(jumpLogin);
}

@end
