//
//  TBManager.m
//  BlessingSMS
//
//  Created by hp on 2017/5/23.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "TBManager.h"

static TBManager *tbManager = nil;

@interface TBManager ()

@property (nonatomic, strong) NSArray *favList;
@property (strong, nonatomic) TB_FavoritesListAPIManager *tb_FavoritesListApiManager;

@end

@implementation TBManager

+(TBManager *)sharedInstance
{
    @synchronized (self)
    {
        if (tbManager == nil) {
            tbManager = [[self alloc] init];
        }
    }
    
    return tbManager;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (tbManager == nil) {
            tbManager = [super allocWithZone:zone];
            return  tbManager;
        }
    }
    return nil;
}

-(void)initConfig
{
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        NSLog(@"Init sucess");
    } failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];
    
    // 开发阶段打开日志开关，方便排查错误信息
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
    
    // 配置全局的淘客参数
    //如果没有阿里妈妈的淘客账号,setTaokeParams函数需要调用
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams.pid = @"mm_17747039_0_0"; //mm_XXXXX为你自己申请的阿里妈妈淘客pid
    [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
    
    //设置全局的app标识，在电商模块里等同于isv_code
    //没有申请过isv_code的接入方,默认不需要调用该函数
//    [[AlibcTradeSDK sharedInstance] setISVCode:@"your_isv_code"];
    
    // 设置全局配置，是否强制使用h5
    [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
}

-(void)initTBFavList
{
    [self.tb_FavoritesListApiManager getTB_FavoritesList];
}

#pragma mark - APIManagerDelegate
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    if (manager == self.tb_FavoritesListApiManager)
    {
        NSDictionary *dic = manager.dataSourceDic;
        if (dic) {
            
            NSArray *favArray = dic[@"tbk_uatm_favorites_get_response"][@"results"][@"tbk_favorites"];
            if (favArray) {
                self.favList = favArray;
            }
        }
    }
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
    //    NSLog(@"请求失败: %@", manager.requestError.description);

}

-(NSString *)favIDForCategoryID:(NSString *)categoryID
{
    NSString *defFavID = @"";
    
    for (NSDictionary *listItem in _favList) {
        NSString *favTitle = listItem[@"favorites_title"];
        
        if ([favTitle isEqualToString:@"默认推荐"]) {
            defFavID = [NSString stringWithFormat:@"%@", listItem[@"favorites_id"]];
        }
        
        if ([favTitle rangeOfString:categoryID].length > 0) {
            return [NSString stringWithFormat:@"%@", listItem[@"favorites_id"]];
        }
    }
    
    return defFavID;
    
}


-(TB_FavoritesListAPIManager *)tb_FavoritesListApiManager
{
    if (!_tb_FavoritesListApiManager) {
        _tb_FavoritesListApiManager = [[TB_FavoritesListAPIManager alloc] init];
        _tb_FavoritesListApiManager.delegate = self;
    }
    return _tb_FavoritesListApiManager;
}

@end
