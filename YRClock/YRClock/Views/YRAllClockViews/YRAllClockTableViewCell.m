//
//  YRAllClockTableViewCell.m
//  YRClock
//
//  Created by mac on 17/4/6.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "YRAllClockTableViewCell.h"

@interface YRAllClockTableViewCell ()
//小时
@property(nonatomic,assign)NSInteger alarmClockHour;
//分钟
@property(nonatomic,assign)NSInteger alarmClockMinute;
//那种是否打开
@property(nonatomic,assign)BOOL isOpen;
//循环时间
@property(nonatomic,assign)NSInteger loopTime;
@end

@implementation YRAllClockTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isOpen = YES;
        self.alarmClockHour = 15;
        self.alarmClockMinute = 8;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    //时间lb
    self.timeLb = ({
        UILabel *view = [UILabel new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kGetViewHeight(20));
            make.left.mas_equalTo(kGetViewWidth(22));
        }];
        view.font = [UIFont systemFontOfSize:kFont(25)];
        view.text = @"10:21";
        view;
    });
    //名称lb
    self.clockNameLb = ({
        UILabel *view = [UILabel new];
        [self addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.timeLb.mas_bottom).offset(kGetViewHeight(15));
            make.left.mas_equalTo(kGetViewWidth(22));
        }];
        view.font = [UIFont systemFontOfSize:kFont(14)];
        view.textColor = kGrayColor(184, 1);
        view.text = @"10:21";
        view;
    });
    //类型lb
    self.typeLb = ({
        UILabel *view = [UILabel new];
        [self addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.clockNameLb.mas_bottom).offset(kGetViewHeight(4));
            make.left.mas_equalTo(kGetViewWidth(22));
        }];
        view.font = [UIFont systemFontOfSize:kFont(14)];
        view.textColor = kGrayColor(184, 1);
        view.text = @"10:21";
        view;
    });
    //状态lb
    self.statusLb = ({
        UILabel *view = [UILabel new];
        [self addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.typeLb);
            make.left.mas_equalTo(self.typeLb.mas_right).offset(kGetViewWidth(15));
        }];
        view.font = [UIFont systemFontOfSize:kFont(14)];
        view.textColor = kGrayColor(184, 1);
//        view.text = [self getStatusTimeWithDate:[NSDate date]];
        view;
    });
    //闹钟开关
    self.statusSwitch = ({
        UISwitch *view = [[UISwitch alloc]init];
        [self addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.mas_equalTo(self.timeLb);
            make.right.mas_equalTo(self).offset(kGetViewWidth(-20));
            make.width.mas_equalTo(kGetViewWidth(44));
            make.height.mas_equalTo(kGetViewHeight(22));
        }];
        view.onTintColor = kRGB(252, 94, 34, 1);
        view;
    });
    
    //通过RAC来绑定
    RAC(self.clockNameLb,textColor) = [self switchOnColorSignal];
    RAC(self.typeLb,textColor) = [self switchOnColorSignal];
    RAC(self.statusLb,textColor) = [self switchOnColorSignal];
    RAC(self.timeLb,textColor) = [self switchOnTimeLbColorSignal];
    
}

//返回触发switch后on状态改变来改变Label颜色
-(RACSignal *)switchOnColorSignal{
    @weakify(self);
    return [[self.statusSwitch rac_signalForControlEvents:UIControlEventValueChanged]map:^id(UISwitch *value) {
        @strongify(self);
        self.isOpen = value.on;
        return value.on ? kGrayColor(184, 1) : kGrayColor(232, 1);
    }];
}
//返回触发switch后on状态改变来改变timeLabel颜色
-(RACSignal *)switchOnTimeLbColorSignal{
    return [[self.statusSwitch rac_signalForControlEvents:UIControlEventValueChanged]map:^id(UISwitch *value) {
        [self.switchSubject sendNext:@(value.on)];
        
        return value.on ? kGrayColor(0, 1) : kGrayColor(232, 1);
    }];
}


- (RACSubject *)switchSubject {
    if(_switchSubject == nil) {
        _switchSubject = [[RACSubject alloc] init];
    }
    return _switchSubject;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
