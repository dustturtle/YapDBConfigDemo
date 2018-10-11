//
//  GlobalConfig.m
//  SignIn
//
//  Created by KevinJack on 15/9/17.
//  Copyright (c) 2015年 QCStudio. All rights reserved.
//

#import "GlobalConfig.h"
#import <objc/runtime.h>
#import "YapDBManager.h"

@interface GlobalConfig ()
{
    NSMutableDictionary *_mapping;
}

// 无dynamic标识的属性，动态添加了getter/setter也不会调用其新增的动态方法;这里放心使用。
@property (strong, nonatomic) NSDictionary *configDefaults;

@end

@implementation GlobalConfig

#pragma - mark Singlton Method

+ (instancetype)sharedInstance
{
    static id globalConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalConfig = [[self alloc] init];
    });
    
    return globalConfig;
}

#pragma - mark System methods

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadDefaults];
        [self generateAccessorMethods];
    }
    
    return self;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"   // 屏蔽下面代码引起的告警，

// 赋值初始化功能
- (void)loadDefaults
{
    SEL setupDefaultSEL = NSSelectorFromString(@"setupDefaults");
    
    if ([self respondsToSelector:setupDefaultSEL])
    {
        self.configDefaults = [self performSelector:setupDefaultSEL];
    }
}

#pragma - mark Inner Methods

- (NSString *)defaultsKeyForSelector:(SEL)selector
{
    return [_mapping objectForKey:NSStringFromSelector(selector)];
}

static id objectGetter(GlobalConfig *self, SEL _cmd)
{
    __block NSString *objectValue;
    NSString *key = [self defaultsKeyForSelector:_cmd];
    
    [GYapDBManager.readonlyConnection readWithBlock:^(YapDatabaseReadTransaction *transaction)
     {
         objectValue = [transaction objectForKey:key inCollection:@"GlobalConfig"];
     }];
    
    if (objectValue)
    {
        return objectValue;
    }
    else
    {
        if (self.configDefaults[key])
        {
            return self.configDefaults[key];
        }
        else
        {
            // final default is @""
            return @"";
        }
    }
}

static void objectSetter(GlobalConfig *self, SEL _cmd, id object)
{
    // may set nil object to remove object for key from db.
    NSString *key = [self defaultsKeyForSelector:_cmd];

    [GYapDBManager.readwriteConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction)
    {
        [transaction setObject:object forKey:key inCollection:@"GlobalConfig"];
    }];
}

#pragma - mark generate runtime property methods

- (void)generateAccessorMethods
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    _mapping = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < count; ++i)
    {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);

        char *getter = strdup(name);
        SEL getterSel = sel_registerName(getter);
        free(getter);
        
        char *setter;
        asprintf(&setter, "set%c%s:", toupper(name[0]), name + 1);
        SEL setterSel = sel_registerName(setter);
        free(setter);

        NSString *key = [NSString stringWithFormat:@"%s", name];
        [_mapping setValue:key forKey:NSStringFromSelector(getterSel)];
        [_mapping setValue:key forKey:NSStringFromSelector(setterSel)];
        
        IMP getterImp = (IMP)objectGetter;
        IMP setterImp = (IMP)objectSetter;
    
        char types[5];
        
        snprintf(types, 4, "@@:");
        class_addMethod([self class], getterSel, getterImp, types);
        
        snprintf(types, 5, "v@:@");
        class_addMethod([self class], setterSel, setterImp, types);
    }
    
    free(properties);
}

- (void)cleanConfigs
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        if ([propertyName isEqualToString:@"configDefaults"])
        {
            continue;   //原生属性，不做任何处理
        }
        
        if (self.configDefaults[propertyName])
        {
            [self setValue:self.configDefaults[propertyName] forKey:propertyName];
        }
        else
        {
            [self setValue:@"" forKey:propertyName];
        }
    }
    
    free(properties);
}

@end
