//
//  Enums.h
//  YRClock
//
//  Created by mac on 17/4/7.
//  Copyright © 2017年 x5. All rights reserved.
//

#ifndef Enums_h
#define Enums_h

/**
 闹钟重复类型
 */
typedef enum : NSUInteger {
    /**
     *  仅一次
     */
    CLOCKTYPEJUSTONETIME,
    /**
     *  工作日(周一到周五)
     */
    CLOCKTYPEWORKDAYS,
    /**
     *  每天
     */
    CLOCKTYPEEVERYDAYS,
    /**
     *  法定节假日
     */
    CLOCKTYPEHOLIDAYS,
} CLOCKTYPE;

/**
 闹钟稍后提醒类型
 */
typedef enum : NSUInteger {
    /**
     *  关闭
     */
    CLOCKREMINDTYPENONE,
    /**
     *  五分钟
     */
    CLOCKREMINDTYPEFIVE,
    /**
     *  十分钟
     */
    CLOCKREMINDTYPETEN,
    /**
     *  十五分钟
     */
    CLOCKREMINDTYPEFIFTEEN,
    /**
     *  三十分钟
     */
    CLOCKREMINDTYPETHIRTY,
} CLOCKREMINDTYPE;

#endif /* Enums_h */
