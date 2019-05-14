//
//  JFBannerView.m
//
//
//  Created by Mac HP 19/3/15.
//  Copyright © 2016年 JCFC. All rights reserved.
//

#import "JFBannerView.h"

@interface JFBannerView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView  *currentImageView; //当前视图
@property (strong, nonatomic) UIImageView  *nextImageView;    //下一个视图
@property (strong, nonatomic) UIImageView  *previousImageView;     //上一个视图

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation JFBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _pageCount = 0;
        _index = 0;
        _interval = 3.0;
        _imageViewContentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.scrollView];
        
        [self.scrollView addSubview:self.currentImageView];
        [self.scrollView addSubview:self.nextImageView];
        [self.scrollView addSubview:self.previousImageView];
    }
    return self;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
        [_scrollView addGestureRecognizer:tap];
        
    }
    return _scrollView;
}

- (UIImageView *)currentImageView{
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] init];
        _currentImageView.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        _currentImageView.contentMode = self.imageViewContentMode;
    }
    return _currentImageView;
}

- (UIImageView *)nextImageView{
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc]init];
        _nextImageView.frame = CGRectMake(self.scrollView.bounds.size.width * 2, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        _nextImageView.contentMode = self.imageViewContentMode;
    }
    return _nextImageView;
}

- (UIImageView *)previousImageView{
    if (!_previousImageView) {
        _previousImageView = [[UIImageView alloc]init];
        _previousImageView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        _previousImageView.contentMode = self.imageViewContentMode;
    }
    return _previousImageView;
}

- (void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode {
    _imageViewContentMode = imageViewContentMode;
    _previousImageView.contentMode = imageViewContentMode;
    _currentImageView.contentMode = imageViewContentMode;
    _nextImageView.contentMode = imageViewContentMode;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    if ([_delegate respondsToSelector:@selector(bannerView:scrollAtIndex:)]) {
        [_delegate bannerView:self scrollAtIndex:_index];
    }
}

-(void)setPageCount:(NSUInteger)pageCount {
    if (pageCount == 0) {
        self.scrollView.delegate = nil;
        return ;
    } else {
        self.scrollView.delegate = self;
    }
    
    BOOL shouldInitialize = NO;
    if (_pageCount == 0) {
        shouldInitialize = YES;
    }
    
    _pageCount = pageCount;
    
    if (shouldInitialize) {
        NSMutableArray *indexes = [NSMutableArray array];
        if (pageCount == 1) {
            [indexes addObject:@(0)];
            [indexes addObject:@(0)];
            [indexes addObject:@(0)];
            self.scrollView.contentSize = CGSizeMake(0, 0);
        } else if (pageCount == 2) {
            [indexes addObject:@(1)];
            [indexes addObject:@(0)];
            [indexes addObject:@(1)];
        } else {
            [indexes addObject:@(pageCount - 1)];
            [indexes addObject:@(0)];
            [indexes addObject:@(1)];
        }
        
        [self.delegate bannerView:self configImageView:_previousImageView atIndex:[indexes[0] integerValue]];
        [self.delegate bannerView:self configImageView:_currentImageView atIndex:[indexes[1] integerValue]];
        [self.delegate bannerView:self configImageView:_nextImageView atIndex:[indexes[2] integerValue]];
        
        if (pageCount != 1) {
            [self startTimer];
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSUInteger count = self.pageCount;
    
    float offset = scrollView.contentOffset.x;
    if (self.nextImageView.image == nil || self.previousImageView.image == nil) {
        //加载下一个视图
        NSUInteger index = self.index == count-1 ? 0 : self.index+1;
        [self.delegate bannerView:self configImageView:self.nextImageView atIndex:index];
        
        //加载上一个视图
        index = self.index == 0 ? count-1 : self.index-1;
        [self.delegate bannerView:self configImageView:self.previousImageView atIndex:index];
    }
    
    if(offset == 0){
        self.currentImageView.image = self.previousImageView.image;
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        self.previousImageView.image = nil;
        
        if (self.index == 0) {
            self.index = count -1;
        }else{
            self.index -= 1;
        }
    }
    
    if(offset == scrollView.bounds.size.width * 2){
        self.currentImageView.image = self.nextImageView.image;
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        self.nextImageView.image = nil;
        if (self.index == count - 1) {
            self.index = 0;
        }else{
            self.index += 1;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}


//定时器调用方法
- (void)timerAction:(NSTimer *)timer{
    CGPoint offset = self.scrollView.contentOffset;
    offset.x += self.scrollView.bounds.size.width;
    if (offset.x > 2* self.scrollView.bounds.size.width) {
        offset.x = self.scrollView.bounds.size.width;
    }
    [self.scrollView setContentOffset:offset animated:YES];
}

//开启定时器
- (void)startTimer
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

//关闭定时器
- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//点击图片触发事件
- (void)tapClicked{
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectAtIndex:)]) {
        [self.delegate bannerView:self didSelectAtIndex:self.index];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    if (self.pageCount == 1) {
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);
    } else {
        self.scrollView.contentSize = CGSizeMake(3 * self.bounds.size.width, 0);
    }
   self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    _currentImageView.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    _nextImageView.frame = CGRectMake(self.scrollView.bounds.size.width * 2, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    _previousImageView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
}

@end
