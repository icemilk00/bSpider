//
//  PushManager.h
//  BlessingSMS
//
//  Created by hp on 16/2/1.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushManager : NSObject
+(void)registerPushNofitication;
+(void)registerDevice:(NSData *)deviceToken;
+(void)setAccount:(NSString *)account;
+(void)startApp;
+(void)handleReceiveNotification:(NSDictionary *)userInfo;
+(void)handleLaunching:(NSDictionary *)launchOptions;
+(void)showPushAlert:(NSDictionary *)userInfo;

+(void)localNotification:(NSDate *)fireDate alertBody:(NSString *)alertBody badge:(int)badge alertAction:(NSString *)alertAction userInfo:(NSDictionary *)userInfo;
+(void)localNotificationAtFrontEnd:(UILocalNotification *)notification userInfoKey:(NSString *)userInfoKey userInfoValue:(NSString *)userInfoValue;
+(void)delLocalNotification:(UILocalNotification *)myUILocalNotification;
+(void)delLocalNotification:(NSString *)userInfoKey userInfoValue:(NSString *)userInfoValue;
+(NSArray *)localNotifications;
+(BOOL)isHasLocalNotificationWithKey:(NSString *)key andValue:(NSString *)value;
+(UILocalNotification *)localNotiWithKey:(NSString *)key andValue:(NSString *)value;

+(void)clearLocalNotifications;
@end
