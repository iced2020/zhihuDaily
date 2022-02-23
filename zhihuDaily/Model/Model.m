//
//  Model.m
//  
//
//  Created by 潘申冰 on 2022/1/19.
//

#import "Model.h"
#import "HMNetworkTools.h"
@implementation Model

+ (void)getDataSuccess:(void (^)(NSArray *array))success{
    //https://news-at.zhihu.com/api/3/news/latest
    [[HMNetworkTools SharedManager]
     GET:@"news/latest"
     parameters:nil
     headers:nil
     progress:^(NSProgress * _Nonnull downloadProgress) {
        }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //获取返回的数组
        NSArray *array = responseObject[@"stories"];
        NSMutableArray *marry = [[NSMutableArray alloc] init];
//        字典转模型
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Model *modle = [Model newsWithDic:obj];
                    [marry addObject:modle];
//测试数据
//            NSLog(@"%@",modle.Id);
        }];
        success([marry copy]);
        }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error");
        }];
}


+ (instancetype)newsWithDic:(NSDictionary *)dic{
    Model *news = [self new];
    [news setValuesForKeysWithDictionary:dic];
    return news;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
@end
