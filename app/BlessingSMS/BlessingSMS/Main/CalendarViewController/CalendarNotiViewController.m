//
//  CalendarNotiViewController.m
//  BlessingSMS
//
//  Created by hp on 16/2/21.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarNotiViewController.h"
#import "CalendarNotiModel.h"


typedef NS_ENUM(NSInteger, CalendarNotiType) {

    CalendarNotiTypeAdd = 0,
    
    CalendarNotiTypeEdit
};

@interface CalendarNotiViewController ()
{
    CalendarNotiType calendarNotiType;
    NSInteger _editIndex;
}

@property (nonatomic, strong) CalendarNotiModel *calendarNotiModel;
@property (nonatomic, strong) CalendarDataModel *calendarModel;

@property (nonatomic, strong) NSDate *pushDate;

@end

@implementation CalendarNotiViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCalendarModel:(CalendarDataModel *)calendarModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.calendarModel = calendarModel;
        calendarNotiType = CalendarNotiTypeAdd;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCalendarNotiModel:(CalendarNotiModel *)calendarNotiModel andIndex:(NSInteger)editIndex
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        calendarNotiType = CalendarNotiTypeEdit;
        _editIndex = editIndex;
        self.calendarNotiModel = calendarNotiModel;
        self.calendarModel = calendarNotiModel.calendarModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提醒";
    
//    self.notiContentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.notiContentTextView.layer.borderWidth = 1;
    [self.notiContentTextView becomeFirstResponder];
    self.notiContentTextView.delegate = self;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editNotiTimeTap:)];
    [self.notiTimeBgView addGestureRecognizer:tap2];
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton, KeyRightButton]];
    [self.defaultNavView.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    if (calendarNotiType == CalendarNotiTypeEdit && _calendarNotiModel) {
        self.notiContentTextView.text = _calendarNotiModel.notiContent;
        self.timeLabel.text = _calendarNotiModel.notiTimeStr;
        self.openNotiSwitch.on = _calendarNotiModel.isNeedNoti;
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"%lu月%lu日 %@", (unsigned long)_calendarModel.month, (unsigned long)_calendarModel.day, [_calendarModel.date weeklyOrdinalityStr]];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.noticeTextViewTop.constant = NAVIGATIONBAR_HEIGHT + 40;
}


-(void)navLeftButtonClicked:(UIButton *)sender
{
    if ([self.notiContentTextView isFirstResponder]) {
        [self.notiContentTextView resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)navRightButtonClicked:(UIButton *)sender
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *formatStr1 = [formatter stringFromDate:self.pushDate];
    self.pushDate = [formatter dateFromString:formatStr1];
    NSString *notifiValue = _calendarNotiModel.notiContent;
    
    
    self.calendarNotiModel = [[CalendarNotiModel alloc] init];
    _calendarNotiModel.notiContent = self.notiContentTextView.text;
    _calendarNotiModel.calendarModel = self.calendarModel;
    _calendarNotiModel.notiTimeStr = self.timeLabel.text;
    _calendarNotiModel.isNeedNoti = self.openNotiSwitch.on;
    _calendarNotiModel.isExpired = [self.pushDate isBeforeCurrentDate];
    

    if (calendarNotiType == CalendarNotiTypeEdit) {
        
        UILocalNotification *tempLocalNoti = [PushManager localNotiWithKey:formatStr1 andValue:notifiValue];
        
        if (tempLocalNoti) {
            [PushManager delLocalNotification:tempLocalNoti];
        }
        
        NSLog(@"array1 = %@", [PushManager localNotifications]);
        
        if ([PushManager isHasLocalNotificationWithKey:formatStr1 andValue:_notiContentTextView.text]) {
            [MBProgressHUD showHUDWithTitle:@"已有同样的提醒"];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:tempLocalNoti];
            
             NSLog(@"array2 = %@", [PushManager localNotifications]);
            return;
        }
        
        [[CalendarNotifiCenter defaultCenter] editNotifi:_calendarNotiModel withIndex:_editIndex];
        if (_calendarNotiModel.isNeedNoti && !_calendarNotiModel.isExpired) {
            [PushManager localNotification:self.pushDate alertBody:_notiContentTextView.text badge:1 alertAction:@"确定" userInfo:@{formatStr1:_notiContentTextView.text}];
        }
        
    }
    else if (calendarNotiType == CalendarNotiTypeAdd)
    {
        //新增推送
        if ([PushManager isHasLocalNotificationWithKey:formatStr1 andValue:_notiContentTextView.text]) {
            [MBProgressHUD showHUDWithTitle:@"已有同样的提醒"];
            return;
        }
        
        [[CalendarNotifiCenter defaultCenter] addNotifi:_calendarNotiModel];
        if (_calendarNotiModel.isNeedNoti && !_calendarNotiModel.isExpired) {
            [PushManager localNotification:self.pushDate alertBody:_notiContentTextView.text badge:1 alertAction:@"确定" userInfo:@{formatStr1:_notiContentTextView.text}];
        }
        
    }
    
    if ([self.notiContentTextView isFirstResponder]) {
        [self.notiContentTextView resignFirstResponder];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewTap:(UITapGestureRecognizer *)tap
{
    if ([self.notiContentTextView isFirstResponder]) {
        [_notiContentTextView resignFirstResponder];
    }
}

-(void)editNotiTimeTap:(UITapGestureRecognizer *)tap
{
    [_notiContentTextView resignFirstResponder];
    
    CalendarDatePickerView *pickerView = [[CalendarDatePickerView alloc] initWithDelegate:self];
    pickerView.datePickerMode = UIDatePickerModeTime;
    pickerView.date = self.calendarNotiModel.date;
    [pickerView show];
}

-(void)dateChangedWithDate:(NSDate *)date
{
    NSLog(@"date = %@", date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *showtimeStr= [formatter stringFromDate:date];
    
    self.pushDate = date;
    self.timeLabel.text = showtimeStr;
}

-(NSDate *)pushDate
{
    if (!_pushDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        self.pushDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld %@", self.calendarModel.year, self.calendarModel.month, self.calendarModel.day, self.timeLabel.text]];
    }
    return _pushDate;
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *str = textView.text;
    if ([str length]<1) {
        return;
    }
    
    NSRange strRange = [str rangeOfString:@"\n"];
    
    if (strRange.length > 0) {
        
        NSString *sendStr = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        textView.text = sendStr;
        [textView resignFirstResponder];
        return;
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
