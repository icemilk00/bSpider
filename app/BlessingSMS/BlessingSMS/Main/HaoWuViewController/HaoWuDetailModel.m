//
//  HaoWuDetailModel.m
//  BlessingSMS
//
//  Created by hp on 2019/5/11.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "HaoWuDetailModel.h"

@implementation HaoWuDetailModel
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
