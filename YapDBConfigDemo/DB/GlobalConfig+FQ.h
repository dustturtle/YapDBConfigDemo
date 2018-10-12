//
//  GlobalConfig+FQ.h
//  SignIn
//
//  基于Yapdb存储的配置项便捷访问封装。
//
//
//  Created by KevinJack on 15/9/17.
//  Copyright (c) 2015年 QCStudio. All rights reserved.
//

#import "GlobalConfig.h"
#import <UIKit/UIKit.h>

#define GFQConfig [GlobalConfig sharedInstance]

@interface GlobalConfig (FQ)

// 以下几个为配置项；0表示是，1表示否。
@property (nonatomic, copy) NSString *screenAlwaysOn;
@property (nonatomic, copy) NSString *strictModeOn;
@property (nonatomic, copy) NSString *silenceMode;

// 保存默认的番茄钟长度，格式：30 (用字符串表示的数字,单位为分钟)
@property (nonatomic, assign) NSInteger timeInterval;

@property (nonatomic, assign) NSInteger magicNum;

@property (nonatomic, assign) NSInteger timeoutSecs;

@property (nonatomic, assign) BOOL isAdult;

@property (nonatomic, assign) double testDouble;

// Yap天生就支持对象类型
@property (nonatomic) NSMutableDictionary *dicInfo;

- (BOOL)switchValue:(NSString *)switchConfig;

@end
