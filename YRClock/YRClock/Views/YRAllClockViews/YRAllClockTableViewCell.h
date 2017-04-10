//
//  YRAllClockTableViewCell.h
//  YRClock
//
//  Created by mac on 17/4/6.
//  Copyright © 2017年 x5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRClockModel.h"

@interface YRAllClockTableViewCell : UITableViewCell
//闹钟时间Label
@property(nonatomic,strong)UILabel *timeLb;
//闹钟名字Label
@property(nonatomic,strong)UILabel *clockNameLb;
//闹钟类型  (仅一次，周一到周五...)
@property(nonatomic,strong)UILabel *typeLb;
//闹钟状态  (关闭显示关闭,打开显示剩余时间)
@property(nonatomic,strong)UILabel *statusLb;
//闹钟开关
@property(nonatomic,strong)UISwitch *statusSwitch;
//开关信号量
@property(nonatomic,strong)RACSubject *switchSubject;


@end
