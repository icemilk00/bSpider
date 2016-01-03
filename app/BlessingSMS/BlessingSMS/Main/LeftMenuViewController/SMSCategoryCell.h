//
//  SMSCategoryCell.h
//  BlessingSMS
//
//  Created by hp on 16/1/3.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSCategoryModel.h"

@interface SMSCategoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *categoryTitleLabel;

-(void)updateWithModel:(SMSCategoryModel *)model andIsSubCategory:(BOOL)isSubCategory;

@end
