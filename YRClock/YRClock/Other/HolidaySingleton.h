//
//  HolidaySingleton.h
//  YRClock
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 x5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolidaySingleton : NSObject
+ (instancetype)sharedInstance;

@property(nonatomic, strong)NSArray *dataArray;
@end
