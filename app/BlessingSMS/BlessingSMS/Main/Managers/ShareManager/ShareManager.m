//
//  ShareManager.m
//  BlessingSMS
//
//  Created by hp on 16/1/14.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "ShareManager.h"


#define WEIXIN_APPKEY   @"wxfd6eaef51f212434"
#define WEIBO_APPKEY    @"3612230762"

#define QQ_APPID        @"1105111422"
#define QQ_APPKEY       @"cv5irR2yJZSRfsL6"

static ShareManager *shareManager = nil;

@interface ShareManager ()
{
    OpenPlatformType _openPlatformType;
    NSString *_shareText;
}
@property (nonatomic, strong) NSArray *tencentPermissionsArray;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation ShareManager

+(ShareManager *)sharedInstance
{
    @synchronized (self)
    {
        if (shareManager == nil) {
            shareManager = [[self alloc] init];
        }
    }
    
    return shareManager;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (shareManager == nil) {
            shareManager = [super allocWithZone:zone];
            return  shareManager;
        }
    }
    return nil;
}

-(void)shareInit
{
    //向微信注册
    [WXApi registerApp:WEIXIN_APPKEY withDescription:@"BlessingSMS_Weixin"];
    
    //向新浪微博注册
    [WeiboSDK registerApp:WEIBO_APPKEY];
    
    //QQ开放平台
    _tencentPermissionsArray = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_USER_INFO,
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                kOPEN_PERMISSION_ADD_ALBUM,
                                kOPEN_PERMISSION_ADD_IDOL,
                                kOPEN_PERMISSION_ADD_ONE_BLOG,
                                kOPEN_PERMISSION_ADD_PIC_T,
                                kOPEN_PERMISSION_ADD_SHARE,
                                kOPEN_PERMISSION_ADD_TOPIC,
                                kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                kOPEN_PERMISSION_DEL_IDOL,
                                kOPEN_PERMISSION_DEL_T,
                                kOPEN_PERMISSION_GET_FANSLIST,
                                kOPEN_PERMISSION_GET_IDOLLIST,
                                kOPEN_PERMISSION_GET_INFO,
                                kOPEN_PERMISSION_GET_OTHER_INFO,
                                kOPEN_PERMISSION_GET_REPOST_LIST,
                                kOPEN_PERMISSION_LIST_ALBUM,
                                kOPEN_PERMISSION_UPLOAD_PIC,
                                kOPEN_PERMISSION_GET_VIP_INFO,
                                kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                                kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                                kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                                nil];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:self];
}

-(BOOL)handleOpenURL:(NSURL *)url
{
    if (_openPlatformType == typeSinaWeibo) {
        return  [WeiboSDK handleOpenURL:url delegate:self];
    }
    else if (_openPlatformType == typeQQ)
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    return NO;
}

#pragma mark  ---- 第三方应用收到weibo的请求回应 ----
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    NSLog(@"weibo response . statusCode = %d", (int)response.statusCode);
    if (response.statusCode != WeiboSDKResponseStatusCodeSuccess) {
        //weibo返回码为失败的
        
        //        [ShowHUDTool showHUDByCodeWithCode:type_weiboFail withHiddenDelay:1.5];
        return;
    }
    
    //第三方应用收到weibo的请求回应，必须有此方法，否则点击取消时会奔溃
    if ([[response.requestUserInfo objectForKey:@"RequestType"] isEqualToString:@"SinaWeibo_SSO_Login"]) {
        NSLog(@"SSO_Loginresponse = %@", response);
        //sso认证返回的处理方法
        NSString *uid = ((WBAuthorizeResponse *)response).userID;
        NSString *accessToken = ((WBAuthorizeResponse *)response).accessToken;
        NSDate *expirationDate = ((WBAuthorizeResponse *)response).expirationDate;
        
        NSDictionary *objectDic = [NSDictionary dictionaryWithObjectsAndKeys:uid, @"uid",
                                   accessToken, @"accessToken", nil];
        
        long expirSeconds = expirationDate.timeIntervalSince1970;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:expirSeconds] forKey:@"token0expirDate"];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"token0"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sinaWeiBoLogin" object:objectDic];
    }
    else if ([[response.requestUserInfo objectForKey:@"RequestType"] isEqualToString:@"SinaWeibo_SSO_Bind"])
    {
        NSLog(@"SSO_Bind, response = %@", response);
        //sso认证返回的处理方法
        NSString *uid = ((WBAuthorizeResponse *)response).userID;
        NSString *accessToken = ((WBAuthorizeResponse *)response).accessToken;
        NSDate *expirationDate = ((WBAuthorizeResponse *)response).expirationDate;
        
        NSDictionary *objectDic = [NSDictionary dictionaryWithObjectsAndKeys:uid, @"uid",
                                   accessToken, @"accessToken", nil];
        
        long expirSeconds = expirationDate.timeIntervalSince1970;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:expirSeconds] forKey:@"token0expirDate"];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"token0"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sinaWeiBoBind" object:objectDic];
    }
    
}


#pragma mark - Weixin About
-(void)shareToWeixinWithText:(NSString *)shareText
{
    _openPlatformType = typeWeixin;
    _shareText = shareText;
    [self shareMsgToWeixinWithScene:WXSceneSession];
}

-(void)shareToWeixinZoneWithText:(NSString *)shareText
{
    _openPlatformType = typeWeixin;
    _shareText = shareText;
    [self shareMsgToWeixinWithScene:WXSceneTimeline];
}

-(void)shareMsgToWeixinWithScene:(enum WXScene)scene
{
    if (![WXApi isWXAppInstalled]) {
        //您没安装微信客户端
        [MBProgressHUD showHUDWithTitle:@"您没安装微信客户端"];
        return;
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = _shareText;
    req.bText = YES;
    req.scene = scene;
    [WXApi sendReq:req];
}

#pragma mark - Weibo About
-(void)shareToWeiboWithText:(NSString *)shareText
{
    _openPlatformType = typeSinaWeibo;
    _shareText = shareText;
    
    if (![WeiboSDK isWeiboAppInstalled]) {
        //您没安装微博客户端
        [MBProgressHUD showHUDWithTitle:@"您没安装微博客户端"];
        return;
    }
    
    if (![WeiboSDK isCanShareInWeiboAPP]) {
        //您不能分享
        [MBProgressHUD showHUDWithTitle:@"您不能分享"];
        return;
    }
    
    WBMessageObject *shareObject = [[WBMessageObject alloc] init];
    shareObject.text = _shareText;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:shareObject];
    [WeiboSDK sendRequest:request];

}

#pragma mark - QQ About
-(void)shareToQQWithText:(NSString *)shareText
{
    _openPlatformType = typeQQ;
    _shareText = shareText;
    
    if(![QQApiInterface isQQInstalled])
    {
        //您没安装QQ客户端
        [MBProgressHUD showHUDWithTitle:@"您没安装QQ客户端"];
        
        return;
    }
    
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:_shareText];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    if (sent != EQQAPISENDSUCESS && sent != EQQAPIAPPSHAREASYNC) {
//        [ShowHUDTool showHUDWithImgWithTitle:@"分享失败" withHiddenDelay:SHOW_HUD_TIME];
    }
}

@end
