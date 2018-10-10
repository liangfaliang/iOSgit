//
//  AppFMDBManager.m
//  shop
//
//  Created by 梁法亮 on 16/5/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "AppFMDBManager.h"
#import "FMDB.h"

static FMDatabase *_db;
@interface AppFMDBManager(){

    FMDatabaseQueue* queue;
}



@end

@implementation AppFMDBManager

SYNTHESIZE_SINGLETON_FOR_CLASS(AppFMDBManager);

-(id)init{
    if (self = [super init]) {
        [self  initialize];
    }
    return self;
}

-(FMDatabaseQueue *)getSharedDatabaseQueue {
     static FMDatabaseQueue *my_FMDatabaseQueue=nil;

  if (!my_FMDatabaseQueue) {
      NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
      NSString *filename = [doc stringByAppendingPathComponent:@"data.sqlite"];
        my_FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:filename];
     }
    return my_FMDatabaseQueue;
 }
-(void)initialize
{
    // 1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"data.sqlite"];
    
        NSLog(@"%@",filename);
    
    // 2.得到数据库
//    _db = [FMDatabase databaseWithPath:filename];
    queue = [self getSharedDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        // 3.打开数据库
//        _db = db;
        if ([db open]) {
            // 4.创表
            BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_data (id integer PRIMARY KEY AUTOINCREMENT, data_dict blob NOT NULL , data_type text NOT NULL, data_time text NOT NULL);"];
            if (result) {
                NSLog(@"create success!");
            } else {
                NSLog(@"create fail");
            }
        }
    }];
    

}

/**
 *  缓存网络请求数据
 *
 *  @param dataArray 请求的网络数据（数组）
 *  @param dataType  数据类型（）
 */
-(void)saveDataArray:(NSArray *)dataArray dataType:(NSString *)dataType
{

    NSMutableArray *temparr = [dataArray mutableCopy];
    [self deleteDataWithDataType:dataType];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);

    for (NSDictionary *dict in temparr)  {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        
        [queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"insert into t_data (data_dict,data_type,data_time) VALUES (?,?,?);",data,dataType,timeSp];
        }];
        
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
    [queue inDatabase:^(FMDatabase *db) {
       [db executeUpdate:@"delete  from t_data where data_type = ?;",dataType];
    }];
//      [_db executeUpdate:@"delete  from t_data where data_type = ?;",dataType];
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
   __block  NSMutableArray *dataArray = [NSMutableArray array];
//    LFLog(@"dataType:%@",dataType);
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = nil;
        
        resultSet = [db executeQuery:@"SELECT * from t_data where data_type = ?;",dataType];
        
        while ([resultSet next]) {
            NSData *data = [resultSet objectForColumnName:@"data_dict"];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [dataArray addObject:dict];
        }

//        LFLog(@"dataArray:%@",dataArray);
        
    }];
    
//    LFLog(@"dataArray:%@",dataArray);
        return dataArray;
}

- (NSString *)timeDataWithDataType:(NSString *)dataType
{
    //创建数组缓存数据
    __block NSString *datatime = [NSString string];

    
    LFLog(@"dataType:%@",dataType);
    [queue inDatabase:^(FMDatabase *db) {
//       NSString *datatime = [NSString string];
      FMResultSet * resultSet = [db executeQuery:@"SELECT * from t_data where data_type = ?;",dataType];
        
        while ([resultSet next]) {
            datatime = [resultSet objectForColumnName:@"data_time"];
            
            
        }
        
        
    }];
        NSLog(@"datatime:%@",datatime);
    return datatime;
}


@end
