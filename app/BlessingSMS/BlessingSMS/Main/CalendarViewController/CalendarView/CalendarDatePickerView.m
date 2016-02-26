//
//  CalendarDatePickerView.m
//  CalendarDemo
//
//  Created by hp on 16/2/19.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarDatePickerView.h"
#import "AppDelegate.h"

@interface CalendarDatePickerView ()

@property (nonatomic, strong) UIView *bgShowView;
@property (nonatomic, strong) UIView *mainShowView;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation CalendarDatePickerView

-(id)initWithDelegate:(id <CalendarDatePickerViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.frame = [UIScreen mainScreen].bounds;
        self.datePickerMode = UIDatePickerModeDate;
        self.date = [NSDate date];
    }
    return self;
}

-(void)show
{
    [self addSubview:self.bgShowView];
    [self addSubview:self.mainShowView];
    
    [self.mainShowView addSubview:self.datePicker];
    [self.mainShowView addSubview:self.cancelButton];
    [self.mainShowView addSubview:self.selectButton];

    [((AppDelegate *)([UIApplication sharedApplication].delegate)).window addSubview:self];
}



-(void)cancelButtonClicked:(UIButton *)sender
{
    [self cancel];
}

-(void)selectButtonClicked:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dateChangedWithDate:)]) {
        [self.delegate dateChangedWithDate:self.datePicker.date];
    }
    
    [self cancel];
}

-(void)cancel
{
    [self removeFromSuperview];
}

-(void)bgTap:(UITapGestureRecognizer *)tap
{
    [self cancel];
}

#pragma mark - getter and setter
-(UIView *)bgShowView
{
    if (!_bgShowView) {
        self.bgShowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width , self.frame.size.height)];
        _bgShowView.backgroundColor = [UIColor blackColor];
        _bgShowView.alpha = 0.6;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
        [_bgShowView addGestureRecognizer:tap];
    }
    return _bgShowView;
}

-(UIView *)mainShowView
{
    if (!_mainShowView) {
        self.mainShowView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, self.frame.size.height/2 - 200/2, self.frame.size.width - 40.0f , 200.0f)];
        
        _mainShowView.backgroundColor = [UIColor whiteColor];
    }
    return _mainShowView;
}


-(UIDatePicker *)datePicker
{
    if (!_datePicker) {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 30.0f, _mainShowView.frame.size.width, _mainShowView.frame.size.height - 40.0f - 40.0f)];
        _datePicker.datePickerMode = self.datePickerMode;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _datePicker.minimumDate = [formatter dateFromString:@"1900-01-01"];
        _datePicker.maximumDate = [formatter dateFromString:@"2100-01-01"];

        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _datePicker.date = self.date;

    }
    return _datePicker;
}

-(UIButton *)cancelButton
{
    if (!_cancelButton) {
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, _datePicker.frame.size.height + _datePicker.frame.origin.y, _mainShowView.frame.size.width/2, 40.0f)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(UIButton *)selectButton
{
    if (!_selectButton) {
        self.selectButton = [[UIButton alloc] initWithFrame:CGRectMake(_cancelButton.frame.size.width, _datePicker.frame.size.height + _datePicker.frame.origin.y, _mainShowView.frame.size.width/2, 40.0f)];
        [_selectButton setTitle:@"确定" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

-(void)setDate:(NSDate *)date
{
    if (date) {
        _date = date;
        _datePicker.date = date;
    }
}
@end
