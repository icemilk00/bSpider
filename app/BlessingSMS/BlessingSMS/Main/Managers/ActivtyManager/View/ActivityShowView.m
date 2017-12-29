//
//  ActivityShowView.m
//
//  Created by mac on 2017/12/29.
//

#import "ActivityShowView.h"

@implementation ActivityShowView

-(void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
    self.frame = [UIScreen mainScreen].bounds;
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

-(void)tapAction
{
    [self removeFromSuperview];
}

-(void)show
{
    self.showLabel.text = self.showStr;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}
- (IBAction)leftAction:(id)sender {
    [self removeFromSuperview];
}


- (IBAction)rightAction:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.showStr;
    [MBProgressHUD showHUDWithTitle:@"复制成功"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipay://"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
