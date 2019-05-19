//
//  HaowuDetailCell.m
//  BlessingSMS
//
//  Created by hp on 2019/5/18.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "HaowuDetailCell.h"

@implementation HaowuDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.detailWebView.scalesPageToFit = YES;
    self.detailWebView.backgroundColor = [UIColor whiteColor];
    self.detailWebView.delegate = self;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self forbidWebviewEnlargedAndShrink:webView];
    
}

//禁止webview页面放大缩小
-(void)forbidWebviewEnlargedAndShrink:(UIWebView *)webView{
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
