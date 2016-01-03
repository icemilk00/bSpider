//
//  SMSCategoryModel.h
//  BlessingSMS
//
//  Created by hp on 16/1/3.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSCategoryModel : NSObject


-(id)initWithDic:(NSDictionary *)dic;

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, assign) BOOL isHasChildCategory;
@property (nonatomic, strong) id categoryValue;

@property (nonatomic, assign) BOOL isExpand;

@end

#pragma mark - 处理sms信息的reformer
@interface SMSCategoryReformer : DataReformer

+(NSInteger)rowsCountOfExpandInArray:(NSArray *)dataArray withIndex:(NSInteger)index;

@end