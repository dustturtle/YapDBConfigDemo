//
//  ViewController.m
//  YapDBConfigDemo
//
//  Created by Zhenwei Guan on 2018/10/11.
//  Copyright © 2018 Zhenwei Guan. All rights reserved.
//

#import "ViewController.h"
#import "GlobalConfig+FQ.h"

@interface ViewController ()

@end

@implementation ViewController

// YapDB,真的是灰常的牛逼，设计相当的复杂。逼近coredata。
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BOOL flag = GFQConfig.isAdult;
    
    //GFQConfig.isAdult = YES;
    
    //GFQConfig.timeInterval = @"36";
    NSString *timeStr = GFQConfig.screenAlwaysOn;
    NSLog(@"test,timeInterval:%@", timeStr);
    
    NSMutableDictionary *dic = GFQConfig.dicInfo;
    NSLog(@"test,dicInfo:%@", dic);
    
}


@end
