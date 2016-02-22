//
//  CalendarNotiViewController.m
//  BlessingSMS
//
//  Created by hp on 16/2/21.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarNotiViewController.h"
#import "CalendarNotiModel.h"

@interface CalendarNotiViewController ()

@property (nonatomic, strong) CalendarNotiModel *calendarNotiModel;

@end

@implementation CalendarNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提醒";
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap1];
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton, KeyRightButton]];
    [self.defaultNavView.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%lu月%lu日 %@", (unsigned long)_calendarModel.month, (unsigned long)_calendarModel.day, [_calendarModel.date weeklyOrdinalityStr]];
}

-(void)navLeftButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navRightButtonClicked:(UIButton *)sender
{
    self.calendarNotiModel = [[CalendarNotiModel alloc] init];
    _calendarNotiModel.notiContent = self.notiContentTextView.text;
    _calendarNotiModel.calendarModel = self.calendarModel;
    _calendarNotiModel.notiTimeStr = self.timeLabel.text;
    _calendarNotiModel.isNeedNoti = self.openNotiSwitch.on;
    
    [[CalendarNotifiCenter defaultCenter] addNotifi:_calendarNotiModel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewTap:(UITapGestureRecognizer *)tap
{
    if ([self.notiContentTextView isFirstResponder]) {
        [_notiContentTextView resignFirstResponder];
    }
}

#pragma mark - setter and getter


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
