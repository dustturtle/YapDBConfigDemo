//
//  GlobalConfig+FQ.m
//  SignIn
//
//  Created by KevinJack on 15/9/17.
//  Copyright (c) 2015年 QCStudio. All rights reserved.
//

#import "GlobalConfig+FQ.h"
#import <objc/runtime.h>


@implementation GlobalConfig (FQ)

@dynamic dicInfo;
@dynamic screenAlwaysOn;
@dynamic strictModeOn;
@dynamic silenceMode;
@dynamic timeInterval;

@dynamic timeoutSecs;

@dynamic isAdult;
@dynamic magicNum;
@dynamic testDouble;

// Category need to implement this method to setup default values.
- (NSDictionary *)setupDefaults
{
    return @{
             @"silenceMode":@"0",
             @"screenAlwaysOn":@"320",
             @"strictModeOn":@"0",
             @"timeInterval":@(18),
             @"isAdult": @(NO),
             @"magicNum":@(88),
             @"testDouble":@(66.66666),
             };
}

- (BOOL)switchValue:(NSString *)switchConfig
{
    if ([switchConfig isEqualToString:@"0"])
    {
        return NO;
    }
    
    if ([switchConfig isEqualToString:@"1"])
    {
        return YES;
    }

    return NO;
}

@end
