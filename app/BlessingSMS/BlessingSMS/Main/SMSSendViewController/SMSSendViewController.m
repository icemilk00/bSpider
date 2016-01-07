//
//  SMSSendViewController.m
//  BlessingSMS
//
//  Created by hp on 16/1/4.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "SMSSendViewController.h"
#import "AddressBookViewController.h"

@interface SMSSendViewController ()
{
    SMSInfoModel *_currentShowSMSInfoModel;
}

@property (nonatomic, strong) UITextView *smsTextView;
@property (nonatomic ,strong) UIButton *smsSendButton;
@property (nonatomic ,strong) UIButton *weixinSendButton;
@property (nonatomic ,strong) UIButton *weixinZoneSendButton;
@property (nonatomic ,strong) UIButton *qqSendButton;
@property (nonatomic ,strong) UIButton *weiboSendButton;

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
    self.title = _currentShowSMSInfoModel.category_name;
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    
    [self.view addSubview:self.smsTextView];
    [self.view addSubview:self.smsSendButton];
    [self.view addSubview:self.weixinSendButton];
    [self.view addSubview:self.weixinZoneSendButton];
    [self.view addSubview:self.qqSendButton];
    [self.view addSubview:self.weiboSendButton];
    
}

-(void)navLeftButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - button action

-(void)smsSend{
    
    AddressBookViewController *addressVC = [[AddressBookViewController alloc] initWithSmsContentStr:_smsTextView.text];
    [self.navigationController presentViewController:addressVC animated:YES completion:nil];

}

#pragma mark - setter and setter
-(UITextView *)smsTextView
{
    if (!_smsTextView) {
        _smsTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, NAVIGATIONBAR_HEIGHT + 30.0f, SCREEN_WIDTH - 20.0f, 160.0f)];
        _smsTextView.text = _currentShowSMSInfoModel.content;
        _smsTextView.backgroundColor = [UIColor redColor];
        _smsTextView.font = [UIFont systemFontOfSize:16];
    }
    return _smsTextView;
}

-(UIButton *)smsSendButton
{
    if (!_smsSendButton) {
        _smsSendButton = [[UIButton alloc] initWithFrame:CGRectMake(_smsTextView.frame.origin.x, _smsTextView.frame.origin.y + _smsTextView.frame.size.height + 10.0f, 34.0f, 34.0f)];
        _smsSendButton.backgroundColor = [UIColor blueColor];
        [_smsSendButton addTarget:self action:@selector(smsSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smsSendButton;
}

-(UIButton *)weixinSendButton
{
    if (!_weixinSendButton) {
        _weixinSendButton = [[UIButton alloc] initWithFrame:CGRectMake(_smsSendButton.frame.origin.x + _smsSendButton.frame.size.width + 10.0f, _smsSendButton.frame.origin.y, 34.0f, 34.0f)];
        _weixinSendButton.backgroundColor = [UIColor blueColor];
    }
    return _weixinSendButton;
}

-(UIButton *)weixinZoneSendButton
{
    if (!_weixinZoneSendButton) {
        _weixinZoneSendButton = [[UIButton alloc] initWithFrame:CGRectMake(_weixinSendButton.frame.origin.x + _weixinSendButton.frame.size.width + 10.0f, _smsSendButton.frame.origin.y, 34.0f, 34.0f)];
        _weixinZoneSendButton.backgroundColor = [UIColor blueColor];
    }
    return _weixinZoneSendButton;
}

-(UIButton *)qqSendButton
{
    if (!_qqSendButton) {
        _qqSendButton = [[UIButton alloc] initWithFrame:CGRectMake(_weixinZoneSendButton.frame.origin.x + _weixinZoneSendButton.frame.size.width + 10.0f, _smsSendButton.frame.origin.y, 34.0f, 34.0f)];
        _qqSendButton.backgroundColor = [UIColor blueColor];
    }
    return _qqSendButton;
}

-(UIButton *)weiboSendButton
{
    if (!_weiboSendButton) {
        _weiboSendButton = [[UIButton alloc] initWithFrame:CGRectMake(_qqSendButton.frame.origin.x + _qqSendButton.frame.size.width + 10.0f, _smsSendButton.frame.origin.y, 34.0f, 34.0f)];
        _weiboSendButton.backgroundColor = [UIColor blueColor];
    }
    return _weiboSendButton;
}

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
