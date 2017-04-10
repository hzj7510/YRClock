//
//  YRSelectView.h
//  YRClock
//
//  Created by mac on 17/4/7.
//  Copyright © 2017年 x5. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 创建view时,区分创建类型
 */
typedef enum : NSUInteger {
    /**
     *  重复
     */
    SELECTEDTYPEREPEAT,
    /**
     *  铃声
     */
    SELECTEDTYPERING,
    /**
     *  提醒
     */
    SELECTEDTYPEREMIND,
    /**
     *  名称
     */
    SELECTEDTYPENAME,
} SELECTEDTYPE;

@interface YRSelectView : UIView
-(instancetype)initWithFrame:(CGRect)frame andType:(SELECTEDTYPE)type;

//显示选择内容lb
@property(nonatomic,strong)UILabel *contentLb;
@property(nonatomic,strong)UIButton *btn;
@end
