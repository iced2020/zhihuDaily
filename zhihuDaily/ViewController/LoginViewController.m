//
//  LoginViewController.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/11.
//

#import "LoginViewController.h"
#import "BaseViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong)UILabel *loginLabel;
@property (nonatomic, strong)UILabel *welcomeLabel;
@property (nonatomic, strong)UITextField *nameTextField;
@property (nonatomic, strong)UITextField *pwdTextField;
@property (nonatomic, strong)UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUserInfo];
    [self.view addSubview:self.loginLabel];
    [self.view addSubview:self.welcomeLabel];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.pwdTextField];
    [self.view addSubview:self.loginButton];
    self.Logined = NO;
}


#pragma mark - lan加载
- (UILabel *)loginLabel{
    if(_loginLabel == nil){
        _loginLabel = [[UILabel alloc]init];
        _loginLabel.text =@"登录";
        _loginLabel.frame =CGRectMake(15, 110, 88, 68);
        _loginLabel.font = [UIFont boldSystemFontOfSize:40];
        _loginLabel.textColor = [UIColor blueColor];
    }
    return _loginLabel;
}

- (UILabel *)welcomeLabel{
    if(_welcomeLabel == nil){
        _welcomeLabel = [[UILabel alloc]init];
        _welcomeLabel.text =@"您好，欢迎来到知乎日报！";
        _welcomeLabel.frame =CGRectMake(15, 175, 216, 28);
        _welcomeLabel.font = [UIFont boldSystemFontOfSize:16];
        _welcomeLabel.textColor = [UIColor grayColor];
        _welcomeLabel.numberOfLines = 0;
    }
    return _welcomeLabel;
}

- (UITextField *)nameTextField{
    if (_nameTextField == nil) {
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, 210, 270, 40)];
        _nameTextField.placeholder = @"请输入账号（默认admin）";
        _nameTextField.font = [UIFont systemFontOfSize:20];
        _nameTextField.borderStyle = UITextBorderStyleRoundedRect;//边框样式
    }
    return _nameTextField;
}

- (UITextField *)pwdTextField{
    if (_pwdTextField == nil) {
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, 270, 270, 40)];
        _pwdTextField.placeholder = @"请输入密码（默认admin）";
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.font = [UIFont systemFontOfSize:20];
        _pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
        _pwdTextField.clearButtonMode = UITextFieldViewModeAlways;//显示一次性清除的×
    }
    return _pwdTextField;
}

- (UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc]init];
        _loginButton.frame =CGRectMake(30, 360, 315, 52);
        //给控件加圆角
        _loginButton.layer.cornerRadius = 25;
        [_loginButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录中..." forState:UIControlStateHighlighted];
        _loginButton.backgroundColor = [UIColor blueColor];
    }
    return _loginButton;
}


#pragma mark - 点击登录按钮调用的方法
- (void)buttonClick{
    NSString *name = self.nameTextField.text;
    NSString *pwd = self.pwdTextField.text;
    [self login:name pwd:pwd];
}

- (void)login:(NSString *)name pwd:(NSString *)pwd {
    NSLog(@"%@",pwd);
    if ([name isEqual: @""] || [pwd isEqual: @""]) {
        [self showError:@"用户名和密码不能为空！"];
    }else if ([name isEqual: @"admin"] && [pwd isEqual: @"admin"]){
        NSLog(@"yes");
        self.Logined = YES;
        [self saveUserInfo];
        [self goBackTobaseVC];
    }else{
        [self showError:@"用户名与密码输入错误！默认用户名与密码均为admin"];
    }
}

#pragma mark -弹框提醒
- (void)showError:(NSString *)errorMsg {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - 返回上一页面
- (void)goBackTobaseVC{
    //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
    BaseViewController *baseVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    //返回到上一页面
    [self.navigationController popToViewController:baseVC animated:true];
    baseVC.navigationItem.rightBarButtonItem.title = @"个人";
    baseVC.navigationItem.rightBarButtonItem.action = @selector(jumpPerson);
}

#pragma mark - 保存用户名和密码
//登录成功后把密码保存到沙盒中（用户偏好设置）
- (void)saveUserInfo{
    //NSUserDefaults特殊的初始化
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.nameTextField.text forKey:@"name"];
    [userDefaults setObject:self.pwdTextField.text forKey:@"pwd"];
    //立即保存数据
    [userDefaults synchronize];
}
//当重新加载应用，读取沙盒中的用户信息
- (void)loadUserInfo{
    //NSUserDefaults特殊的初始化
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.nameTextField.text = [userDefaults objectForKey:@"name"];
    self.pwdTextField.text = [userDefaults objectForKey:@"pwd"];
}

@end
