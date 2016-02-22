//
//  CalendarNotiModel.h
//  BlessingSMS
//
//  Created by hp on 16/2/21.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarModel.h"

@interface CalendarNotiModel : NSObject

@property (nonatomic, strong) NSString *notiContent;
@property (nonatomic, strong) CalendarModel *calendarModel;
@property (nonatomic, strong) NSString *notiTimeStr;
@property (nonatomic, assign) BOOL isNeedNoti;

@end
