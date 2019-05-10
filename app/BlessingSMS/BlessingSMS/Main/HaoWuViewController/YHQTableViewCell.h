//
//  YHQTableViewCell.h
//  BlessingSMS
//
//  Created by hp on 2019/5/10.
//  Copyright © 2019 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHQInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHQTableViewCell : UITableViewCell

-(void)setupWithModel:(YHQInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
