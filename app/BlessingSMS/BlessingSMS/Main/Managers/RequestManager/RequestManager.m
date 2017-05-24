//
//  RequestManager.m
//  DoDemo
//
//  Created by hp on 15/7/16.
//  Copyright (c) 2015年 hp. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        
        [self.requestSerializer setValue:[[self class] appVersion] forHTTPHeaderField:@"c_version"];
    }
    return self;
}

+(NSString *)appVersion
{
    // app版本
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appVer = [NSString stringWithFormat:@"%@.%@", app_Version, app_build];
    return appVer;
}

@end
