//
//  TimeModel.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/15.
//

#import "TimeModel.h"
#import "HMNetworkTools.h"

@implementation TimeModel

+ (void)getDataSuccess:(void (^)(NSString * _Nonnull))success{
    //https://news-at.zhihu.com/api/3/news/latest
    [[HMNetworkTools SharedManager]
     GET:@"news/latest"
     parameters:nil
     headers:nil
     progress:^(NSProgress * _Nonnull downloadProgress) {
        }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //获取返回的数组
        NSString *str = responseObject[@"date"];
        success([str copy]);
        }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error");
        }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
@end
