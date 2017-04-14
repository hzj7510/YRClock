//
//  ClockSingleton.m
//  YRClock
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "ClockSingleton.h"

@implementation ClockSingleton

+ (instancetype)sharedInstance{
    static ClockSingleton * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (NSArray *)dataArray {
    if(_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}
@end
