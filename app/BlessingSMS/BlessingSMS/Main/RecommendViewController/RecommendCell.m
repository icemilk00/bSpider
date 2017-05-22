//
//  RecommendCell.m
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "RecommendCell.h"

@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 3.0f;
}

-(void)setupWithModel:(RecommendInfoModel *)model
{
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:[model showImageStr]]];
    _titleLabel.text = model.title;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.zk_final_price_wap];
    
    CGFloat height = [LayerHelper sizeWithContent:model.title andFont:_titleLabel.font andDrawSize:CGSizeMake(_titleLabel.frame.size.width, MAXFLOAT)].height;
    
    if (height > 47) {
        height = 47;
    }
    
    _titleHeight.constant = height + 1;
    
}


@end
