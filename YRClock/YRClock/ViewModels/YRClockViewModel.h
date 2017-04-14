//
//  YRClockViewModel.h
//  YRClock
//
//  Created by mac on 17/4/8.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "YRBaseViewModel.h"

@interface YRClockViewModel : YRBaseViewModel
/**
 *  获取简单的数据,即Cell中的数据
 *
 *  @param index cell.indexPath.row
 */
-(void)getClockSimpleDataWithIndex:(NSInteger)index;

//闹钟开关状态
@property(nonatomic,assign)BOOL isOpen;
//闹钟铃声
@property(nonatomic,copy)NSString *clockRing;
//闹钟提醒间隔时间
@property(nonatomic,copy)NSString *clockRemindType;
/**
 * 闹钟音量(0 - 15)
 */
@property(nonatomic,assign)NSInteger clockVolume;
//保存按钮事件
@property(nonatomic,strong)RACCommand *saveCommand;
//删除按钮事件
@property(nonatomic,strong)RACCommand *deleteCommand;

@property(nonatomic,assign)CLOCKTYPE clockModelType;

@property(nonatomic,assign)CLOCKREMINDTYPE clockModelRemindType;

@property(nonatomic,strong)RACSignal *openSignal;

@property(nonatomic,strong)UIColor *color;

@property(nonatomic,strong)UIColor *timeColor;

@property(nonatomic,strong)RACSignal *update_signal;
@end
