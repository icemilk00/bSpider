//
//  CommonHelper.m
//  BlessingSMS
//
//  Created by hp on 2019/5/14.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper

+(NSString *)addHttpsForUrlStr:(NSString *)urlStr {
    NSMutableString *str = [[NSMutableString alloc] initWithString:urlStr];
    if (![urlStr containString:@"http"]) {
        [str insertString:@"https:" atIndex:0];
    }
    return str;
}

+(NSString *)addHttpForUrlStr:(NSString *)urlStr {
    NSMutableString *str = [[NSMutableString alloc] initWithString:urlStr];
    if (![urlStr containString:@"http"]) {
        [str insertString:@"http:" atIndex:0];
    }
    return str;
}

@end
