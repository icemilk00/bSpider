//
//  ADManager.m
//  BlessingSMS
//
//  Created by hp on 2017/6/1.
//  Copyright © 2017年 hxp. All rights reserved.
//

#define GDT_APPID @"111111"
#define GDT_POSID @"222222"

#import "ADManager.h"


static ADManager *adManager = nil;

@interface ADManager ()

//@property (strong, nonatomic) GDTSplashAd *splash;
//@property (strong, nonatomic) UIView *bottimView;

@end

@implementation ADManager

+(ADManager *)sharedInstance
{
    @synchronized (self)
    {
        if (adManager == nil) {
            adManager = [[self alloc] init];
        }
    }
    
    return adManager;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (adManager == nil) {
            adManager = [super allocWithZone:zone];
            return  adManager;
        }
    }
    return nil;
}


+(void)showSplashAD
{
    //开屏广告初始化并展示代码
    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppkey:@"3630" placementId:@"88633644363093"];
    splash.delegate = APPDELEGATE; //设置代理
    
    //根据iPhone设备不同设置不同背景图
    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
        splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]];
    } else {
        splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage
                                                                 imageNamed:@"LaunchImage"]]; }
    splash.fetchDelay = 3; //开发者可以设置开屏拉取时间，超时则放弃展示
    //[可选]拉取并展示全屏开屏广告
    [splash loadAdAndShowInWindow:APPDELEGATE.window];
    //设置开屏底部自定义LogoView，展示半屏开屏广告
//    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
//    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashBottomLogo"]];
//    [_bottomView addSubview:logo];
//    logo.center = _bottomView.center;
//    _bottomView.backgroundColor = [UIColor whiteColor];
}


@end
