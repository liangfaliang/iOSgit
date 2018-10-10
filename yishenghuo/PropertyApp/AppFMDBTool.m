//
//  AppFMDBTool.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "AppFMDBTool.h"
#import "FMDB.h"

static FMDatabase *_db;
@implementation AppFMDBTool

SYNTHESIZE_SINGLETON_FOR_CLASS(AppFMDBTool);

-(id)init{
    if (self = [super init]) {
        [self  initialize];
    }
    return self;
}
-(void)initialize
{
    // 1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"data.sqlite"];
    
    NSLog(@"%@",filename);
    
    // 2.得到数据库
    _db = [FMDatabase databaseWithPath:filename];
    
    // 3.打开数据库
    if ([_db open]) {
        // 4.创表
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_data (id integer PRIMARY KEY AUTOINCREMENT, data_dict blob NOT NULL , data_type text NOT NULL, data_time text NOT NULL);"];
        if (result) {
            NSLog(@"create success!");
        } else {
            NSLog(@"create fail");
        }
    }
}

/**
 *  缓存网络请求数据
 *
 *  @param dataArray 请求的网络数据（数组）
 *  @param dataType  数据类型（）
 */
-(void)saveDataArray:(NSArray *)dataArray dataType:(NSString *)dataType
{
    
    [self deleteDataWithDataType:dataType];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    for (NSDictionary *dict in dataArray)  {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [_db executeUpdate:@"insert into t_data (data_dict,data_type,data_time) VALUES (?,?,?);",data,dataType,timeSp];
    }
}


-(void)deleteDataWithDataType:(NSString *)dataType
{
    
    
    //    NSString *sql_select = @"select * from t_data where data_type = ?";
    //    //1.2执行查询语句
    //    FMResultSet *rs = [_db executeQuery:sql_select,dataType];
    //    //2判断是否存在
    //    BOOL isE = NO;
    //    while ([rs next]) {
    //        isE = YES;
    //    }
    //
    //    if (isE == YES){
    [_db executeUpdate:@"delete  from t_data where data_type = ?;",dataType];
    //    }
    
    
}


/**
 *  从沙盒获取数据
 *
 *  @param param 数据类型
 *
 *  @return 返回从沙盒获取的数据
 */
- (NSArray *)cachedDataWithDataType:(NSString *)dataType
{
    //创建数组缓存数据
    NSMutableArray *dataArray = [NSMutableArray array];
    
    FMResultSet *resultSet = nil;
    
    resultSet = [_db executeQuery:@"SELECT * from t_data where data_type = ?;",dataType];
    
    while ([resultSet next]) {
        NSData *data = [resultSet objectForColumnName:@"data_dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [dataArray addObject:dict];
    }
    return dataArray;
}

- (NSString *)timeDataWithDataType:(NSString *)dataType
{
    //创建数组缓存数据
    NSString *datatime = [NSString string];
    
    FMResultSet *resultSet = nil;
    
    resultSet = [_db executeQuery:@"SELECT * from t_data where data_type = ?;",dataType];
    
    while ([resultSet next]) {
        datatime = [resultSet objectForColumnName:@"data_time"];
        
        
    }
    NSLog(@"datatime:%@",datatime);
    return datatime;
}


@end
