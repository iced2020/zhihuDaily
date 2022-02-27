//
//  Model.h
//  333
//
//  Created by 潘申冰 on 2022/1/19.
//
//  当日新闻数据模型
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject
@property (nonatomic, copy) NSString *image_hue;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *hint;
@property (nonatomic, copy) NSString *ga_prefix;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *Id;

//getDataSuccess
+ (void)getDataSuccess: (void (^)(NSArray *array))success;

//newsWithDic
+ (instancetype)newsWithDic: (NSDictionary *) dic;
@end

NS_ASSUME_NONNULL_END
