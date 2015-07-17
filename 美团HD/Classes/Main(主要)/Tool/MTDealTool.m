//
//  MTDealTool.m
//  美团HD
//
//  Created by apple on 14/11/27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTDealTool.h"
#import "FMDB.h"
#import "MTDeal.h"

@implementation MTDealTool

static FMDatabase *_db;

+ (void)initialize
{

    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    
}

+ (NSArray *)collectDeals:(int)page
{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        MTDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}
+ (NSArray *)recentDeals:(int)page{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_recent_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        MTDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;

}
+ (void)addrecentdeal:(MTDeal *)deal{
 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
FMResultSet *rs = [_db executeQuery:@"SELECT * FROM t_recent_deal WHERE deal_id = ?",deal.deal_id];
    if([rs next])
    {
        [_db executeUpdateWithFormat:@"DELETE FROM t_recent_deal WHERE deal_id = %@;", deal.deal_id];
        [_db executeUpdateWithFormat:@"INSERT INTO t_recent_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
        
    }else{
    

        [_db executeUpdateWithFormat:@"INSERT INTO t_recent_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
    }
    //设置通知,当调用次方法时通知colleticonview 刷新页面。
    

}
/*

+ (void)addrecentdeal:(MTDeal *)deal{
  
    FMResultSet *rs=[_db executeQuery:@"SELECT * FROM t_recent_deal"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_recent_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id]
    
    ;
 
}*/

+ (void)addCollectDeal:(MTDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
}

+ (void)removeCollectDeal:(MTDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
}

+ (BOOL)isCollected:(MTDeal *)deal{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
//#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}

+ (int)collectDealsCount
{    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}
+ (int)recentDealsCount{

    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_recent_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];

}


@end
