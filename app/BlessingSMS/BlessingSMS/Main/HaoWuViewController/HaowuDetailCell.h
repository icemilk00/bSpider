//
//  HaowuDetailCell.h
//  BlessingSMS
//
//  Created by hp on 2019/5/18.
//  Copyright © 2019 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HaowuDetailCell : UITableViewCell <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;
@end

NS_ASSUME_NONNULL_END
