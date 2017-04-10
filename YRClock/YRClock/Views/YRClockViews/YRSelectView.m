//
//  YRSelectView.m
//  YRClock
//
//  Created by mac on 17/4/7.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "YRSelectView.h"

@implementation YRSelectView

-(instancetype)initWithFrame:(CGRect)frame andType:(SELECTEDTYPE)type{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewWithType:type];
    }
    return self;
}

-(void)setupViewWithType:(SELECTEDTYPE)type{
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
    UILabel *titleLb = ({
        UILabel *view = [[UILabel alloc]init];
        [self addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self).offset(kGetViewHeight(12));
            make.left.mas_equalTo(self).offset(kGetViewWidth(20));
        }];
        view.font = [UIFont systemFontOfSize:kFont(17)];
        view;
    });

    self.contentLb = ({
        UILabel *view = [[UILabel alloc]init];
        [self addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.mas_equalTo(self).offset(kGetViewHeight(-12));
            make.left.mas_equalTo(self).offset(kGetViewWidth(20));
        }];
        view.font = [UIFont systemFontOfSize:kFont(13)];
        view.textColor = kGrayColor(147, 1);
        view;
    });
    
    UIImageView *imgView = ({
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:type == SELECTEDTYPERING ?@"success":@"info@3x"]];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(kGetViewWidth(-22));
            make.width.mas_equalTo(kGetViewWidth(10));
            make.height.mas_equalTo(kGetViewHeight(14));
        }];
        view;
    });
    
    self.btn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        view;
    });
    
    switch (type) {
        case SELECTEDTYPENAME:
            titleLb.text = @"标题";
            break;
        case SELECTEDTYPERING:
            titleLb.text = @"铃声";
            break;
        case SELECTEDTYPEREMIND:
            titleLb.text = @"稍后提醒";
            break;
        case SELECTEDTYPEREPEAT:
            titleLb.text = @"重复";
            break;
        default:
            break;
    }
}

@end
