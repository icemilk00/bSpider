//
//  CalendarTileView.m
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarTileView.h"
#import "NSDate+CalendarHelper.h"


@implementation CalendarTileView

- (void)setSelected:(BOOL)selected
{
    static UIColor *selectedColor = nil;
    if (selectedColor == nil) {
        selectedColor = [UIColor colorWithRed:70/255.0f green:171/255.0f blue:179/255.0f alpha:1];
    }
    
    if (selected) {
        self.backgroundColor = selectedColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    _selected = selected;
}

-(void)setIsCurrentDay:(BOOL)isCurrentDay
{
    _isCurrentDay = isCurrentDay;
    if (_isCurrentDay) {
        self.showDayLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.showDayLabel.textColor = [UIColor blackColor];
    }
}

-(void)setIsInCurrentMonth:(BOOL)isInCurrentMonth
{
    _isInCurrentMonth = isInCurrentMonth;
    if (!_isInCurrentMonth) {
        self.showDayLabel.textColor = [UIColor grayColor];
    }
}

-(void)configTileViewWithModel:(CalendarModel *)model
{
    self.showDayLabel.text = [NSString stringWithFormat:@"%d",(int)model.day];
    self.showChineseDayLabel.text = [model.date chineseCalendar];
    
    NSString *holidayStr = [model.date getChineseHoliday];
    if (holidayStr) {
        self.showChineseDayLabel.text = holidayStr;
        self.showChineseDayLabel.textColor = [UIColor redColor];
        
        return;
    }
    
    NSString *worldHolidayStr = [model.date getWorldHoliday];
    if (worldHolidayStr) {
        self.showChineseDayLabel.text = worldHolidayStr;
        self.showChineseDayLabel.textColor = [UIColor redColor];
        
        return;
    }
    
}

@end
