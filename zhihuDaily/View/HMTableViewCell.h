//
//  homePage-TableViewCell.h
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/1/22.
//
//  自定义TableViewCell样式
#import <UIKit/UIKit.h>
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMTableViewCell : UITableViewCell
//titleLable
@property (nonatomic, strong) UILabel *tLable;
//authorLable
@property (nonatomic, strong) UILabel *atLable;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) Model *news;
@end

NS_ASSUME_NONNULL_END
