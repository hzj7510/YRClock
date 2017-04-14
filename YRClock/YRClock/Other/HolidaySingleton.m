//
//  HolidaySingleton.m
//  YRClock
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "HolidaySingleton.h"

@implementation HolidaySingleton

+ (instancetype)sharedInstance{
    static HolidaySingleton * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (NSArray *)dataArray {
    if(_dataArray == nil) {
        _dataArray = @[@"4-29",@"4-30",@"5-1",@"5-28",@"5-29",@"5-30",@"10-1",@"10-2",@"10-3",@"10-4",@"10-5",@"10-6",@"10-7",@"10-8",@"4-13"];
    }
    return _dataArray;
}


@end
