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

-(void)navLeftButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)navRightButtonClicked:(UIButton *)sender
{
    self.calendarNotiModel = [[CalendarNotiModel alloc] init];
    _calendarNotiModel.notiContent = self.notiContentTextView.text;
    _calendarNotiModel.calendarModel = self.calendarModel;
    _calendarNotiModel.notiTimeStr = self.timeLabel.text;
    _calendarNotiModel.isNeedNoti = self.openNotiSwitch.on;
    
    if (calendarNotiType == CalendarNotiTypeEdit) {
        [[CalendarNotifiCenter defaultCenter] editNotifi:_calendarNotiModel withIndex:_editIndex];
    }
    else if (calendarNotiType == CalendarNotiTypeAdd)
    {
        [[CalendarNotifiCenter defaultCenter] addNotifi:_calendarNotiModel];
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
    CalendarDatePickerView *pickerView = [[CalendarDatePickerView alloc] initWithDelegate:self];
    pickerView.datePickerMode = UIDatePickerModeTime;
    pickerView.date = self.calendarModel.date;
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
