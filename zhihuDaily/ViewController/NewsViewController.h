//
//  NewsViewController.h
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/12.
//
//  自定义ViewController作为新闻详情页
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsViewController : UIViewController

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *Id;

@end

NS_ASSUME_NONNULL_END
