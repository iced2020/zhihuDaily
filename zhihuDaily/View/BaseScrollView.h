//
//  BaseScrollView.h
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/9.
//
//  自定义ScrollView作为主页最底层视图，允许多手势
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseScrollView : UIScrollView<UIGestureRecognizerDelegate>

@end

NS_ASSUME_NONNULL_END
