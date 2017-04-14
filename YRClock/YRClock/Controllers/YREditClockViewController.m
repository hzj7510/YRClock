//
//  YREditClockViewController.m
//  YRClock
//
//  Created by mac on 17/4/6.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "YREditClockViewController.h"
#import "YRClockModel.h"
#import "YRSelectView.h"
#import "YRVolumeView.h"

@interface YREditClockViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
//时间选择
@property(nonatomic,strong)UIDatePicker *datePicker;
//重复
@property(nonatomic,strong)YRSelectView *repeatView;
//铃声
@property(nonatomic,strong)YRSelectView *ringView;
//音量
@property(nonatomic,strong)YRVolumeView *volumeView;
//提醒
@property(nonatomic,strong)YRSelectView *remindView;
//名称
@property(nonatomic,strong)YRSelectView *nameView;
//第几个闹钟
@property(nonatomic,assign)NSInteger clockIndex;
//viewmodel
@property(nonatomic,strong)YRClockViewModel *viewModel;
//弹出框
@property(nonatomic,strong)UITableView *pushTableView;
//弹出框数组
@property(nonatomic,strong)NSArray *pushArray;
//弹出框view
@property(nonatomic,strong)UIView *pushView;
//push界面判断
@property(nonatomic,assign)BOOL isPushRepeat;
@end

@implementation YREditClockViewController

-(instancetype)initWithIndex:(NSInteger)clockIndex{
    self = [super init];
    if (self) {
        self.viewModel = [[YRClockViewModel alloc]init];
        [self.viewModel getClockDataWithIndex:clockIndex];
        self.clockIndex = clockIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self setupNaviController];
    [self setupViews];
    [self bindingViewModel];

}

#pragma mark - 数据绑定
-(void)bindingViewModel{

    [self.viewModel getClockDataWithIndex:self.clockIndex];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *pickerDate = [formatter dateFromString:self.viewModel.clockTime];
    self.datePicker.date = pickerDate;
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    
    [[self.datePicker rac_newDateChannelWithNilValue:pickerDate]subscribeNext:^(NSDate *x) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm"];
        
        self.viewModel.clockTime = [formatter stringFromDate:x];
    }];
    
    
    RAC(self.ringView.contentLb, text) = RACObserve(self.viewModel, clockRing);
    RAC(self.repeatView.contentLb ,text) = RACObserve(self.viewModel, clockType);
    RAC(self.remindView.contentLb, text) = RACObserve(self.viewModel, clockRemindType);
    RAC(self.nameView.contentLb, text) = RACObserve(self.viewModel, clockName);
    RAC(self.volumeView.slider, value) = RACObserve(self.viewModel, clockVolume);
}
#pragma mark - 视图搭建
-(void)setupNaviController{
    self.navigationItem.title = @"编辑闹钟";
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick:)];
    
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick:)];
    
    [self.navigationItem setRightBarButtonItem:saveBtn];
    [self.navigationItem setLeftBarButtonItem:backBtn];
}

-(void)setupViews{
    UIScrollView *allScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:allScrollView];
    @weakify(self);
    [allScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.mas_equalTo(self.view);
    }];
    
    UIView *container = [[UIView alloc]init];
    [allScrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(allScrollView);
        make.width.mas_equalTo(allScrollView);
    }];

    self.datePicker = [[UIDatePicker alloc]init];
    [container addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.mas_equalTo(container);
        make.height.mas_equalTo(self.view).multipliedBy(0.6);
    }];
    
    self.repeatView = ({
        YRSelectView *view = [[YRSelectView alloc]initWithFrame:CGRectZero andType:SELECTEDTYPEREPEAT];
        [container addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.datePicker.mas_bottom);
            make.left.right.mas_equalTo(container);
            make.height.mas_equalTo(kGetViewHeight(66));
        }];
        [[view.btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self);
            self.isPushRepeat = YES;
            self.pushArray = @[@"仅一次",@"周一到周五",@"每天",@"法定工作日"];
            [self pushViewAppearAnimation];
        }];
        view;
    });
    
    self.ringView = ({
        YRSelectView *view = [[YRSelectView alloc]initWithFrame:CGRectZero andType:SELECTEDTYPERING];
        [container addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.repeatView.mas_bottom);
            make.left.right.mas_equalTo(container);
            make.height.mas_equalTo(kGetViewHeight(66));
        }];
        [[view.btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            NSLog(@"铃声");
        }];
        view;
    });
    
    self.volumeView = ({
        YRVolumeView *view = [[YRVolumeView alloc]initWithFrame:CGRectZero];
        [container addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.ringView.mas_bottom);
            make.left.right.mas_equalTo(container);
            make.height.mas_equalTo(kGetViewHeight(66));
        }];
        view;
    });
    
    self.remindView = ({
        YRSelectView *view = [[YRSelectView alloc]initWithFrame:CGRectZero andType:SELECTEDTYPEREMIND];
        [container addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.volumeView.mas_bottom);
            make.left.right.mas_equalTo(container);
            make.height.mas_equalTo(kGetViewHeight(66));
        }];
        [[view.btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self);
            self.isPushRepeat = NO;
            self.pushArray = @[@"关闭",@"5分钟",@"10分钟",@"15分钟",@"30分钟"];
            [self pushViewAppearAnimation];
        }];
        view;
    });
    
    self.nameView = ({
        YRSelectView *view = [[YRSelectView alloc]initWithFrame:CGRectZero andType:SELECTEDTYPENAME];
        [container addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.remindView.mas_bottom);
            make.left.right.mas_equalTo(container);
            make.height.mas_equalTo(kGetViewHeight(66));
        }];
        [[view.btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"闹钟名称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"名称";
            }];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.viewModel.clockName = [alertController.textFields[0] text];
            }];
            [alertController addAction:confirmAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        view;
    });
    
    UILabel *lineLb = ({
        UILabel *view = [[UILabel alloc]init];
        [container addSubview:view];
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.nameView.mas_bottom);
            make.centerX.mas_equalTo(container);
            make.width.mas_equalTo(self.view).multipliedBy(0.9);
            make.height.mas_equalTo(1);
        }];
        view.backgroundColor = kGrayColor(224, 1);
        view;
    });
    //如果为-1说明是新建，不需要删除按钮
    if (self.clockIndex != -1) {
        UIButton *btn = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            [container addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lineLb.mas_bottom);
                make.height.mas_equalTo(kGetViewHeight(50));
                make.width.mas_equalTo(container);
                make.left.mas_equalTo(container);
            }];
            [view setTitle:@"删除" forState:UIControlStateNormal];
            [view setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [[view rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                
                @weakify(self);
                UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    @strongify(self);
                    [self.viewModel.deleteCommand execute:@(self.clockIndex)];
//                    [self.viewModel.update_signal subscribeNext:^(id x) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                        });
//                    }];
                }];
                
                UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除此闹钟嘛？" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:actionSure];
                [alertController addAction:actionCancel];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }];
            view;
        });
        
        UILabel *bottomLineLb = ({
            UILabel *view = [[UILabel alloc]init];
            [container addSubview:view];
            @weakify(self);
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.mas_equalTo(btn.mas_bottom);
                make.centerX.mas_equalTo(container);
                make.width.mas_equalTo(self.view).multipliedBy(0.9);
                make.height.mas_equalTo(1);
            }];
            view.backgroundColor = kGrayColor(224, 1);
            view;
        });
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bottomLineLb);
        }];
        
        return;
    }
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lineLb);
    }];
    
}
#pragma mark - 事件处理
-(void)cancelClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveClick:(id)sender{
    [self.viewModel.saveCommand execute:@(self.clockIndex)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - animation

-(void)pushViewAppearAnimation{
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self);
        self.pushView.hidden = NO;
        self.pushTableView.hidden = NO;
    } completion:^(BOOL finished) {
        [self.pushTableView reloadData];
    }];
}

-(void)pushViewDisappearAnimation{
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self);
        self.pushTableView.hidden = YES;
        self.pushView.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - tableViewDelegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pushArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.pushArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isPushRepeat) {
        self.viewModel.clockModelType = indexPath.row;
        self.viewModel.clockType = self.pushArray[indexPath.row];
    }else{
        self.viewModel.clockModelRemindType = indexPath.row;
        self.viewModel.clockRemindType = self.pushArray[indexPath.row];
    }
    [self pushViewDisappearAnimation];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kScreenWidth, 30);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.backgroundColor =[UIColor redColor];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self pushViewDisappearAnimation];
    }];
    return btn;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30.0;
}

#pragma mark - 懒加载
- (UITableView *)pushTableView {
    @weakify(self);
	if(_pushTableView == nil) {
        @strongify(self);
		_pushTableView = [[UITableView alloc] init];
        _pushTableView.delegate = self;
        _pushTableView.dataSource = self;
        [_pushTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:self.pushTableView];
        _pushTableView.hidden = YES;
        _pushTableView.tableFooterView = [UIView new];
        [self.pushTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view).multipliedBy(0.4);
            make.height.mas_equalTo(self.view).multipliedBy(0.4);
        }];
	}
	return _pushTableView;
}

- (NSArray *)pushArray {
	if(_pushArray == nil) {
		_pushArray = [[NSArray alloc] init];
	}
	return _pushArray;
}

- (UIView *)pushView {
    @weakify(self);
	if(_pushView == nil) {
        @strongify(self);
		_pushView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _pushView.backgroundColor = kRGB(80, 80, 80, 0.5);
        _pushView.hidden = YES;
        [self.view addSubview:_pushView];
        
	}
	return _pushView;
}


@end
