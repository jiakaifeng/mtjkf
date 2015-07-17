//
//  mtdealtools.h
//  美团HD
//
//  Created by jiakaifeng on 15/7/9.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "MTDeal.h"

@interface mtdealtools : NSObject

+(NSArray *)coletiondeal:(int)page;
+(NSArray *)recentdeal:(int)page;
+(void)addcolletiondeal:(MTDeal *)deal;
+(void)removecolletiondeal:(MTDeal *)deal;

@end
