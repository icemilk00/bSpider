//
//  MaterialInfoCell.h
//  BlessingSMS
//
//  Created by hp on 2019/5/14.
//  Copyright © 2019 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MaterialInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *juanLabel;
@property (strong, nonatomic) IBOutlet UILabel *soldNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *afterPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *beforePriceLabel;
-(void)setupWithModel:(MaterialDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
