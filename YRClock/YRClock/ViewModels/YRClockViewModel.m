//
//  YRClockViewModel.m
//  YRClock
//
//  Created by mac on 17/4/8.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "YRClockViewModel.h"

@implementation YRClockViewModel

-(void)getClockDataWithIndex:(NSInteger)index{
    [super getClockDataWithIndex:index];
    
    if (index != -1) {
        self.clockRing = self.model.clockRing;
        switch (self.model.clockRemindType) {
            case CLOCKREMINDTYPENONE:
                self.clockRemindType = @"关闭";
                break;
            case CLOCKREMINDTYPEFIVE:
                self.clockRemindType = @"5分钟";
                break;
            case CLOCKREMINDTYPETEN:
                self.clockRemindType = @"10分钟";
                break;
            case CLOCKREMINDTYPEFIFTEEN:
                self.clockRemindType = @"15分钟";
                break;
            case CLOCKREMINDTYPETHIRTY:
                self.clockRemindType = @"30分钟";
                break;
                
            default:
                break;
        }
        
        self.clockVolume = self.model.clockVolume;
        
       
        
        self.deleteCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *input) {
            @weakify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [self.data removeClockListData:input.integerValue];
                
                NSLog(@"%@",input);
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }else{
        self.clockRing = @"lalala";
        self.clockRemindType = @"5分钟";
        self.clockVolume = 10;
    }
    self.saveCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            YRClockModel *model = [[YRClockModel alloc]init];
            model.clockName = self.clockName;
            model.clockVolume = self.clockVolume;
            model.clockRing = self.clockRing;
            model.clockType = self.clockModelType;
            model.clockRemindType = self.clockModelRemindType;
            model.clockTime = self.clockTime;
            model.isOpen = YES;
            @weakify(self);
            if (input.integerValue != -1) {
                @strongify(self);
                [self.data updateClockListDataWithRow:index andModel:model];
                NSLog(@"%@",input);
            }else{
                @strongify(self);
                [self.data insertClockListData:model];
            }
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
}

-(void)setOpenSignal:(RACSignal *)openSignal{
    _openSignal = openSignal;
    @weakify(self);
    [openSignal subscribeNext:^(RACTuple *x) {
        @strongify(self);
        NSNumber *index = x.second;
        NSNumber *on = x.first;
        YRClockModel *model = self.data.dataArray[index.integerValue];
        model.isOpen = on.boolValue;
        [self.data updateClockListDataWithRow:index.integerValue andModel:model];
        
    }];
}



-(void)getClockSimpleDataWithIndex:(NSInteger)index{
    [super getClockDataWithIndex:index];
    
    self.isOpen = self.model.isOpen;
    
    self.color = self.model.isOpen ? kGrayColor(184, 1):kGrayColor(232, 1);
    
    self.timeColor = self.model.isOpen ? kGrayColor(0, 1):kGrayColor(232, 1);
}

@end
