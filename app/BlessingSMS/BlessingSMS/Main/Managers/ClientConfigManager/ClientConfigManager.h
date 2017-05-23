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

-(NSString *)homePageRecommendFavID;
@end
