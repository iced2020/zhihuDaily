//
//  HMNetworkTools.m
//  
//
//  Created by 潘申冰 on 2022/1/19.
//

#import "HMNetworkTools.h"

@implementation HMNetworkTools

+ (instancetype)SharedManager{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //BaseURL:https://news-at.zhihu.com/api/3/
        NSURL *BaseURL = [NSURL URLWithString:@"https://news-at.zhihu.com/api/3/"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //配置超时
        configuration.timeoutIntervalForRequest = 12;
        
        instance = [[self alloc] initWithBaseURL:BaseURL sessionConfiguration:configuration];
    });
    
    return instance;
}
@end
