//
//  CalendarView.h
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarTileView.h"
#import "NSDate+CalendarHelper.h"

@class CalendarView;

@protocol CalendarDataSource <NSObject>

- (CalendarTileView *)calendarView:(CalendarView *)gridView tileViewForRow:(NSUInteger)row column:(NSUInteger)column;

@optional

- (CGFloat)heightForRowInGridView:(CalendarView *)calendarView;

@end

@protocol CalendarDelegate <NSObject>

- (void)calendarView:(CalendarView *)calendarView didSelectAtRow:(NSUInteger)row column:(NSUInteger)column;

@end

@interface CalendarView : UIView

@property (nonatomic, assign) BOOL autoResize; /* 自动根据行数调整高度 */

@property (nonatomic, assign) id <CalendarDataSource> dataSource;
@property (nonatomic, assign) id <CalendarDelegate> delegate;

@property (nonatomic, strong) NSDate *selectDate;

-(void)reloadCalendarWithDate:(NSDate *)date;
-(void)reloadDataWithCurrentDate;

@end
