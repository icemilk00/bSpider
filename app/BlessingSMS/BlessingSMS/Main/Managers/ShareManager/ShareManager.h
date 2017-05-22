//
//  ShareManager.h
//  BlessingSMS
//
//  Created by hp on 16/1/14.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

typedef enum{
    typeWeixin = 0,
    typeSinaWeibo,
    typeQQ
} OpenPlatformType;

@interface ShareManager : NSObject <WXApiDelegate, WeiboSDKDelegate,WBHttpRequestDelegate,TencentSessionDelegate,TencentLoginDelegate>

+(ShareManager *)sharedInstance;
-(void)shareInit;
-(BOOL)handleOpenURL:(NSURL *)url;

-(void)shareToWeixinWithText:(NSString *)shareText;
-(void)shareToWeixinZoneWithText:(NSString *)shareText;
-(void)shareToWeiboWithText:(NSString *)shareText;
-(void)shareToQQWithText:(NSString *)shareText;


@end
