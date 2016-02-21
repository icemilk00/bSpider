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
@end
