//
//  TimeModel.h
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/15.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface TimeModel : NSObject
@property (nonatomic, copy) NSString *date;

//getDataSuccess
+ (void)getDataSuccess: (void (^)(NSString *str))success;

@end

NS_ASSUME_NONNULL_END
