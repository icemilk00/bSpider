//
//  UIView+JFKit.m
//
//  Created by HP on 2019/3/1.
//  Copyright © 2016年 JF. All rights reserved.
//
#import "UIView+JFKit.h"
#import <objc/runtime.h>

#define kLineWidth  0.5

static const void *JFLineAssociatedType = "JFLineAssociatedType";
static const void *JFLineAssociatedLineWidth = "JFLineAssociatedLineWidth";
static const void *JFLineAssociatedEdgeInsets = "JFLineAssociatedEdgeInsets";

@implementation UIView (JFKit)

- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color offset:(CGFloat)offset {
    return [self jf_addLineWithType:type color:color offset:offset padding:0];
}

- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color offset:(CGFloat)offset padding:(CGFloat)padding {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    
    switch (type) {
        case JFLineTypeLeft: {
            line.frame = CGRectMake(0 + offset, 0 + padding, kLineWidth, CGRectGetHeight(self.frame) - 2 * padding);
            break;
        }
        case JFLineTypeTop: {
            line.frame = CGRectMake(0 + padding, 0 + offset, CGRectGetWidth(self.frame) - 2 * padding, kLineWidth);
            break;
        }
        case JFLineTypeRight: {
            line.frame = CGRectMake(CGRectGetWidth(self.frame) - kLineWidth - offset, 0 + padding, kLineWidth, CGRectGetHeight(self.frame) - 2 * padding);
            break;
        }
        case JFLineTypeBottom: {
            line.frame = CGRectMake(0 + padding, CGRectGetHeight(self.frame) - kLineWidth - offset, CGRectGetWidth(self.frame) - 2 * padding, kLineWidth);
            break;
        }
    }
    
    [self addSubview:line];
    return line;
}

- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color {
    return [self jf_addLineWithType:type color:color edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color edgeInsets:(UIEdgeInsets)edgeInsets {
    return [self jf_addLineWithType:type color:color lineWidth:kLineWidth edgeInsets:edgeInsets];
}

- (UIView *)jf_addLineWithType:(JFLineType)type color:(UIColor *)color lineWidth:(CGFloat)lineWidth edgeInsets:(UIEdgeInsets)edgeInsets {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    
    objc_setAssociatedObject(line, JFLineAssociatedType, @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(line, JFLineAssociatedLineWidth, @(lineWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSValue *value = [NSValue valueWithUIEdgeInsets:edgeInsets];
    objc_setAssociatedObject(line, JFLineAssociatedEdgeInsets, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self updateFrameForLine:line withType:type lineWidth:lineWidth edgeInsets:edgeInsets];
    
    [self addSubview:line];
    return line;
}

- (void)updateFrameForLine:(UIView *)line {
    id object = objc_getAssociatedObject(line, JFLineAssociatedType);
    JFLineType type = [object integerValue];
    object = objc_getAssociatedObject(line, JFLineAssociatedLineWidth);
    CGFloat lineWidth = [object floatValue];
    NSValue *value = objc_getAssociatedObject(line, JFLineAssociatedEdgeInsets);
    UIEdgeInsets edgeInsets = [value UIEdgeInsetsValue];
    [self updateFrameForLine:line withType:type lineWidth:lineWidth edgeInsets:edgeInsets];
}

- (void)updateFrameForLine:(UIView *)line withType:(JFLineType)type lineWidth:(CGFloat)lineWidth edgeInsets:(UIEdgeInsets)edgeInsets {
    switch (type) {
        case JFLineTypeLeft: {
            line.frame = CGRectMake(0 + edgeInsets.left, 0 + edgeInsets.top, lineWidth, CGRectGetHeight(self.frame) - edgeInsets.top - edgeInsets.bottom);
            break;
        }
        case JFLineTypeTop: {
            line.frame = CGRectMake(0 + edgeInsets.left, 0 + edgeInsets.top, CGRectGetWidth(self.frame) - edgeInsets.left - edgeInsets.right, lineWidth);
            break;
        }
        case JFLineTypeRight: {
            line.frame = CGRectMake(CGRectGetWidth(self.frame) - lineWidth - edgeInsets.right, 0 + edgeInsets.top, lineWidth, CGRectGetHeight(self.frame) - edgeInsets.top - edgeInsets.bottom);
            break;
        }
        case JFLineTypeBottom: {
            line.frame = CGRectMake(0 + edgeInsets.left, CGRectGetHeight(self.frame) - lineWidth - edgeInsets.bottom, CGRectGetWidth(self.frame) - edgeInsets.left - edgeInsets.right, lineWidth);
            break;
        }
    }
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end


@implementation UIView (Geometry)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

+ (CGFloat)sizeWithDesignedSize:(CGFloat)designedSize {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat designedScreenWidth = 750;
    CGFloat size = screenWidth / designedScreenWidth * designedSize;
    return size;
}

@end

#define kJFIndicatorTag 9999

@implementation UIView (Indicator)

- (void)showIndicator {
    UIActivityIndicatorView *indicator = [self jf_indicatorView];
    [indicator startAnimating];
}

- (void)hideIndicator {
    UIActivityIndicatorView *indicator = [self jf_indicatorView];
    [indicator stopAnimating];
}

- (UIActivityIndicatorView *)jf_indicatorView {
    UIActivityIndicatorView *indicator = [self viewWithTag:kJFIndicatorTag];
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        indicator.tag = kJFIndicatorTag;
        [self addSubview:indicator];
    }
    return indicator;
}

@end
