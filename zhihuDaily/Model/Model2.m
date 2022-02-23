//
//  Model2.m
//  zhihuDaily
//
//  Created by 潘申冰 on 2022/2/15.
//

#import "Model2.h"
#import "HMNetworkTools.h"
#import "TimeModel.h"


@implementation Model2

+ (void)getDataSuccess:(void (^)(NSArray *array2))success{
    //https://news-at.zhihu.com/api/3/stories/before/日期
    static NSString *string2;
    [TimeModel getDataSuccess:^(NSString * _Nonnull str) {
        NSString * string1 = @"stories/before/";
        if (string2 == nil) {
            string2 = [NSString stringWithFormat:@"%@%@", string1, str];
        }else{
            static int dateTime;
            if (dateTime == 0) {
                dateTime = [str intValue];
            }
            dateTime = dateTime - 1;
            str = [NSString stringWithFormat:@"%d",dateTime];
            string2 = [NSString stringWithFormat:@"%@%@", string1, str];
            }
        
        [[HMNetworkTools SharedManager]
         GET:string2
         parameters:nil
         headers:nil
         progress:^(NSProgress * _Nonnull downloadProgress) {
            }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        //获取返回的数组
            NSArray *array = responseObject[@"stories"];
            NSMutableArray *marry2 = [[NSMutableArray alloc] init];
    //        字典转模型
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Model2 *modle2 = [Model2 newsWithDic:obj];
                        [marry2 addObject:modle2];
    //测试数据            NSLog(@"%@",modle2.title);
            }];
            success([marry2 copy]);
            }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Model2Error");
            }];
        }];
}


+ (instancetype)newsWithDic:(NSDictionary *)dic{
    Model2 *news = [self new];
    [news setValuesForKeysWithDictionary:dic];
    return news;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
@end
