//
//  GlobalConfig.h
//  SignIn
//
//  从gvuserdefault切换到db的需求造就了这个设计；具体runtime相关实现参考了gvuserdefault。
//  目标是设计一个全局的持久化配置适配层；目前仅适配了yapDB,修改几行代码即可支持userDefault;
//  后续计划将数据持久化的实现抽象成协议，使用globalconfig可同时适配多种持久化方案;在github上开源。(待完成。)
//  暂不支持基本数据类型（只可以存储字符串或对象）。 ??? GZW
//  TODO:需要支持基本数据类型的测试用例！！！，BOOL和double等。
//  !!!Update:已经支持bool/nsinteger(其实是long)/double
//  注意：这里的double转换会出现位数变化的问题，但其值基本上可以认为是ok的。例: from 33.3->33.299999999999997
//  从iOS7开始应该就已经是64位，nsinteger应该都是long
//  参考: gvuserdefault （支持userDefault）; 待适配FMDB.
//
//  Created by KevinJack on 15/9/17.
//  Copyright (c) 2015年 QCStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalConfig : NSObject

+ (instancetype)sharedInstance;

- (void)cleanConfigs;

@end
