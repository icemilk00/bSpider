//
//  CalendarDatePickerView.h
//  CalendarDemo
//
//  Created by hp on 16/2/19.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarDatePickerViewDelegate <NSObject>

-(void)dateChangedWithDate:(NSDate *)date;

@end

@interface CalendarDatePickerView : UIView

@property (nonatomic , assign) id <CalendarDatePickerViewDelegate> delegate;

-(id)initWithDelegate:(id <CalendarDatePickerViewDelegate>)delegate;
-(void)show;
@end
