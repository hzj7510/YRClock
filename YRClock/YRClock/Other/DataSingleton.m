//
//  DataSingleton.m
//  YRClock
//
//  Created by mac on 17/4/7.
//  Copyright © 2017年 x5. All rights reserved.
//

#import "DataSingleton.h"
#import "YRClockModel.h"

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
    }
    return self;
}

//添加数据
-(void)insertClockListData:(YRClockModel *)clockModel{
    
    NSDictionary *plistDic = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath];
    
    //如果为空说明没有plist文件，这里要先创建文件
    if (plistDic == nil) {
        plistDic = [[NSDictionary alloc] initWithObjects:@[[NSMutableArray array]] forKeys:@[@"data"]];
    }
    
    [[plistDic objectForKey:@"data"] insertObject:[self setValueWithMdoel:clockModel] atIndex:self.dataArray.count];
    
    NSError *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDic format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    NSLog(@"%@",error);
    if(plistData){
        [plistData writeToFile:self.plistPath atomically:YES];
        NSLog(@"Data saved sucessfully");
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
    }
    else{
        NSLog(@"Data not saved");
    }
    NSLog(@"删除成功");
}
//更新数据
-(void)updateClockListDataWithRow:(NSInteger)index andModel:(YRClockModel *)clockModel{
    NSDictionary *plistDic = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath];
    
    [[plistDic objectForKey:@"data"] removeObjectAtIndex:index];
    
    [[plistDic objectForKey:@"data"] insertObject:[self setValueWithMdoel:clockModel] atIndex:index];
    
    [plistDic writeToFile:self.plistPath atomically:YES];
    NSLog(@"更新成功");
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
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:self.plistPath];
    NSArray *dataArr = dict[@"data"];
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
//获取地址
-(NSString *)getFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"ClockList.plist"];
    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
//    {
//        plistPath = [[NSBundle mainBundle] pathForResource:@"ClockList" ofType:@"plist"];
//    }
    NSLog(@"%@",plistPath);
    return plistPath;
}


- (NSArray *)dataArray {
    _dataArray = [self getClockListData];
    return _dataArray;
}
@end
