//
//  SMSCategoryCell.m
//  BlessingSMS
//
//  Created by hp on 16/1/3.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "SMSCategoryCell.h"

@implementation SMSCategoryCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updateWithModel:(SMSCategoryModel *)model andIsSubCategory:(BOOL)isSubCategory
{
    self.categoryTitleLabel.text = model.categoryName;
    if (isSubCategory) {
        self.categoryTitleLabel.frame = CGRectMake(50.0f, self.categoryTitleLabel.frame.origin.y, 200.0f, self.categoryTitleLabel.frame.size.height);
    }
    else
    {
        self.categoryTitleLabel.frame = CGRectMake(10.0f, self.categoryTitleLabel.frame.origin.y, 200.0f, self.categoryTitleLabel.frame.size.height);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
