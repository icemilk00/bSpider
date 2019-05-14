//
//  MaterialBannerCell.h
//
//
//  Created by hp on 2019/3/15.
//  Copyright © 2019 com.jcfc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFBannerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MaterialBannerCell : UITableViewCell
@property (strong, nonatomic) JFBannerView *bannerView;
@property (strong, nonatomic) NSArray *data;
@end

NS_ASSUME_NONNULL_END
