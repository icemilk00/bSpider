//
//  BaseAPIManager.m
//  DoDemo
//
//  Created by hp on 15/7/14.
//  Copyright (c) 2015年 hp. All rights reserved.
//

#import "BaseAPIManager.h"


#define APIURL  @"http://121.42.29.56:9000"
//#define APIURL  @"http://127.0.0.1:9000"


@implementation BaseAPIManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(APIManager)]) {
            self.child = (id <APIManager>)self;
        }
        else
        {
            NSAssert(NO, @"子类必须要实现APIManager这个protocol");
        }
    }
    return self;
}

#pragma mark - 一般的Get和POST请求发送方法
-(void)sendRequestWithBaseUrlStr:(NSString *)baseUrlStr andParamStr:(NSString *)paramStr andMethod:(NSString *)method
{

    if ([method isEqualToString:@"GET"])
    {
        //发送get请求，这里直接把baseurlstr 和 paramstr 拼接即可
        NSMutableString *sendStr = [[NSMutableString alloc] initWithString:baseUrlStr];
        if (paramStr) {
            [sendStr appendString:[NSString stringWithFormat:@"?%@", paramStr]];
        }

        [self setGETRequestWithUrlStr:sendStr];
    }
    else if ([method isEqualToString:@"POST"])
    {
        //发送post请求，这里发送的url即为baseurlstr，Post体里存放paramstr发送
        NSString *sendStr = baseUrlStr;
        [self setPOSTRequestWithUrlStr:sendStr andParamStr:paramStr];
    }

}

#pragma mark - 未编码
-(void)setGETRequestWithUrlStr:(NSString *)urlStr
{
    RequestManager *manager = [RequestManager manager];
    [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self requestSucessWithOperation:operation andObject:responseObject];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestFailedWithError:error];
     }];
}

-(void)setPOSTRequestWithUrlStr:(NSString *)urlStr andParamStr:(NSString *)paramStr
{
    RequestManager *manager = [RequestManager manager];
    [manager POST:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:paramStr success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self requestSucessWithOperation:operation andObject:responseObject];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestFailedWithError:error];
     }];
}

#pragma mark - 已编码
-(void)setGETRequestWithEncodeUrlStr:(NSString *)urlStr
{
    RequestManager *manager = [RequestManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self requestSucessWithOperation:operation andObject:responseObject];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestFailedWithError:error];
     }];
}

-(void)setPOSTRequestWithEncodeUrlStr:(NSString *)urlStr andParamStr:(NSString *)paramStr
{
    RequestManager *manager = [RequestManager manager];
    [manager POST:urlStr parameters:paramStr success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self requestSucessWithOperation:operation andObject:responseObject];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestFailedWithError:error];
     }];
}
#pragma mark - 请求回调成功 和 失败
-(void)requestSucessWithOperation:(AFHTTPRequestOperation *)operation andObject:(id)responseObject
{
    self.success = YES;
    self.dataSourceDic = [NSDictionary dictionaryWithDictionary:responseObject];
    self.retCode = _dataSourceDic[@"retCode"];
    NSLog(@"dataSourceDic = %@", _dataSourceDic);
    if (self.delegate && [self.delegate respondsToSelector:@selector(APIManagerDidSucess:)]) {
        [self.delegate APIManagerDidSucess:self];
    }
    
    if (self.completeBlock) {
        self.completeBlock(self);
    }
}

-(void)requestFailedWithError:(NSError *)error
{
    NSLog(@"Request error : %@", [error description]);
    self.success = NO;
    self.requestError = error;
    if (self.delegate && [self.delegate respondsToSelector:@selector(APIManagerDidFailed:)]) {
        [self.delegate APIManagerDidFailed:self];
    }
    
    if (self.completeBlock) {
        self.completeBlock(self);
    }
}

#pragma mark - 拼接前缀url
-(NSString *)makeRequestBaseUrl:(NSString *)actionId
{
    return [NSString stringWithFormat:@"%@/api/%@", APIURL, actionId];
}

#pragma mark - DataReformer
-(id)fetchDataWithReformer:(id <ReformerProtocol>)reformer
{
    return [reformer manager:self reformData:self.dataSourceDic];
}

+(NSString *)paramStrForDic:(NSDictionary *)paramDic
{
    if (!paramDic) return nil;
    
    NSMutableString *paramStr = [[NSMutableString alloc] init];
    for (int i = 0; i < paramDic.allKeys.count; i ++) {
        [paramStr appendString:[NSString stringWithFormat:@"%@=%@",paramDic.allKeys[i],paramDic.allValues[i]]];
        if (i != paramDic.allKeys.count - 1) {
            [paramStr appendString:@"&"];
        }
    }
    
    return paramStr;
}

@end

@implementation SMSAPIManager

-(void)getSmsWithCategoryId:(NSString *)categoryId andPageNum:(NSInteger)pageNum
{
    NSString *baseUrlStr = [self makeRequestBaseUrl:@"action=1"];
    
//    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
//    [paramDic setObject:categoryId forKey:@"categoryId"];
//    [paramDic setObject:[NSNumber numberWithInteger:pageNum] forKey:@"page"];
//    
//    NSString *paramStr = [paramDic JSONString];
    
    NSString *paramStr = [NSString stringWithFormat:@"categoryId=%@&page=%d",categoryId, (int)pageNum];
    
    [self sendRequestWithBaseUrlStr:baseUrlStr andParamStr:paramStr andMethod:@"GET"];
}

-(NSString *)apiMethodName
{
    return NSStringFromClass([self class]);
}

@end

#pragma mark - 请求分类的API
@implementation SMSCategoryAPIManager

-(void)getSmsCategory
{
    NSString *baseUrlStr = [self makeRequestBaseUrl:@"action=2"];
    
    [self sendRequestWithBaseUrlStr:baseUrlStr andParamStr:nil andMethod:@"GET"];
}

-(NSString *)apiMethodName
{
    return NSStringFromClass([self class]);
}

@end

#pragma mark - 请求客户端默认配置的API
@implementation DefaultConfigAPIManager

-(void)getDefaultConfig
{
    NSString *baseUrlStr = [self makeRequestBaseUrl:@"action=10000"];
    
    [self sendRequestWithBaseUrlStr:baseUrlStr andParamStr:nil andMethod:@"GET"];
}

-(NSString *)apiMethodName
{
    return NSStringFromClass([self class]);
}

@end




