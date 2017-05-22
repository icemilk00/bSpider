//
//  PinyinHelper.m
//  BlessingSMS
//
//  Created by hp on 16/1/18.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "PinyinHelper.h"

@implementation PinyinHelper

+ (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    
    if (!str) {
        return @"";
    }
    
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    
    if (!pinYin || pinYin.length < 1) {
        return @"";
    }
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

@end
