//
//  DataSingleton.h
//  YRClock
//
//  Created by mac on 17/4/7.
//  Copyright © 2017年 x5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRClockModel.h"

@interface DataSingleton: NSObject
+ (instancetype)sharedInstance;
//数据array
@property(nonatomic,strong)NSArray *dataArray;
/**
 *  添加数据
 *
 *  @param clockModel 添加的数据
 */
-(void)insertClockListData:(YRClockModel *)clockModel;
/**
 *  删除数据
 *
 *  @param row 删除第几行
 */
-(void)removeClockListData:(NSInteger)row;
/**
 *  更新数据
 *
 *  @param row        更新第几行
 *  @param clockModel 更新的数据
 */
-(void)updateClockListDataWithRow:(NSInteger)index andModel:(YRClockModel *)clockModel;
//更新clockData
-(void)updateClockDataArray;

@end
