//
//  MaterialBannerCell.m
//  
//
//  Created by hp on 2019/3/15.
//  Copyright © 2019 com.jcfc. All rights reserved.
//

#import "MaterialBannerCell.h"
#import "UIImageView+WebCache.h"

@interface MaterialBannerCell ()<JFBannerViewDelegate>

@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation MaterialBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _bannerView = [[JFBannerView alloc] initWithFrame:self.bounds];
        _bannerView.delegate = self;
        _bannerView.imageViewContentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_bannerView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self.contentView addSubview:_pageControl];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _bannerView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(self.bounds.size.width/2 - 30, self.bounds.size.height - 15 - 5, 60, 15);
}

- (void)setData:(NSArray *)data{
    _data = data;
    if (!_data || _data.count == 0) {
        return ;
    }
    
    _bannerView.pageCount = data.count;
    if (data.count == 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.numberOfPages = data.count;
        self.pageControl.currentPage = 0;
    }
    
}

- (void)bannerView:(JFBannerView *)bannerView configImageView:(UIImageView *)imageView atIndex:(NSUInteger)index {
    
    NSString *imagePath = [CommonHelper addHttpForUrlStr:self.data[index]];
    NSURL *url = [NSURL URLWithString:[imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [imageView sd_setImageWithURL:url];
}

-(void)bannerView:(JFBannerView *)bannerView scrollAtIndex:(NSInteger)index{
    self.pageControl.currentPage = index;
}

-(void)bannerView:(JFBannerView *)bannerView didSelectAtIndex:(NSInteger)index{
    NSString *detailStr = self.data[index][@"imgurl"];
//    JFWebViewController *web = [[JFWebViewController alloc] initWithUrlString:detailStr];
////    web.title = @"广告";
//    [JFNavigation pushViewController:web animated:YES];

}

@end
