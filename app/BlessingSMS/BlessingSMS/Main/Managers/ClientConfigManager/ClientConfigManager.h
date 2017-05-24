//
//  ClientConfigManager.h
//  BlessingSMS
//
//  Created by hp on 2017/5/23.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientConfigManager : NSObject <APIManagerDelegate>

+(ClientConfigManager *)sharedInstance;

-(void)initConfig;

@property (nonatomic, strong) NSDictionary *defaultConfigDic;

-(NSString *)homePageRecommendFavID;    //配置的首页默认进入的推荐页
-(NSString *)defaultPageRecommendFavID; //配置的默认进入的推荐页
-(BOOL)canGoDetailPage;                 //配置是否可以点击推荐商品进入详情页
@end
