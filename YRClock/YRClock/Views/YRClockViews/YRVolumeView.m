//
//  YRVolumeView.m
//  YRClock
//
//  Created by mac on 17/4/7.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "YRVolumeView.h"

@implementation YRVolumeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    UILabel *lineLb = ({
        UILabel *view = [[UILabel alloc]init];
        [self addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self).multipliedBy(0.9);
            make.height.mas_equalTo(1);
        }];
        view.backgroundColor = kGrayColor(224, 1);
        view;
    });
    UILabel *title = ({
        UILabel *view = [[UILabel alloc]init];
        [self addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(kGetViewWidth(20));
        }];
        view.font = [UIFont systemFontOfSize:kFont(17)];
        view.text = @"音量";
        view;
    });
    
    self.slider = ({
        UISlider *view = [[UISlider alloc]init];
        [self addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self).offset(kGetViewWidth(-18));
            make.left.mas_equalTo(title.mas_right).offset(kGetViewWidth(25));
            make.height.mas_equalTo(2);
        }];
        view;
    });
}

@end
