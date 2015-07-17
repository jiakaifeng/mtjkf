//
//  mtdealtools.m
//  美团HD
//
//  Created by jiakaifeng on 15/7/9.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "mtdealtools.h"
#import "MTDeal.h"
#import "FMDB.h"
@implementation mtdealtools
static FMDatabase *_db;
+(void)initialize{
    FMDatabase *_db=[[FMDatabase alloc]init];
    NSString * file=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject ]stringByAppendingString:@"deal.sqlite"];
    _db=[FMDatabase databaseWithPath:file];
    if (![_db open])return;
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_colletion_deal(id integer PRIMARY KEY,deal blob NOT NULL,deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY,deal blob NOT NULL,deal_id text NOT NULL);"];
  
}



+(NSArray *)coletiondeal:(int)page{


}
+(NSArray *)recentdeal:(int)page{

}
+(void)addcolletiondeal:(MTDeal *)deal{
    
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:deal];
    [ _db executeUpdate:@"INSERT INTO t_colletion_deal(deal,deal_id) VALUES(%@, %@);",data,deal.deal_id];


}
+(void)removecolletiondeal:(MTDeal *)deal{
   [ _db executeUpdate:@"DELETE FROM t_colletion_deal WHERE deal_id=%@;",deal.deal_id];
    

}

@end
