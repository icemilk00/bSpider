//
//  ADManager.m
//  BlessingSMS
//
//  Created by hp on 2017/6/1.
//  Copyright © 2017年 hxp. All rights reserved.
//

#define GDT_APPID @"1106197212"
#define GDT_SplashID @"3070684501191623"    //开屏广告位id
#define GDT_NativeID @"6020680663999247"    //原生广告位id
#define GDT_BannerID @"7040886655460813"    //banner广告位id

#import "ADManager.h"
#import "GDTUnifiedBannerView.h"


static ADManager *adManager = nil;

@interface ADManager ()

//@property (strong, nonatomic) GDTSplashAd *splash;
//@property (strong, nonatomic) UIView *bottomView;

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
    
    [GDTSplashAd preloadSplashOrderWithAppId:GDT_APPID placementId:GDT_SplashID];
    //开屏广告初始化并展示代码
    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppId:GDT_APPID placementId:GDT_SplashID];
    splash.delegate = APPDELEGATE; //设置代理
    
    //根据iPhone设备不同设置不同背景图
    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
        splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]];
    } else {
        splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage
                                                                 imageNamed:@"LaunchImage"]]; }
    splash.fetchDelay = 10; //开发者可以设置开屏拉取时间，超时则放弃展示
    //[可选]拉取并展示全屏开屏广告
    //设置开屏底部自定义LogoView，展示半屏开屏广告
    UIView *_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon60"]];
    [_bottomView addSubview:logo];
    logo.center = _bottomView.center;
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    [splash loadAdAndShowInWindow:APPDELEGATE.window withBottomView:_bottomView];
    
}


@end
