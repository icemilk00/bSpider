//
//  AppDelegate.m
//  BlessingSMS
//
//  Created by hp on 15/12/30.
//  Copyright © 2015年 hxp. All rights reserved.
//

#import "AppDelegate.h"
#import "SMSTabbarController.h"
#import "HaoWuViewController.h"
#import "CalendarViewController.h"
@interface AppDelegate ()
@property (nonatomic, strong) BaseNavController *navigationController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [ADManager showSplashAD];
    [[ClientConfigManager sharedInstance] initConfig];
    
    [[ShareManager sharedInstance] shareInit];
    [PushManager startApp];
    [PushManager registerPushNofitication];
    [PushManager handleLaunching:launchOptions];
    [MobClick startWithAppkey:UMAPPKEY reportPolicy:BATCH   channelId:@"AppStore"];
    
    [[TBManager sharedInstance] initConfig];    //初始化SDK
    [[TBManager sharedInstance] initTBFavList]; //获取选品库列表
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    NSDictionary *remoteNotify = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [PushManager showPushAlert:remoteNotify];
    

    UIViewController *leftMenuViewController = [[LeftMenuViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:[[MainShowViewController alloc] init]
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
    
    SMSTabbarController *tabbar = [[SMSTabbarController alloc] init];
    [tabbar addChildVc:sideMenuViewController title:@"短信" image:@"短信1" selectedImage:@"短信2"];
    [tabbar addChildVc:[HaoWuViewController new] title:@"好物" image:@"好物1" selectedImage:@"好物2"];
    [tabbar addChildVc:[CalendarViewController new] title:@"提醒" image:@"闹钟1" selectedImage:@"闹钟2"];
    
    self.navigationController = [[BaseNavController alloc] initWithRootViewController:tabbar];
    self.navigationController.navigationBarHidden = YES;
    
    UIViewController *vc = [[UIViewController alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:vc.view.bounds];
    imageView.backgroundColor = [UIColor whiteColor];
    [vc.view addSubview:imageView];
    
    self.window.rootViewController = vc;
    self.window.backgroundColor = DEFAULT_BG_COLOR;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd {
    
    self.window.rootViewController = self.navigationController;
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd {
    
    self.window.rootViewController = self.navigationController;
}

/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    self.window.rootViewController = self.navigationController;
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
