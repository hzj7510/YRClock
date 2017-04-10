//
//  YRBaseViewModel.h
//  YRClock
//
//  Created by mac on 17/4/8.
//  Copyright © 2017年 x5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRClockModel.h"
#import "DataSingleton.h"

@interface YRBaseViewModel : NSObject
/**
 *  获取数据
 *
 *  @param index cell.indexPath.row
 */
-(void)getClockDataWithIndex:(NSInteger)index;
//闹钟名字
@property(nonatomic,copy)NSString *clockName;
//闹钟类型
@property(nonatomic,copy)NSString *clockType;
//闹钟时间
@property(nonatomic,copy)NSString *clockTime;
//数据
@property(nonatomic,strong)DataSingleton *data;
//当前cell的model
@property(nonatomic,strong)YRClockModel *model;
@end
