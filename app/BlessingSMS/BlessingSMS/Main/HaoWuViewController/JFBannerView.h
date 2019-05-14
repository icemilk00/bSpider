//
//  JFBannerView.h
//
//
//  Created by HP on 19/3/15.
//  Copyright © 2016年 JCFC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFBannerView;

@protocol JFBannerViewDelegate <NSObject>

- (void)bannerView:(JFBannerView *)bannerView configImageView:(UIImageView *)imageView atIndex:(NSUInteger)index;
@optional
- (void)bannerView:(JFBannerView *)bannerView scrollAtIndex:(NSInteger)index;
- (void)bannerView:(JFBannerView *)bannerView didSelectAtIndex:(NSInteger)index;

@end

@interface JFBannerView : UIView

@property (nonatomic, weak) id<JFBannerViewDelegate> delegate;
@property (nonatomic, unsafe_unretained) NSUInteger pageCount;
@property (nonatomic, unsafe_unretained) UIViewContentMode imageViewContentMode;
@property (nonatomic, unsafe_unretained) NSTimeInterval interval;

@property (unsafe_unretained, nonatomic) NSInteger index;  //数组中图片索引

- (void)startTimer;
- (void)stopTimer;

@end
