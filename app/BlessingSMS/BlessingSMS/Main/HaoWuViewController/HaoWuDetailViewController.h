//
//  HaoWuDetailViewController.h
//  BlessingSMS
//
//  Created by hp on 2019/5/11.
//  Copyright © 2019 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HaoWuDetailViewController : BaseViewController <APIManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MaterialDetailModel *infoModel;
@end

NS_ASSUME_NONNULL_END
