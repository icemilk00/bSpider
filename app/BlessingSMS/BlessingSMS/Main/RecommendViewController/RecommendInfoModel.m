//
//  RecommendInfoModel.m
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "RecommendInfoModel.h"

@implementation RecommendInfoModel

-(NSString *)showImageStr
{
    if (_small_images == nil) {
        return @"";
    }
    
    NSArray *array = _small_images[@"string"];
    if (!array || array.count == 0) {
        return @"";
    }
    
    return array[0];
}

@end
