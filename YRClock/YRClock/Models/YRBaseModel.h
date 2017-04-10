//
//  YRBaseModel.h
//  YRClock
//
//  Created by mac on 17/4/8.
//  Copyright © 2017年 x5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface YRBaseModel : NSObject
//闹钟名
@property(nonatomic,copy)NSString *clockName;
//闹钟时间
@property(nonatomic,copy)NSString *clockTime;
//闹钟类型
@property(nonatomic,assign)CLOCKTYPE clockType;

@end
