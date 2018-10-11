//
//  YapDBManager.h
//  SignIn
//
//  Created by KevinJack on 15/9/14.
//  Copyright (c) 2015年 QCStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YapDatabase.h"

#define GYapDBManager [YapDBManager sharedInstance]

@interface YapDBManager : NSObject

// 根据Yap文档的描述，将只读和读写分离有助于提升性能；可以在connection之间共享cache不用反复从disk读取;
// connection中使用的方法不同：readWithBlock/readWriteWithBlock。
@property (nonatomic, strong)YapDatabaseConnection *readwriteConnection;

@property (nonatomic, strong)YapDatabaseConnection *readonlyConnection;

+ (instancetype)sharedInstance;

- (void)setupDatabase;

@end
