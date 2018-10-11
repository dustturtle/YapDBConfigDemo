//
//  YapDBManager.m
//  SignIn
//
//  Created by KevinJack on 15/9/14.
//  Copyright (c) 2015年 QCStudio. All rights reserved.
//

#import "YapDBManager.h"
#import "CocoaLumberjack.h"

@interface YapDBManager()

@property (nonatomic, strong)YapDatabase *database;

@end

@implementation YapDBManager

#pragma - mark Singlton Methodd

+ (instancetype)sharedInstance
{
    static id sharedDBManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDBManager = [[self alloc] init];
    });
    
    return sharedDBManager;
}

- (NSString *)databasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
    
    NSString *databaseName = @"YapDBConfig.sqlite";
    
    return [baseDir stringByAppendingPathComponent:databaseName];
}

- (void)setupDatabase
{
    YapDatabaseOptions *options = [[YapDatabaseOptions alloc] init];
    options.corruptAction = YapDatabaseCorruptAction_Fail;
    
    // openssl not included by apple now, need to compile by ourself.
    // So now we do not use sqlcipher here in early versions.
//    options.cipherKeyBlock = ^{
//        // You can also do things like fetch from the keychain in here
//
//        NSLog(@"cipherKeyBlock excuting");
//        NSString *passPhrase = @"options.corruptAction = YapDatabaseCorruptAction_Fail;";
//        NSData *data = [passPhrase  dataUsingEncoding:NSUTF8StringEncoding];
//        return data;
//    };
    
    //DDLogVerbose(@"Creating database instance...");
    NSString *databasePath = [self databasePath];
    self.database = [[YapDatabase alloc] initWithPath:databasePath
                                           serializer:nil
                                         deserializer:nil
                                              options:options];
    
    self.readonlyConnection = [self.database newConnection];
    self.readwriteConnection = [self.database newConnection];
}

@end
