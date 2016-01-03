//
//  LayerHelper.m
//  BlessingSMS
//
//  Created by hp on 16/1/1.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "LayerHelper.h"

@implementation LayerHelper

+(CGSize)sizeWithContent:(NSString *)content andFont:(UIFont *)font andDrawSize:(CGSize)drawSize
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [content boundingRectWithSize:drawSize options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
    
    return size;
}

@end
