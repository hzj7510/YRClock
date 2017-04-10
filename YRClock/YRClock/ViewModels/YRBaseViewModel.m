//
//  YRBaseViewModel.m
//  YRClock
//
//  Created by mac on 17/4/8.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "YRBaseViewModel.h"


@interface YRBaseViewModel ()

@end

@implementation YRBaseViewModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.data = [DataSingleton sharedInstance];
    }
    return self;
}

-(void)getClockDataWithIndex:(NSInteger)index{
    if (index != -1) {
        self.model = self.data.dataArray[index];
        
        self.clockName = self.model.clockName;
        switch (self.model.clockType) {
            case CLOCKTYPEHOLIDAYS:
                self.clockType = @"法定节假日";
                break;
            case CLOCKTYPEWORKDAYS:
                self.clockType = @"周一到周五";
                break;
            case CLOCKTYPEEVERYDAYS:
                self.clockType = @"每天";
                break;
            case CLOCKTYPEJUSTONETIME:
                self.clockType = @"仅一次";
                break;
            default:
                break;
        }
        
        self.clockTime = self.model.clockTime;
    }else{
        self.clockName = @"闹钟";
        self.clockType = @"仅一次";
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm"];
        self.clockTime = [formatter stringFromDate:[NSDate date]];
    }
}

@end
