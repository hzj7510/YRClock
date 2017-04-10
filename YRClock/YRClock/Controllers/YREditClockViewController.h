//
//  YREditClockViewController.h
//  YRClock
//
//  Created by mac on 17/4/6.
//  Copyright © 2017年 x5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRClockViewModel.h"

@interface YREditClockViewController : UIViewController
-(instancetype)initWithIndex:(NSInteger)clockIndex andViewModel:(YRClockViewModel *)viewModel;

@end
