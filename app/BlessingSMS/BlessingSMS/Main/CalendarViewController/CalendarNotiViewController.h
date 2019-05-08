//
//  CalendarNotiViewController.h
//  BlessingSMS
//
//  Created by hp on 16/2/21.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDataModel.h"
#import "CalendarDatePickerView.h"

@interface CalendarNotiViewController : BaseViewController <CalendarDatePickerViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *notiContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *openNotiSwitch;
@property (weak, nonatomic) IBOutlet UIView *notiTimeBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeTextViewTop;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCalendarModel:(CalendarDataModel *)calendarModel;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCalendarNotiModel:(CalendarNotiModel *)calendarNotiModel andIndex:(NSInteger)editIndex;

@end
