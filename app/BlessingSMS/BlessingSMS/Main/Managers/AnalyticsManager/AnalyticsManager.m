//
//  AnalyticsManager.m
//  BlessingSMS
//
//  Created by hp on 16/1/17.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "AnalyticsManager.h"

#define SMS_SEND_EVENT  @"1001"
#define SMS_CHOOSE_EVENT  @"1002"
#define CATEGORY_CHOOSE_EVENT  @"1003"

#define HOME_RECOMMEND_EVENT  @"2001"
#define FAV_ITEMCLICKED_EVENT  @"2002"

@implementation AnalyticsManager

+(void)eventSmsSendWithPlatform:(NSString *)platform withCategoryID:(NSString *)categoryID withSMSID:(NSString *)smsID
{
    NSDictionary *dict = @{@"platform" : platform,
                           @"categoryID" : categoryID,
                           @"smsID" : smsID};
    [MobClick event:SMS_SEND_EVENT attributes:dict];
}

+(void)eventSmsChooseWithCategoryID:(NSString *)categoryID withSMSID:(NSString *)smsID
{
    NSDictionary *dict = @{@"categoryID" : categoryID,
                           @"smsID" : smsID};
    [MobClick event:SMS_CHOOSE_EVENT attributes:dict];
}

+(void)eventCategoryChooseWithCategoryID:(NSString *)categoryID withCategoryName:(NSString *)name
{
    NSDictionary *dict = @{@"categoryID" : categoryID,
                           @"name" : name};
    [MobClick event:CATEGORY_CHOOSE_EVENT attributes:dict];
}

+(void)eventHomeRecommendWithCategoryID:(NSString *)categoryID withCategoryName:(NSString *)name
{
    NSDictionary *dict = @{@"categoryID" : categoryID,
                           @"name" : name};
    [MobClick event:HOME_RECOMMEND_EVENT attributes:dict];
}

+(void)eventRecommendClickedWithFavID:(NSString *)favID withItemName:(NSString *)itemName
{
    NSDictionary *dict = @{@"favID" : favID,
                           @"itemName" : itemName};
    [MobClick event:FAV_ITEMCLICKED_EVENT attributes:dict];
}


@end
