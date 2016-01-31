//
//  DefaultNavView.m
//  FDCommonFrameWork
//
//  Created by hp on 15/10/22.
//  Copyright (c) 2015年 hxp. All rights reserved.
//

#import "DefaultNavView.h"

NSString * const KeyLeftButton = @"KeyLeftButton";
NSString * const KeyRightButton = @"KeyRightButton";

#define NAV_TITLE_LABEL_FRAME  CGRectMake(SCREEN_WIDTH/2 - 220.0f/2, STATENBAR_HEIGHT, 220.0f, 44.0f)

@implementation DefaultNavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithConfig:(NSArray *)configArray
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
    if (self) {
//        [self addSubview:self.bgImageView];
        self.backgroundColor = DEFAULT_BG_COLOR;
        [self addSubview:self.titleLabel];
        [self setupUICongif:configArray];
    }
    return self;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:NAV_TITLE_LABEL_FRAME];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.textColor = [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:1];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _titleLabel;
}

-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_bgImageView setImage:[UIImage imageNamed:@"navigationbarBg_red"]];
        _bgImageView.backgroundColor = [UIColor clearColor];
    }
    return _bgImageView;
}

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

#pragma mark -- UI Config --
-(void)setupUICongif:(NSArray *)configArray
{
    for (NSString *configStr in configArray) {
        
        if ([configStr isEqualToString:KeyLeftButton]) {
            [self setupLeftButton];
        }
        
        if ([configStr isEqualToString:KeyRightButton]) {
            [self setupRightButton];
        }
    }
}


@end


@implementation DefaultNavView (ExtenLeftButton)

-(void)setLeftButton:(UIButton *)leftButton
{
    objc_setAssociatedObject(self, &KeyLeftButton, leftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)leftButton
{
    return objc_getAssociatedObject(self, &KeyLeftButton);
}

-(void)setupLeftButton
{
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 44.0f, 44.0f)];
    [self.leftButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftButton];
}

-(void)leftButtonClicked:(UIButton *)sender
{
    NSLog(@"NavLeftButtonClicked ==");
    if (self.defaultNavDelegate && [self.defaultNavDelegate respondsToSelector:@selector(navLeftButtonClicked:)]) {
        [self.defaultNavDelegate navLeftButtonClicked:sender];
    }
}

@end

@implementation DefaultNavView (ExtenRightButton)

-(void)setRightButton:(UIButton *)rightButton
{
    objc_setAssociatedObject(self, &KeyRightButton, rightButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)rightButton
{
    return objc_getAssociatedObject(self, &KeyRightButton);
}

-(void)setupRightButton
{
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 44.0f, 20.0f, 44.0f, 44.0f)];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
   [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.rightButton];
}

-(void)rightButtonClicked:(UIButton *)sender
{
    NSLog(@"NavRightButtonClicked ==");
    if (self.defaultNavDelegate && [self.defaultNavDelegate respondsToSelector:@selector(navRightButtonClicked:)]) {
        [self.defaultNavDelegate navRightButtonClicked:sender];
    }
}

@end

