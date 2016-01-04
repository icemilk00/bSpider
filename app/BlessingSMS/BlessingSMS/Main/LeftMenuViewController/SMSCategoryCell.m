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
    
    if (model.isHasChildCategory) {
        if (model.isExpand) {
            [self setAccessImageViewType:CategoryCellAccessShowUp];
        }
        else
        {
            [self setAccessImageViewType:CategoryCellAccessShowDown];
        }
    }
    else
    {
        [self setAccessImageViewType:CategoryCellAccessShowNomal];
    }
}

-(void)setAccessImageViewType:(CategoryCellAccessShowType)type
{
    if (type == CategoryCellAccessShowNomal) {
        _accessImageView.hidden = NO;
        _accessUpImageView.hidden = YES;
        _accessDownImageView.hidden = YES;
    }
    
    if (type == CategoryCellAccessShowUp) {
        _accessImageView.hidden = YES;
        _accessUpImageView.hidden = NO;
        _accessDownImageView.hidden = YES;
    }
    
    if (type == CategoryCellAccessShowDown) {
        _accessImageView.hidden = YES;
        _accessUpImageView.hidden = YES;
        _accessDownImageView.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
