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

#define CURRENT_IOS_VERISON [[[UIDevice currentDevice] systemVersion] floatValue]   //当前版本号

#define STATENBAR_HEIGHT     (20.0f)                                                //状态栏默认高度
#define NAVIGATIONBAR_HEIGHT (CURRENT_IOS_VERISON >= 7 ? 64.0f:44.0f)               //导航栏默认高度

#define VIEW_FRAME_WITH_NAV  CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGTH - NAVIGATIONBAR_HEIGHT)

#define DEFAULT_BG_COLOR [UIColor colorWithRed:246/255.0f green:56/255.0f blue:56/255.0f alpha:1]

#define UMAPPKEY @"569a695ce0f55af3f60019a5"

#endif
