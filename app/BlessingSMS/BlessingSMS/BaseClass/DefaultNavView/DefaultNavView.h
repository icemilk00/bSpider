//
//  DefaultNavView.h
//  FDCommonFrameWork
//
//  Created by hp on 15/10/22.
//  Copyright (c) 2015年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const KeyLeftButton;
extern NSString * const KeyRightButton;

@protocol DefaultNavDelegate <NSObject>

@optional
-(void)navLeftButtonClicked:(UIButton *)sender;
-(void)navRightButtonClicked:(UIButton *)sender;

@end

@interface DefaultNavView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bgImageView;

-(id)initWithConfig:(NSArray *)configArray;

@property (nonatomic, assign) id <DefaultNavDelegate> defaultNavDelegate;

@end

@interface DefaultNavView (ExtenLeftButton)

@property (nonatomic, strong) UIButton *leftButton;

-(void)setupLeftButton;

@end

@interface DefaultNavView (ExtenRightButton)

@property (nonatomic, strong) UIButton *rightButton;

-(void)setupRightButton;

@end