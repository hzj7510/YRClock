//
//  ClockSingleton.h
//  YRClock
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 x5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClockSingleton : NSObject
+ (instancetype)sharedInstance;

//数据array
@property(nonatomic,strong)NSArray *dataArray;

//-(void)updateDataArray;

@end
