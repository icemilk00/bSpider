//
//  PushManager.m
//  BlessingSMS
//
//  Created by hp on 16/2/1.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "PushManager.h"
#import "XGPush.h"
#import "XGSetting.h"

#define _IPHONE80_ 80000

#define XG_PUSH_ACCESS_ID   2200180934
#define XG_PUSH_ACCESS_KEY  @"IMTK722V6F8H"
#define XG_PUSH_SECRET_KEY  @"0489552b9d0c14590bb914d92138d7f9"

@implementation PushManager

+(void)registerPushNofitication {
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [[self class] registerPush];
            }
            else{
                [[self class] registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
//    [[self class] setAccount:@"123"];
}

+(void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

+ (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

+(void)registerDevice:(NSData *)deviceToken{
    [XGPush registerDevice:deviceToken];
}

+(void)startApp{
    [XGPush startApp:XG_PUSH_ACCESS_ID appKey:XG_PUSH_ACCESS_KEY];
}

+(void)setAccount:(NSString *)account
{
    [XGPush setAccount:account];
}

+(void)handleReceiveNotification:(NSDictionary *)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
}

+(void)handleLaunching:(NSDictionary *)launchOptions
{
    [XGPush handleLaunching:launchOptions];
}

+(void)showPushAlert:(NSDictionary *)userInfo
{
    NSString *content = userInfo[@"content"];
    
    if (content && content.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:content delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

+(void)localNotification:(NSDate *)fireDate alertBody:(NSString *)alertBody badge:(int)badge alertAction:(NSString *)alertAction userInfo:(NSDictionary *)userInfo
{
    [XGPush localNotification:fireDate alertBody:alertBody badge:badge alertAction:alertAction userInfo:userInfo];
}

+(void)localNotificationAtFrontEnd:(UILocalNotification *)notification userInfoKey:(NSString *)userInfoKey userInfoValue:(NSString *)userInfoValue
{
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:userInfoKey userInfoValue:userInfoValue];
}

+(void)delLocalNotification:(UILocalNotification *)myUILocalNotification
{
    [XGPush delLocalNotification:myUILocalNotification];
}

+(void)delLocalNotification:(NSString *)userInfoKey userInfoValue:(NSString *)userInfoValue
{
    [XGPush delLocalNotification:userInfoKey userInfoValue:userInfoValue];
}

+(void)clearLocalNotifications
{
    [XGPush clearLocalNotifications];
}

+(NSArray *)localNotifications
{
    return  [UIApplication sharedApplication].scheduledLocalNotifications;
}

/*
 *  key为日期  value为content内容
 */

+(BOOL)isHasLocalNotificationWithKey:(NSString *)key andValue:(NSString *)value
{
    for (UILocalNotification *notifi in [PushManager localNotifications]) {
        NSDictionary *userInfo = notifi.userInfo;
        if (userInfo) {
            NSString *userInfoValue = userInfo[key];
            if ([userInfoValue isEqualToString:value]) {
                return YES;
            }
        }
    }
    
    return NO;
}

+(UILocalNotification *)localNotiWithKey:(NSString *)key andValue:(NSString *)value
{
    for (UILocalNotification *notifi in [PushManager localNotifications]) {
        NSDictionary *userInfo = notifi.userInfo;
        if (userInfo) {
            NSString *userInfoValue = userInfo[key];
            if ([userInfoValue isEqualToString:value]) {
                return notifi;
            }
        }
    }
    
    return nil;
}

@end
