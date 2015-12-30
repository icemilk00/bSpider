//
//  MainShowViewController.m
//  BlessingSMS
//
//  Created by hp on 15/12/30.
//  Copyright © 2015年 hxp. All rights reserved.
//

#import "MainShowViewController.h"

@interface MainShowViewController ()

@property (strong, nonatomic) SMSAPIManager *smsApiManager;

@end

@implementation MainShowViewController

- (void)viewDidLoad {
    self.title = @"推荐";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.smsApiManager getSmsWithCategoryId:@"0" andPageNum:1];
    
}

#pragma mark  RiHanMaleSingersListAPIManager getter
-(SMSAPIManager *)smsApiManager
{
    if (!_smsApiManager) {
        _smsApiManager = [[SMSAPIManager alloc] init];
        _smsApiManager.delegate = self;
    }
    return _smsApiManager;
}

#pragma mark -- APIManagerDelegate --
-(void)APIManagerDidSucess:(BaseAPIManager *)manager
{
    
    if(![manager.retCode isEqualToString:@"1000"])
    {
        NSLog(@"出现异常");
        return;
    }
    
}

-(void)APIManagerDidFailed:(BaseAPIManager *)manager
{
//    NSLog(@"请求失败: %@", manager.requestError.description);
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
