//
//  SMSCategoryModel.m
//  BlessingSMS
//
//  Created by hp on 16/1/3.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "SMSCategoryModel.h"

@implementation SMSCategoryModel

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.categoryName = dic[@"categoryName"];
        
        id tempcategoryValue = dic[@"categoryValue"];
        
        if ([tempcategoryValue isKindOfClass:[NSArray class]]) {
            self.isHasChildCategory = YES;
            NSMutableArray *valueArray = [[NSMutableArray alloc] init];
            for (NSDictionary *subDic in tempcategoryValue) {
                SMSCategoryModel *subModel = [[SMSCategoryModel alloc] initWithDic:subDic];
                [valueArray addObject:subModel];
            }
            _categoryValue = valueArray;
        }
        else if ([tempcategoryValue isKindOfClass:[NSString class]])
        {
            self.isHasChildCategory = NO;
            self.categoryValue = tempcategoryValue;
        }
        self.isExpand = NO;
    }
    
    return self;
}


@end

@implementation SMSCategoryReformer
{
    
}

-(id)manager:(BaseAPIManager *)manager reformData:(NSDictionary *)data
{
    if ([manager isKindOfClass:[SMSCategoryAPIManager class]]) {
        return [self smsCategoryWithData:data];
    }
    return nil;
}

-(NSArray *)smsCategoryWithData:(NSDictionary *)data
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSArray *dataArray = data[@"categoryArray"];
    for (NSDictionary *dic in dataArray) {
        SMSCategoryModel *model = [[SMSCategoryModel alloc] initWithDic:dic];
        [resultArray addObject:model];
    }
    
    return [resultArray mutableCopy];
}

+(NSInteger)rowsCountOfExpandInArray:(NSArray *)dataArray withIndex:(NSInteger)index
{
    NSInteger rowsCount = 0;
    
    SMSCategoryModel *model = dataArray[index];
    if ([model.categoryValue isKindOfClass:[NSArray class]] && model.isExpand == YES) {
        rowsCount += ((NSArray *)(model.categoryValue)).count;
        
        for (int i = 0; i < rowsCount; i++) {
            rowsCount += [SMSCategoryReformer rowsCountOfExpandInArray:model.categoryValue withIndex:i];
        }
    }
    return rowsCount;
}


@end