//
//  ClientConfigManager.m
//  BlessingSMS
//
//  Created by hp on 2017/5/23.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "ClientConfigManager.h"

static ClientConfigManager *configManager = nil;

@interface ClientConfigManager ()

@property (strong, nonatomic) DefaultConfigAPIManager *defaultConfigApiManager;

@end

@implementation ClientConfigManager


+(ClientConfigManager *)sharedInstance
{
    @synchronized (self)
    {
        if (configManager == nil) {
            configManager = [[self alloc] init];
        }
    }
    
    return configManager;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (configManager == nil) {
            configManager = [super allocWithZone:zone];
            return  configManager;
        }
    }
    return nil;
}

-(void)initConfig
{
    [self.defaultConfigApiManager getDefaultConfig];
}

#pragma mark - APIManagerDelegate
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    if (manager == self.defaultConfigApiManager)
    {
        NSDictionary *dic = manager.dataSourceDic;
        if (dic && dic[@"clientConfigs"]) {
            self.defaultConfigDic = dic[@"clientConfigs"];
        }
    }
}

-(NSString *)homePageRecommendFavID
{
    if (_defaultConfigDic) {
        return [NSString stringWithFormat:@"%@", _defaultConfigDic[@"recommendCf"][@"homeRecommendID"]];
    }
    
    return @"5580797";
}

-(DefaultConfigAPIManager *)defaultConfigApiManager
{
    if (!_defaultConfigApiManager) {
        _defaultConfigApiManager = [[DefaultConfigAPIManager alloc] init];
        _defaultConfigApiManager.delegate = self;
    }
    return _defaultConfigApiManager;
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
    //    NSLog(@"请求失败: %@", manager.requestError.description);
    
}

@end
