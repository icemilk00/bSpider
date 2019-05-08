//
//  NSString+JFKit.m
//
//  Created by HP on 2019/3/1.
//  Copyright © 2016年 JF. All rights reserved.
//

#import "NSString+JFKit.h"
//#import "NSData+JFKit.h"
//#import "NSDictionary+JFKit.h"

@implementation NSString (JFKit)

+ (BOOL)isEmpty:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (string == nil || string == NULL ) {
        return YES;
    }
    if ([string isEqualToString:@""] || [string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"] || [string isEqualToString:@""]) {
        return YES;
    }
    if ([string length] == 0 || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

+ (NSString *)changeNumberFormat:(NSString *)num {
    if (num == nil || [num isEqualToString:@""]) {
        return @"";
    }
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0) {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGSize)sizeOfFont:(UIFont *)font
          isFixWidth:(BOOL)isFix
            fixValue:(CGFloat)value {
    CGSize size = CGSizeZero;
    if (isFix) {
        size = CGSizeMake(value, MAXFLOAT);
    } else {
        size = CGSizeMake(MAXFLOAT, value);
    }
    CGSize actualsize = CGSizeZero;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    actualsize = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return actualsize;
}

- (BOOL)containString:(NSString *)str {
    if ([self rangeOfString:str].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (id)jsonValueDecoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"jsonValueDecoded error:%@", error);
    }
    return value;
}
@end


@implementation NSString (Trim)

/** 增加手机空格 */
- (NSString *)addSpaceString {
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return temp;
}

/** 去除字符串前后两端空格（注意只是前后）*/
- (NSString *)trimming {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
/** 去除所有空格 */
- (NSString *)removeSpaceString {
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return temp;
}
/** 去除所有空格,换行和回车 */
- (NSString *)removeSpaceAndNewline {
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
@end


@implementation NSString (Calculate)

+ (NSString *)interceptionPointString:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        NSString *string = value;
        NSRange pointRange = [string rangeOfString:@"."];
        if (pointRange.location !=NSNotFound) {//有小数位
            string = [string  stringByAppendingString:@"00"];
            NSRange range = NSMakeRange(0, pointRange.location +2 + 1);
            string = [string substringWithRange:range];//截取范围类的字符串]
        } else {     //小数位
            string = [string  stringByAppendingString:@".00"];
        }
        return string;
    } else {
        NSString *string = [NSString stringWithFormat:@"%f",[value doubleValue]];
        NSRange pointRange = [string rangeOfString:@"."];
        if (pointRange.location !=NSNotFound) {//有小数位
            string = [string  stringByAppendingString:@"00"];
            NSRange range = NSMakeRange(0, pointRange.location +2 + 1);
            string = [string substringWithRange:range];//截取范围类的字符串]
        } else {     //小数位
            string = [string  stringByAppendingString:@".00"];
        }
        return string;
    }
}

//逗号隔开 +  两位小数
+ (NSString *)interceptionPointString2:(id)value {
    
    //先得到加小数点格式化后的字符串
    NSString *pointStr = [NSString interceptionPointString:value];
    NSArray *strArray = [pointStr componentsSeparatedByString:@"."];
    NSString *str = strArray[0];
    NSMutableString *formatStr = [[NSMutableString alloc] init];
    for (int i = (int)str.length - 1; i >= 0; i--) {
        NSString *s = [str substringWithRange:NSMakeRange(i, 1)];
        [formatStr insertString:s atIndex:0];
        if ((str.length - i)%3==0 && i!=0) {
            [formatStr insertString:@"," atIndex:0];
        }
    }
    
    [formatStr appendString:@"."];
    [formatStr appendString:strArray[1]];
    return formatStr;
}

//加
+ (NSString *)getSumStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB {
    NSDecimalNumber *numA = [NSDecimalNumber decimalNumberWithString:stringA];
    NSDecimalNumber *numB = [NSDecimalNumber decimalNumberWithString:stringB];
    NSDecimalNumber *sumNum = [numA decimalNumberByAdding:numB];
    return [NSString stringWithFormat:@"%@",sumNum];
}
//减
+ (NSString *)getSubStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB {
    NSDecimalNumber *numA = [NSDecimalNumber decimalNumberWithString:stringA];
    NSDecimalNumber *numB = [NSDecimalNumber decimalNumberWithString:stringB];
    NSDecimalNumber *subNum = [numA decimalNumberBySubtracting:numB];
    return [NSString stringWithFormat:@"%@",subNum];
}
//乘
+ (NSString *)getMultiplyStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB {
    NSDecimalNumber *numA = [NSDecimalNumber decimalNumberWithString:stringA];
    NSDecimalNumber *numB = [NSDecimalNumber decimalNumberWithString:stringB];
    NSDecimalNumber *mutiplyNum = [numA decimalNumberByMultiplyingBy:numB];
    return [NSString stringWithFormat:@"%@",mutiplyNum];
}
//除
+ (NSString *)getDivideStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB {
    NSDecimalNumber *numA = [NSDecimalNumber decimalNumberWithString:stringA];
    NSDecimalNumber *numB = [NSDecimalNumber decimalNumberWithString:stringB];
    NSDecimalNumber *divideNum = [numA decimalNumberByDividingBy:numB];
    return [NSString stringWithFormat:@"%@",divideNum];
}
@end


@implementation NSString (VersionTool)

+ (BOOL)isAppCurrentVersionBiggerThanVersion:(NSString *)version {
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSInteger currentVersionCount = [version componentsSeparatedByString:@"."].count;
    while (currentVersionCount != 3) {
        currentVersion = [currentVersion stringByAppendingString:@".0"];
        currentVersionCount = [currentVersion componentsSeparatedByString:@"."].count;
    }
    
    NSInteger count = [version componentsSeparatedByString:@"."].count;
    while (count != 3) {
        version = [version stringByAppendingString:@".0"];
        count = [version componentsSeparatedByString:@"."].count;
    }
    
    NSArray *array1 = [currentVersion componentsSeparatedByString:@"."];
    NSArray *array2 = [version componentsSeparatedByString:@"."];
    
    BOOL isBigger = NO;
    for (int i = 0; i < 3; i++) {
        int result = [array1[i] intValue] - [array2[i] intValue];
        if (result > 0) {
            isBigger = YES;
            break;
        } else if (result == 0) {
            continue;
        } else {
            isBigger = NO;
            break;
        }
    }
    
    return isBigger;
}

+ (AppVersionCompareResult)compareAppCurrentVersionWithVersion:(NSString *)version {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSInteger currentVersionCount = [version componentsSeparatedByString:@"."].count;
    while (currentVersionCount != 3) {
        currentVersion = [currentVersion stringByAppendingString:@".0"];
        currentVersionCount = [currentVersion componentsSeparatedByString:@"."].count;
    }
    
    NSInteger count = [version componentsSeparatedByString:@"."].count;
    while (count != 3) {
        version = [version stringByAppendingString:@".0"];
        count = [version componentsSeparatedByString:@"."].count;
    }
    
    NSArray *array1 = [currentVersion componentsSeparatedByString:@"."];
    NSArray *array2 = [version componentsSeparatedByString:@"."];
    
    AppVersionCompareResult compareResult = AppVersionCompareResultEqual;
    for (int i = 0; i < 3; i++) {
        int result = [array1[i] intValue] - [array2[i] intValue];
        if (result > 0) {
            compareResult = AppVersionCompareResultBigger;
            break;
        } else if (result == 0) {
            if (i != 2) {
                continue;
            }
            compareResult = AppVersionCompareResultEqual;
        } else {
            compareResult = AppVersionCompareResultSmaller;
            break;
        }
    }
    
    return compareResult;
}

+ (BOOL)isAppCurrentVersionLesserThanVersion:(NSString *)version {
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSInteger currentVersionCount = [version componentsSeparatedByString:@"."].count;
    while (currentVersionCount != 3) {
        currentVersion = [currentVersion stringByAppendingString:@".0"];
        currentVersionCount = [currentVersion componentsSeparatedByString:@"."].count;
    }
    
    NSInteger count = [version componentsSeparatedByString:@"."].count;
    while (count != 3) {
        version = [version stringByAppendingString:@".0"];
        count = [version componentsSeparatedByString:@"."].count;
    }
    
    NSArray *array1 = [currentVersion componentsSeparatedByString:@"."];
    NSArray *array2 = [version componentsSeparatedByString:@"."];
    
    BOOL isLesser = NO;
    for (int i = 0; i < 3; i++) {
        int result = [array1[i] intValue] - [array2[i] intValue];
        if (result > 0) {
            isLesser = NO;
            break;
        } else if (result == 0) {
            continue;
        } else {
            isLesser = YES;
            break;
        }
    }
    return isLesser;
}
@end


