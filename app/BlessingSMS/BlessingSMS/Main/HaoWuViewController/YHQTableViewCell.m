//
//  YHQTableViewCell.m
//  BlessingSMS
//
//  Created by hp on 2019/5/10.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "YHQTableViewCell.h"

@implementation YHQTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.showImageView.layer.cornerRadius = 3;
    self.showImageView.layer.masksToBounds = YES;
    self.juanLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.juanLabel.layer.borderWidth = 1;
}

-(void)setupWithModel:(YHQInfoModel *)model {
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.pict_url]];
    
    
    NSMutableAttributedString *fullTitle = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
    attchment.bounds = CGRectMake(0, -3, 15, 15);//设置frame
    if (model.user_type.integerValue == 1) {
        attchment.image = [UIImage imageNamed:@"天猫"];//设置图片
    } else {
        attchment.image = [UIImage imageNamed:@"淘宝"];//设置图片
    }
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
    [fullTitle appendAttributedString:string];
    [fullTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [fullTitle appendAttributedString:[[NSAttributedString alloc] initWithString:model.title]];
    self.titleLabel.attributedText = fullTitle;
    
    self.juanLabel.text = [NSString stringWithFormat:@"%@元",[model juanPrice]];
    self.soldNumLabel.text = [NSString stringWithFormat:@"月售%@件",model.volume];
    
    NSMutableAttributedString *allStr = [[NSMutableAttributedString alloc] initWithString:@"卷后￥"];
    NSString *afterPrice = [NSString getSubStringWithStringA:model.zk_final_price stringB:[model juanPrice]];
    afterPrice = [NSString interceptionPointString:afterPrice];
    NSAttributedString *price = [[NSAttributedString alloc] initWithString:afterPrice attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *beforePrice = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",model.zk_final_price] attributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    [allStr appendAttributedString:price];
    [allStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" "]]];
    [allStr appendAttributedString:beforePrice];
    self.afterPriceLabel.attributedText = allStr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
