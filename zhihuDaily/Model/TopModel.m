//
//  TopModel.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/1/25.
//

#import "TopModel.h"
#import "HMNetworkTools.h"
@implementation TopModel

+ (void)getDataSuccess:(void (^)(NSArray *array))success{
    //https://news-at.zhihu.com/api/3/news/latest
    [[HMNetworkTools SharedManager]
     GET:@"news/latest"
     parameters:nil
     headers:nil
     progress:^(NSProgress * _Nonnull downloadProgress) {
        }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取返回的数组
        NSArray *tarray = responseObject[@"top_stories"];
        NSMutableArray *tmarry = [[NSMutableArray alloc] init];
        //        字典转模型
        [tarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TopModel *modle = [TopModel newsWithDic:obj];
                            [tmarry addObject:modle];
        }];
        success([tmarry copy]);
        }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"topModelError");
        }];
}


+ (instancetype)newsWithDic:(NSDictionary *)dic{
    TopModel *news = [self new];
    [news setValuesForKeysWithDictionary:dic];
    return news;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
@end
