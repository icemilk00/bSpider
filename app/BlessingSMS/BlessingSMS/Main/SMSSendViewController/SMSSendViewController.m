//
//  SMSSendViewController.m
//  BlessingSMS
//
//  Created by hp on 16/1/4.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "SMSSendViewController.h"

@interface SMSSendViewController ()
{
    SMSInfoModel *_currentShowSMSInfoModel;
}
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
}

-(void)navLeftButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
