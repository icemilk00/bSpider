//
//  AnalyticsManager.h
//  BlessingSMS
//
//  Created by hp on 16/1/17.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *eventSMSSendFirst = @"eventSMSSendFirst";
static NSString *eventSMSSendSecond = @"eventSMSSendSecond";
static NSString *eventSMSSendToWeixin = @"eventSMSSendToWeixin";
static NSString *eventSMSSendToWeixinZone = @"eventSMSSendToWeixinZone";
static NSString *eventSMSSendToWeibo = @"eventSMSSendToWeibo";
static NSString *eventSMSSendToQQ = @"eventSMSSendToQQ";

static NSString *eventHomeRecommend = @"eventHomeRecommend";
static NSString *eventRecommendClicked = @"eventRecommendClicked";

@interface AnalyticsManager : NSObject

+(void)eventSmsSendWithPlatform:(NSString *)platform withCategoryID:(NSString *)categoryID withSMSID:(NSString *)smsID;
+(void)eventSmsChooseWithCategoryID:(NSString *)categoryID withSMSID:(NSString *)smsID;
+(void)eventCategoryChooseWithCategoryID:(NSString *)categoryID withCategoryName:(NSString *)name;

+(void)eventHomeRecommendWithCategoryID:(NSString *)categoryID withCategoryName:(NSString *)name;
+(void)eventRecommendClickedWithFavID:(NSString *)favID withItemName:(NSString *)itemName;

@end
