//
//  YRAllClockViewController.m
//  YRClock
//
//  Created by mac on 17/4/6.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "YRAllClockViewController.h"
#import "YRAllClockTableViewCell.h"
#import "YREditClockViewController.h"
#import "YRClockViewModel.h"
#import "YRClockModel.h"

static NSString *CellIdentify = @"cellIdentifiy";

@interface YRAllClockViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
//tableview
@property(nonatomic,strong)UITableView *allClockTableView;
//viewmodel
@property(nonatomic,strong)YRClockViewModel *viewModel;
//时间信号量
@property(nonatomic,strong)RACSignal *timeSignal;
@end

@implementation YRAllClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置view
    [self setupView];
    NSLog(@"运行开始");
    [self bindingViewModel];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.allClockTableView reloadData];
}

-(void)bindingViewModel{
    self.viewModel = [[YRClockViewModel alloc]init];
    
    [self.allClockTableView reloadData];
    
    NSArray *clockArray = @[@"10:30", @"10:33"];
    
    self.timeSignal = [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] filter:^BOOL(NSDate *value) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"ss"];
        return [formatter stringFromDate:value].integerValue == 0;
    }] map:^NSString *(NSDate * date) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:date];
    }];
}

-(NSString *)getStatusTimeWithDate:(NSString *)date{
    return [NSString stringWithFormat:@"哈哈"];
}

-(void)setupView{
    [self.view addSubview:self.allClockTableView];
    @weakify(self);
    [self.allClockTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kGetViewHeight(20));
    }];
    [self.allClockTableView registerClass:[YRAllClockTableViewCell class] forCellReuseIdentifier:CellIdentify];
    self.allClockTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.allClockTableView.tableFooterView = [UIView new];
    
    UIButton *createClockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:createClockBtn];
    [createClockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kGetViewHeight(50));
        make.size.mas_equalTo(CGSizeMake(kGetViewWidth(50), kGetViewWidth(50)));
    }];
    createClockBtn.backgroundColor = [UIColor redColor];
    createClockBtn.layer.cornerRadius = kGetViewWidth(25);
    createClockBtn.layer.masksToBounds = YES;
    [[createClockBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self presentToEditViewControllerWithIndex:-1];
    }];
    RAC(createClockBtn,hidden) = [RACObserve(self.allClockTableView, contentOffset) map:^id(NSValue *value) {
        CGPoint p = [value CGPointValue];
        return @(p.y != 0);
    }];
}

#pragma mark - tableViewDelegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.data.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRAllClockTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YRAllClockTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify];
        [self.viewModel getClockSimpleDataWithIndex:indexPath.row];
        cell.timeLb.text = self.viewModel.clockTime;
        cell.typeLb.text = self.viewModel.clockType;
        cell.clockNameLb.text = self.viewModel.clockName;
        cell.statusSwitch.on = self.viewModel.isOpen;
        cell.timeLb.textColor = self.viewModel.timeColor;
        cell.typeLb.textColor = self.viewModel.color;
        cell.statusLb.textColor = self.viewModel.color;
        cell.clockNameLb.textColor = self.viewModel.color;
       
//        [cell.switchSubject subscribeNext:^(NSNumber *x) {
//            DataSingleton *data = [DataSingleton sharedInstance];
//            YRClockModel *model = data.dataArray[indexPath.row];
//            model.isOpen = x.boolValue;
//            [data updateClockListDataWithRow:indexPath.row andModel:model];
//        }];
        
        self.viewModel.openSignal = [cell.switchSubject map:^id(NSNumber *value) {
            return [RACTuple tupleWithObjects:value, @(indexPath.row), nil];
        }];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kGetViewHeight(120);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self presentToEditViewControllerWithIndex:indexPath.row];
}

/**
 *  跳转到编辑界面
 *
 *  @param index 这里用index来标记是否为新建,如果是新建闹钟index为-1
 */
-(void)presentToEditViewControllerWithIndex:(NSInteger)index{
    YREditClockViewController *editClockViewController = [[YREditClockViewController alloc]initWithIndex:index andViewModel:self.viewModel];
    
    UINavigationController *naviController = [[UINavigationController alloc]initWithRootViewController:editClockViewController];
    [self presentViewController:naviController animated:YES completion:nil];
}

#pragma mark - 懒加载

- (UITableView *)allClockTableView {
	if(_allClockTableView == nil) {
		_allClockTableView = [[UITableView alloc] init];
        _allClockTableView.delegate = self;
        _allClockTableView.dataSource = self;
	}
	return _allClockTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
