//
//  SmsADCell.m
//  BlessingSMS
//
//  Created by hp on 2019/10/11.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "SmsADCell.h"

@implementation SmsADCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.bgView.layer.shadowOpacity = 0.8;
    self.bgView.layer.shadowRadius = 1;
//    self.bgView.layer.masksToBounds = YES;
    self.bgView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
