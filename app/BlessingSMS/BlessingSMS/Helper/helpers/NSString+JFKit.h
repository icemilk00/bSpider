//
//  NSString+JFKit.h
//
//  Created by HP on 2019/3/1.
//  Copyright © 2016年 JF. All rights reserved.
//

#import <UIKit/UIKit.h>

/// YYCategories <https://github.com/ibireme/YYCategories>

@interface NSString (JFKit)

/** 判断是否为空 **/
+ (BOOL)isEmpty:(NSString *)string;

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)stringWithUUID;

/**
 *  数字3位以逗号隔开
 *  @param num 传入要处理的数字
 *  @return 新字符串
 */
+ (NSString *)changeNumberFormat:(NSString *)num;

/**
 根据文本宽度和字体-返回文本的高度
 @param font 文本字体
 @param width 文本限制的宽度
 @return 返回文本的高度
 */
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

/**
 *  计算文字所占的size
 *  @param font  字体大小
 *  @param isFix 是否限制宽，yes：算高，no：算宽
 *  @param value 限制的值
 *  @return size
 */
- (CGSize)sizeOfFont:(UIFont *)font
          isFixWidth:(BOOL)isFix
            fixValue:(CGFloat)value;

/** 判断是否包含某字符串 **/
- (BOOL)containString:(NSString *)str;

/**
 字符串转json
 @return 转化后的json
 */
- (id)jsonValueDecoded;

@end

@interface NSString (Encrypt)

/**
 对字符串进行aes加密
 @param encryptStr 要加密的字符串
 @param aesKey aes加密解密key
 @return 加密后的字符串
 */
+ (NSString *)aesEncryptWithEncryptStr:(NSString *)encryptStr aesKey:(NSString *)aesKey;

/**
 对字典进行加密
 @param dictionay 要加密的字典
 @param aesKey aes加密解密key
 @return 加密后的字符串
 */
+ (NSString *)aesEncryptWithDictionary:(NSDictionary *)dictionay aesKey:(NSString *)aesKey;

@end

@interface NSString (Trim)

/** 去除字符串前后两端空格（注意只是前后）*/
- (NSString *)trimming;
/** 去除所有空格 */
- (NSString *)removeSpaceString;
/** 去除所有空格,换行和回车 */
- (NSString *)removeSpaceAndNewline;

@end

@interface NSString (Calculate)

/**
 返回两位小数的字符串
 @param value 传入的数据(支持NSString,float,int,NSInteger,double)
 @return 两位小数点字符串
 */
+ (NSString *)interceptionPointString:(id)value;

/**
 返回每三位逗号隔开的两位小数的字符串
 @param value 传入的数据(支持NSString,float,int,NSInteger,double)
 @return 两位小数点字符串
 example： 5000-> 5,000.00    |   1000000  ->   1,000,000.00
 */
+ (NSString *)interceptionPointString2:(id)value;

/**
 求和 stringA + stringB
 @param stringA 字符串A
 @param stringB 字符串B
 @return 返回相加后的字符串
 */
+ (NSString *)getSumStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB;

/**
 相减操作 stringA - stringB
 @param stringA 字符串A
 @param stringB 字符串B
 @return 返回相减后的字符串
 */
+ (NSString *)getSubStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB;

/**
 相乘操作 stringA * stringB
 @param stringA 字符串A
 @param stringB 字符串B
 @return 返回相乘后的字符串
 */
+ (NSString *)getMultiplyStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB;

/**
 除法操作 stringA/stringB(stringA➗stringB)
 @param stringA 字符串A
 @param stringB 字符串B
 @return 返回相除后的字符串
 */
+ (NSString *)getDivideStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB;
@end


typedef NS_ENUM(NSUInteger, AppVersionCompareResult) {
    AppVersionCompareResultBigger = 0,
    AppVersionCompareResultEqual,
    AppVersionCompareResultSmaller,
};
@interface NSString (VersionTool)

/**
 *  @author LiYonghui, 16-08-19 14:08:22
 *  判断当前版本号是否大于输入版本号
 *  @param version 传入的版本号
 *  @return 大于 -> YES  其他 -> NO
 */
+ (BOOL)isAppCurrentVersionBiggerThanVersion:(NSString *)version;
/**
 *  @author LiYonghui, 16-08-22 10:08:15
 *  比较当前版本号与传入的版本号
 *  @param version 传入的版本号
 *  @return 枚举值 -> 大于,等于,小于
 */
+ (AppVersionCompareResult)compareAppCurrentVersionWithVersion:(NSString *)version;
/**
 *  @author LiYonghui, 16-08-23 13:08:25
 *  判断当前版本号是否小于传入版本号
 *  @param version 传入的版本号
 *  @return 小于 -> YES  其他 -> NO
 */
+ (BOOL)isAppCurrentVersionLesserThanVersion:(NSString *)version;

@end

