//
//  SmsCell.m
//  BlessingSMS
//
//  Created by hp on 16/1/1.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "SmsCell.h"

@implementation SmsCell

- (void)awakeFromNib {
    // Initialization code
    self.bgImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgImageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.bgImageView.layer.shadowOpacity = 0.8;
    self.bgImageView.layer.shadowRadius = 1;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
