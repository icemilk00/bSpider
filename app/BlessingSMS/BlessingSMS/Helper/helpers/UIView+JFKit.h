//
//  UIView+JFKit.h
//
//  Created by HP on 2019/3/1.
//  Copyright © 2016年 JF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JFLineType) {
    JFLineTypeLeft = 1,     //从父视图左侧开始绘制线
    JFLineTypeTop,      //从父视图顶部开始绘制线
    JFLineTypeRight,    //从父视图右侧开始绘制线
    JFLineTypeBottom    //从父视图底部开始绘制线
};

@interface UIView (JFKit)

- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color offset:(CGFloat)offset;

- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color offset:(CGFloat)offset padding:(CGFloat)padding;

/**
 快速创建一条线，支持水平、垂直方向，UIEdgeInsets 为 0,0,0,0
 */
- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color;
/**
 快速创建一条线，支持水平、垂直方向，支持通过 UIEdgeInsets 来设置线距离父视图的边距
 */
- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color edgeInsets:(UIEdgeInsets)edgeInsets;
/**
 快速创建一条线，支持水平、垂直方向，支持通过 UIEdgeInsets 来设置线距离父视图的边距，支持设置线的宽度
 */
- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color lineWidth:(CGFloat)lineWidth edgeInsets:(UIEdgeInsets)edgeInsets;

- (void)updateFrameForLine:(UIView *)line;

- (UIViewController *)viewController;
@end


/**
 *  copy from YYCategories(https://github.com/ibireme/YYCategories)
 */
@interface UIView (Geometry)

@property (nonatomic) CGFloat left;        ///< frame.origin.x.
@property (nonatomic) CGFloat top;         ///< frame.origin.y
@property (nonatomic) CGFloat right;       ///< frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< frame.size.width.
@property (nonatomic) CGFloat height;      ///< frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< center.x
@property (nonatomic) CGFloat centerY;     ///< center.y
@property (nonatomic) CGPoint origin;      ///< frame.origin.
@property (nonatomic) CGSize  size;        ///< frame.size.

+ (CGFloat)sizeWithDesignedSize:(CGFloat)designedSize;

@end

@interface UIView (Indicator)

- (void)showIndicator;
- (void)hideIndicator;

@end
