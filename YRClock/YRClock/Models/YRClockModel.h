//
//  YRClockModel.h
//  YRClock
//
//  Created by mac on 17/4/8.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "YRBaseModel.h"

@interface YRClockModel : YRBaseModel
//闹钟开关状态
@property(nonatomic,assign)BOOL isOpen;
//闹钟铃声
@property(nonatomic,copy)NSString *clockRing;
//闹钟音量
@property(nonatomic,assign)NSInteger clockVolume;
//闹钟延迟提醒时间
@property(nonatomic,assign)CLOCKREMINDTYPE clockRemindType;
@end
