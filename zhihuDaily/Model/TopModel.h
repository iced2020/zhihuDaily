//
//  TopModel.h
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/1/25.
//
//  上方图片轮播新闻数据模型
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopModel : NSObject
@property (nonatomic,copy) NSString *image_hue;
@property (nonatomic,copy) NSString *hint;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ga_prefix;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *Id;
//图片数组
@property (nonatomic, strong) NSArray *arrImg;
//title数组
@property (nonatomic, strong) NSArray *arrTitle;

//getDataSuccess
+ (void)getDataSuccess: (void (^)(NSArray *array))success;

//newsWithDic
+ (instancetype)newsWithDic: (NSDictionary *) dic;
@end

NS_ASSUME_NONNULL_END
