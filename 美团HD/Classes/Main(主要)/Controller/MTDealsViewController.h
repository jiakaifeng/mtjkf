//
//  MTDealsViewController.h
//  美团HD
//
//  Created by apple on 14/11/26.
//  Copyright (c) 2014年 heima. All rights reserved.
//  团购列表控制器(父类)

#import <UIKit/UIKit.h>

@interface MTDealsViewController : UICollectionViewController
/**
 *  设置请求参数:交给子类去实现
 */
- (void)setupParams:(NSMutableDictionary *)params;

@end
