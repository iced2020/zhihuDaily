//
//  HMNetworkTools.h
//  
//
//  Created by 潘申冰 on 2022/1/19.
//

#import <AFNetworking/AFNetworking.h>//网络数据获取

NS_ASSUME_NONNULL_BEGIN

@interface HMNetworkTools : AFHTTPSessionManager
+ (instancetype)SharedManager;
@end

NS_ASSUME_NONNULL_END
