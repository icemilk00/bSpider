//
//  CalendarNotiViewController.h
//  BlessingSMS
//
//  Created by hp on 16/2/21.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarModel.h"

@interface CalendarNotiViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextView *notiContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *openNotiSwitch;

@property (nonatomic, strong) CalendarModel *calendarModel;

@end
