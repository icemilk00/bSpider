//
//  CommonDefine.h
//  FDCommonFrameWork
//
//  Created by hp on 15/10/22.
//  Copyright (c) 2015年 hxp. All rights reserved.
//

#ifndef FDCommonFrameWork_CommonDefine_h
#define FDCommonFrameWork_CommonDefine_h

#define APPDELEGATE  ((AppDelegate *)([UIApplication sharedApplication].delegate))  //Appdelegate 全局对象

#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)               //屏幕宽
#define SCREEN_HEIGTH       ([UIScreen mainScreen].bounds.size.height)              //屏幕高
#define STATENBAR_HEIGHT  (isFullScreen ? 44 : 20)      //状态栏默认高度
#define TABBAR_HEIGHT     (isFullScreen ? 83 : 49)
#define BOTTOMDangerArea_HEIGHT (isFullScreen ? 34 : 0)
#define NAVIGATIONBAR_HEIGHT  (isFullScreen ? 88 : 64)  //导航栏默认高度

#define  isIphoneX_XS     (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? YES : NO)

//iPhoneXR / iPhoneXSMax
#define  isIphoneXR_XSMax    (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f ? YES : NO)

//全面屏
#define   isFullScreen    (iPhoneX || iPhoneXR || iPhoneXM)


#define CURRENT_IOS_VERISON [[[UIDevice currentDevice] systemVersion] floatValue]   //当前版本号


#define VIEW_FRAME_WITH_NAV  CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGTH - NAVIGATIONBAR_HEIGHT)

#define DEFAULT_BG_COLOR [UIColor colorWithRed:246/255.0f green:56/255.0f blue:56/255.0f alpha:1]

#define RGB_COLOR(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

#define UMAPPKEY @"569a695ce0f55af3f60019a5"


//判断 设备  iphone4s
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//判断 设备  iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断 设备  iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断 设备  iphone6 plus
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断 设备 iphoneX 或者iphoneXs （5.8英寸）
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断 设备 iphoneXR （6.1英寸,2倍像素）
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) : NO)

//判断 设备 iphoneXs Max （6.5英寸）
#define iPhoneXM ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#endif
