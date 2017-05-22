//
//  AppDelegate.m
//  BlessingSMS
//
//  Created by hp on 15/12/30.
//  Copyright © 2015年 hxp. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[ShareManager sharedInstance] shareInit];
    [PushManager startApp];
    [PushManager registerPushNofitication];
    [PushManager handleLaunching:launchOptions];
    [MobClick startWithAppkey:UMAPPKEY reportPolicy:BATCH   channelId:@"AppStore"];
    
    
    
    
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
    [[AlibcTradeSDK sharedInstance] setISVCode:@"your_isv_code"];
    
    // 设置全局配置，是否强制使用h5
    [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
    
    
    
    
    
    
    
    
    
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    

    NSDictionary *remoteNotify = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [PushManager showPushAlert:remoteNotify];
    
    BaseNavController *navigationController = [[BaseNavController alloc] initWithRootViewController:[[MainShowViewController alloc] init]];
    UIViewController *leftMenuViewController = [[LeftMenuViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
//    sideMenuViewController.delegate = self;
//    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
//    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
//    sideMenuViewController.contentViewShadowOpacity = 0.6;
//    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    
    self.window.backgroundColor = DEFAULT_BG_COLOR;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -  Open Platform

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    // 新接口写法
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // 处理其他app跳转到自己的app
        return YES;
    }
    else
    {
        return YES;
    }
    
    return [[ShareManager sharedInstance] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [[ShareManager sharedInstance] handleOpenURL:url];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [PushManager registerDevice:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"notif.userinfo = %@", notification.userInfo);
    NSString *keyStr = [notification.userInfo.allKeys firstObject];
    NSString *valueStr = [notification.userInfo.allValues firstObject];
    
    NSDictionary *userInfo = @{@"content":valueStr};
    [PushManager showPushAlert:userInfo];
//    [PushManager localNotificationAtFrontEnd:notification userInfoKey:keyStr userInfoValue:valueStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *pushDate = [formatter dateFromString:keyStr];
    
    NSDateComponents *c = [pushDate YMDComponents];
    CalendarDataModel *model = [CalendarDataModel calendarModuleWithYear:c.year month:c.month day:c.day];
    NSString *saveKey = [NSString stringWithFormat:@"%lu|%lu|%lu", (unsigned long)model.year, (unsigned long)model.month, (unsigned long)model.day];
    
    NSMutableArray *m_array = [[CalendarNotifiCenter defaultCenter] calendarNotiDicWithKey:saveKey];
    
    for (CalendarNotiModel *notiModel in m_array) {
        if ([notiModel.notiContent isEqualToString:valueStr]) {
            notiModel.isExpired = YES;
            [[CalendarNotifiCenter defaultCenter] editNotifi:notiModel withIndex:[m_array indexOfObject:notiModel]];
        }
    }
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [PushManager handleReceiveNotification:userInfo];
    [PushManager showPushAlert:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
