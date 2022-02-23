//
//  AppDelegate.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/1/20.
//

#import "AppDelegate.h"
#import "baseViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 创建Tab所属的ViewController
    BaseViewController *mainVC = [[BaseViewController alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    mainNav.navigationBar.translucent = NO;
    
    NSArray *vcsArray = [NSArray arrayWithObjects:mainNav, nil];
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    [[UITabBar appearance] setBackgroundColor:[UIColor grayColor]];
    
    //设置多个Tab的ViewController到TabBarViewController
    tabBarVC.viewControllers = vcsArray;
    
    //将UITabBarController设置为Window的RootViewController
    self.window.rootViewController = tabBarVC;
    self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    //显示Window
    [self.window makeKeyAndVisible];
    
    
    
//    self.window = [[UIWindow alloc]init];
//
//    baseViewController *VC = [[baseViewController alloc]init];
//
//    self.window.rootViewController = VC;
//
//    [self.window makeKeyAndVisible];
//
    return YES;
}

@end
