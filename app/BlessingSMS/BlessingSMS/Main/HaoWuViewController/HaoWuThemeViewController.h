//
//  HaoWuThemeViewController.h
//  BlessingSMS
//
//  Created by hp on 2019/5/8.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HaoWuThemeViewController : BaseViewController <APIManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *materialId;
@end

NS_ASSUME_NONNULL_END
