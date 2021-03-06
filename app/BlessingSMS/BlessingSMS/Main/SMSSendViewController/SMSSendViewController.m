//
//  SMSSendViewController.m
//  BlessingSMS
//
//  Created by hp on 16/1/4.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "SMSSendViewController.h"
#import "AddressBookViewController.h"

#import "GDTUnifiedInterstitialAd.h"

@interface SMSSendViewController () <GDTUnifiedInterstitialAdDelegate>
{
    SMSInfoModel *_currentShowSMSInfoModel;
}

@property (nonatomic, strong) UITextView *smsTextView;
@property (nonatomic ,strong) UIButton *smsSendButton;
@property (nonatomic ,strong) UIButton *weixinSendButton;
@property (nonatomic ,strong) UIButton *weixinZoneSendButton;
@property (nonatomic ,strong) UIButton *qqSendButton;
@property (nonatomic ,strong) UIButton *weiboSendButton;
@property (nonatomic ,strong) UIImageView *smsBgImageView;

@property (nonatomic ,assign) BOOL isFirstIn;
@property (nonatomic, strong) GDTUnifiedInterstitialAd *interstitial;

@end

@implementation SMSSendViewController

-(id)initWithSMSModel:(SMSInfoModel *)infoModel
{
    self = [super init];
    if (self) {
        _currentShowSMSInfoModel = infoModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.isFirstIn = YES;
    self.title = _currentShowSMSInfoModel.category_name;
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    
    [self.view addSubview:self.smsBgImageView];
    [self.view addSubview:self.smsTextView];
    [self.view addSubview:self.smsSendButton];
    [self.view addSubview:self.weixinSendButton];
    [self.view addSubview:self.weixinZoneSendButton];
    [self.view addSubview:self.qqSendButton];
    [self.view addSubview:self.weiboSendButton];
    
    [self loadAd];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.interstitial && self.interstitial.isAdValid && !_isFirstIn) {
        [self showAd];
    }
    _isFirstIn = NO;
}


- (void)loadAd {
    if (self.interstitial) {
        self.interstitial.delegate = nil;
        self.interstitial = nil;
    }
    self.interstitial = [[GDTUnifiedInterstitialAd alloc] initWithAppId:@"1106197212" placementId:@"5040584676779403"];
    self.interstitial.delegate = self;

    [self.interstitial loadAd];
}

- (void)showAd  {
    [self.interstitial presentAdFromRootViewController:self];
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    [self loadAd];
}

- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    
    [self loadAd];
}

#pragma mark - button action

-(void)smsSend{
    
    [AnalyticsManager eventSmsSendWithPlatform:eventSMSSendFirst withCategoryID:_currentShowSMSInfoModel.category_id withSMSID:_currentShowSMSInfoModel.id];
    AddressBookViewController *addressVC = [[AddressBookViewController alloc] initWithSmsInfo:_currentShowSMSInfoModel];
    addressVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:addressVC animated:YES completion:nil];
}

-(void)weixinSend
{
    [AnalyticsManager eventSmsSendWithPlatform:eventSMSSendToWeixin withCategoryID:_currentShowSMSInfoModel.category_id withSMSID:_currentShowSMSInfoModel.id];
    [[ShareManager sharedInstance] shareToWeixinWithText:_smsTextView.text];
}

-(void)weixinZoneSend
{
    [AnalyticsManager eventSmsSendWithPlatform:eventSMSSendToWeixinZone withCategoryID:_currentShowSMSInfoModel.category_id withSMSID:_currentShowSMSInfoModel.id];
    [[ShareManager sharedInstance] shareToWeixinZoneWithText:_smsTextView.text];
}

-(void)qqSend
{
    [AnalyticsManager eventSmsSendWithPlatform:eventSMSSendToQQ withCategoryID:_currentShowSMSInfoModel.category_id withSMSID:_currentShowSMSInfoModel.id];
    [[ShareManager sharedInstance] shareToQQWithText:_smsTextView.text];
}

-(void)weiboSend
{
    [AnalyticsManager eventSmsSendWithPlatform:eventSMSSendToWeibo withCategoryID:_currentShowSMSInfoModel.category_id withSMSID:_currentShowSMSInfoModel.id];
    [[ShareManager sharedInstance] shareToWeiboWithText:_smsTextView.text];
}

#pragma mark - setter and setter
-(UIImageView *)smsBgImageView
{
    if (!_smsBgImageView) {
        _smsBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, NAVIGATIONBAR_HEIGHT + 20.0f, SCREEN_WIDTH - 10.0f, 190.0f)];
        _smsBgImageView.image = [UIImage imageNamed:@"sms_bg"];
    }
    return _smsBgImageView;
}

-(UITextView *)smsTextView
{
    if (!_smsTextView) {
        _smsTextView = [[UITextView alloc] initWithFrame:CGRectMake(20.0f, NAVIGATIONBAR_HEIGHT + 75.0f, SCREEN_WIDTH - 40.0f, 135.0f)];
        _smsTextView.text = _currentShowSMSInfoModel.content;
        _smsTextView.backgroundColor = [UIColor clearColor];
        _smsTextView.font = [UIFont systemFontOfSize:14];
        [_smsTextView becomeFirstResponder];
    }
    return _smsTextView;
}

-(UIButton *)smsSendButton
{
    if (!_smsSendButton) {
        _smsSendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10.0f - 34.0f, _smsTextView.frame.origin.y + _smsTextView.frame.size.height + 10.0f, 34.0f, 34.0f)];
        [_smsSendButton setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        [_smsSendButton addTarget:self action:@selector(smsSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smsSendButton;
}

-(UIButton *)weixinSendButton
{
    if (!_weixinSendButton) {
        _weixinSendButton = [[UIButton alloc] initWithFrame:CGRectMake(_smsTextView.frame.origin.x, _smsTextView.frame.origin.y + _smsTextView.frame.size.height + 10.0f, 34.0f, 34.0f)];
        [_weixinSendButton setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [_weixinSendButton addTarget:self action:@selector(weixinSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinSendButton;
}

-(UIButton *)weixinZoneSendButton
{
    if (!_weixinZoneSendButton) {
        _weixinZoneSendButton = [[UIButton alloc] initWithFrame:CGRectMake(_weixinSendButton.frame.origin.x + _weixinSendButton.frame.size.width + 10.0f, _smsSendButton.frame.origin.y, 34.0f, 34.0f)];
        [_weixinZoneSendButton setImage:[UIImage imageNamed:@"weixinZone"] forState:UIControlStateNormal];
        [_weixinZoneSendButton addTarget:self action:@selector(weixinZoneSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinZoneSendButton;
}

-(UIButton *)qqSendButton
{
    if (!_qqSendButton) {
        _qqSendButton = [[UIButton alloc] initWithFrame:CGRectMake(_weixinZoneSendButton.frame.origin.x + _weixinZoneSendButton.frame.size.width + 10.0f, _smsSendButton.frame.origin.y, 34.0f, 34.0f)];
        [_qqSendButton setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [_qqSendButton addTarget:self action:@selector(qqSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqSendButton;
}

-(UIButton *)weiboSendButton
{
    if (!_weiboSendButton) {
        _weiboSendButton = [[UIButton alloc] initWithFrame:CGRectMake(_qqSendButton.frame.origin.x + _qqSendButton.frame.size.width + 10.0f, _smsSendButton.frame.origin.y, 34.0f, 34.0f)];
        [_weiboSendButton setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
        [_weiboSendButton addTarget:self action:@selector(weiboSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weiboSendButton;
}

//- (GDTUnifiedBannerView *)bannerView
//{
//    if (!_bannerView) {
//        CGRect rect = {CGPointMake(0.0f, self.view.height - self.view.width/6.4f), CGSizeMake(self.view.width, self.view.width/6.4f)};
//        _bannerView = [[GDTUnifiedBannerView alloc]
//                       initWithFrame:rect appId:@"1106197212"
//                       placementId:@"7040886655460813"
//                       viewController:self];
//        _bannerView.delegate = self;
//    }
//    return _bannerView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
