//
//  SmsSendCell.m
//  BlessingSMS
//
//  Created by hp on 16/1/7.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "SmsSendCell.h"

@implementation AddressBookModel

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.phoneNum = dic[@"phoneNum"];
        self.isSelected = NO;
    }
    return self;
}

@end



@implementation SmsSendCell

-(void)sendSelectedWithModel:(AddressBookModel *)model
{
    if (model.isSelected == YES) {
        model.isSelected = NO;
        [self.selectImageView setImage:[UIImage imageNamed:@"cell_unSelected"]];
    }
    else
    {
        model.isSelected = YES;
        [self.selectImageView setImage:[UIImage imageNamed:@"cell_selected"]];
    }
}

-(void)updateUIWithData:(AddressBookModel *)model
{
    self.showTitleLabel.text = model.name;
    self.showPhoneLabel.text = [NSString stringWithFormat:@"电话: %@", model.phoneNum ];
    
    [self.selectImageView setImage:model.isSelected == YES ? [UIImage imageNamed:@"cell_selected"] : [UIImage imageNamed:@"cell_unSelected"]];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
