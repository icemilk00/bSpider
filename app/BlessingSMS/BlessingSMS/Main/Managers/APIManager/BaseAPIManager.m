//
//  BaseAPIManager.m
//  DoDemo
//
//  Created by hp on 15/7/14.
//  Copyright (c) 2015年 hp. All rights reserved.
//

#import "BaseAPIManager.h"

#define APIURL  @"http://m.mvbox.cn/"

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

#pragma mark -- 一般的Get和POST请求发送方法 --
-(void)sendRequestWithBaseUrlStr:(NSString *)baseUrlStr andParamStr:(NSString *)paramStr andMethod:(NSString *)method
{
    
    NSString *sendStr = nil;
    if ([method isEqualToString:@"GET"])
    {
        //发送get请求，这里直接把baseurlstr 和 paramstr 拼接即可
        sendStr = [NSString stringWithFormat:@"%@&%@",baseUrlStr, paramStr];
    }
    else if ([method isEqualToString:@"POST"])
    {
        //发送post请求，这里发送的url即为baseurlstr，Post体里存放paramstr发送
        sendStr = baseUrlStr;
    }
    
    RequestManager *manager = [RequestManager manager];
    if ([method isEqualToString:@"GET"]) {
        [manager GET:[sendStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self requestSucessWithOperation:operation andObject:responseObject];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self requestFailedWithError:error];
         }];
    }
    else if ([method isEqualToString:@"POST"])
    {
        [manager POST:[sendStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:paramStr success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [self requestSucessWithOperation:operation andObject:responseObject];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [self requestFailedWithError:error];
        }];
    }
}

#pragma mark -- 请求回调成功 --
-(void)requestSucessWithOperation:(AFHTTPRequestOperation *)operation andObject:(id)responseObject
{
    self.dataSourceDic = [NSDictionary dictionaryWithDictionary:responseObject];
    self.retCode = _dataSourceDic[@"retCode"];
    NSLog(@"dataSourceDic = %@", _dataSourceDic);
    if (self.delegate && [self.delegate respondsToSelector:@selector(APIManagerDidSucess:)]) {
        [self.delegate APIManagerDidSucess:self];
    }
}

#pragma mark -- 请求回调失败 --
-(void)requestFailedWithError:(NSError *)error
{
    NSLog(@"Request error : %@", [error description]);
    self.requestError = error;
    if (self.delegate && [self.delegate respondsToSelector:@selector(APIManagerDidFailed:)]) {
        [self.delegate APIManagerDidFailed:self];
    }
}

#pragma mark -- 拼接url --
-(NSString *)makeRequestBaseUrl:(NSString *)actionId
{
    return [NSString stringWithFormat:@"%@sod?%@", APIURL, actionId];
}

@end

@implementation RiHanMaleSingersListAPIManager

-(void)getDataWithCategoryId:(NSString *)categoryId andLastUpdateTime:(NSString *)lastUpdateTime
{
    NSString *baseUrlStr = [self makeRequestBaseUrl:@"action=1"];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:categoryId forKey:@"categoryID"];
    [paramDic setObject:@"0" forKey:@"beginIndex"];
    [paramDic setObject:@"30" forKey:@"rows"];
    [paramDic setObject:lastUpdateTime forKey:@"newTime"];
    
    NSString *paramStr = [paramDic JSONString];
    
    paramStr = [NSString stringWithFormat:@"parameter=%@",paramStr];
    
    [self sendRequestWithBaseUrlStr:baseUrlStr andParamStr:paramStr andMethod:@"GET"];
}

-(NSString *)apiMethodName
{
    return NSStringFromClass([self class]);
}

@end