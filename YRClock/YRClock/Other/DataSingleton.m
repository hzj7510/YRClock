//
//  DataSingleton.m
//  YRClock
//
//  Created by mac on 17/4/7.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "DataSingleton.h"
#import "YRClockModel.h"
#import "ClockSingleton.h"
#import "HolidaySingleton.h"

@interface DataSingleton ()
@property(nonatomic,strong)NSString *plistPath;
@end

@implementation DataSingleton

+ (instancetype)sharedInstance{
    static DataSingleton * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.plistPath = [self getFilePath];
        self.dataArray = [self getClockListData];
        [self updateClockDataArray];
    }
    return self;
}

//添加数据
-(void)insertClockListData:(YRClockModel *)clockModel{
    NSDictionary *plistDic = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath];
    //如果为空说明没有plist文件，这里要先创建文件
    if (plistDic == nil){
        plistDic = [[NSDictionary alloc] initWithObjects:@[[NSMutableArray array]] forKeys:@[@"data"]];
    }
    
    [[plistDic objectForKey:@"data"] insertObject:[self setValueWithMdoel:clockModel] atIndex:self.dataArray.count];
    
    NSError *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDic format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    NSLog(@"%@",error);
    if(plistData){
        [plistData writeToFile:self.plistPath atomically:YES];
        NSLog(@"Data saved sucessfully");
        self.dataArray = [self getClockListData];
        
        [self updateClockDataArray];
    }
    else{
        NSLog(@"Data not saved");
    }
}
//删除数据
-(void)removeClockListData:(NSInteger)row{
    NSDictionary *plistDic = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath];
    
    [[plistDic objectForKey:@"data"] removeObjectAtIndex:row];
    
    NSError *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDic format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    NSLog(@"%@",error);
    if(plistData){
        [plistData writeToFile:self.plistPath atomically:YES];
        NSLog(@"Data saved sucessfully");
        self.dataArray = [self getClockListData];
        
        [self updateClockDataArray];
    }
    else{
        NSLog(@"Data not saved");
    }
}
//更新数据
-(void)updateClockListDataWithRow:(NSInteger)index andModel:(YRClockModel *)clockModel{
    
    NSDictionary *plistDic = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath];
    
    [[plistDic objectForKey:@"data"] removeObjectAtIndex:index];
    
    [[plistDic objectForKey:@"data"] insertObject:[self setValueWithMdoel:clockModel] atIndex:index];
    
    NSError *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDic format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    NSLog(@"%@",error);
    if(plistData){
        [plistData writeToFile:self.plistPath atomically:YES];
        NSLog(@"Data saved sucessfully");
        self.dataArray = [self getClockListData];
        
        [self updateClockDataArray];
    }
    else{
        NSLog(@"Data not saved");
    }
}

//model转Dic处理
-(NSMutableDictionary *)setValueWithMdoel:(YRClockModel *)clockModel{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:clockModel.clockName forKey:@"clockName"];
    [dic setObject:clockModel.clockTime forKey:@"clockTime"];
    [dic setObject:@(clockModel.clockType) forKey:@"clockType"];
    [dic setObject:@(clockModel.isOpen) forKey:@"isOpen"];
    [dic setObject:clockModel.clockRing forKey:@"clockRing"];
    [dic setObject:@(clockModel.clockRemindType) forKey:@"clockRemindType"];
    [dic setObject:@(clockModel.clockVolume) forKey:@"clockVolume"];
    return dic;
}

//获取数据并转换成model返回
-(NSArray *)getClockListData{
    //如果不存在这个文件，返回一个空的数组即可
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.plistPath]){
        return [NSArray array];
    }else{
    
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath];
        
        NSArray *dataArr = dict[@"data"];
        //如果dataArr不为空说明数据存在，那么处理数据，如果不存在，则返回空的数组
        if (dataArr.count != 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in dataArr) {
                YRClockModel *clockModel = [[YRClockModel alloc]init];
                [clockModel setValuesForKeysWithDictionary:dic];
                [array addObject:clockModel];
            }
            return [array copy];
        }else{
            return [NSArray array];
        }
    }
}
//获取地址
-(NSString *)getFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"ClockList.plist"];
    NSLog(@"%@",plistPath);
    return plistPath;
}

- (NSArray *)dataArray {
    if(_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}


-(void)updateClockDataArray{
    NSDate * date  = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [calendar components: NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    for (int i = 0;i < self.dataArray.count; i++) {
        YRClockModel *model = self.dataArray[i];
        if (model.isOpen) {
            NSString *time;
            switch (model.clockType) {
                case CLOCKTYPEHOLIDAYS:{
                    NSString *todayDate = [NSString stringWithFormat:@"%ld-%ld",comps.month,comps.day];
                    if (![[HolidaySingleton sharedInstance].dataArray containsObject:todayDate]) {
                        time = model.clockTime;
                    }
                }
                    break;
                case CLOCKTYPEWORKDAYS:{
                    if (comps.weekday < 7 && comps.weekday > 1) {
                        time = model.clockTime;
                    }
                }
                    break;
                    
                case CLOCKTYPEEVERYDAYS:
                    time = model.clockTime;
                    break;
                case CLOCKTYPEJUSTONETIME:{
                    time = model.clockTime;
                }
                    break;
                default:
                    break;
            }
            if (time.length != 0) {
                [modelArray addObject:[RACTuple tupleWithObjects:time, @(i), @(model.clockType),nil]];
            }
        }
    }
    
    [ClockSingleton sharedInstance].dataArray = [modelArray copy];
    
}

@end
