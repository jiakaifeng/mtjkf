//
//  MTDealCell.h
//  黑团HD
//
//  Created by apple on 14-8-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTDeal, MTDealCell;
@protocol mtdealcell <NSObject>

@optional
-(void)dealcellcheckingDidchange:(MTDealCell *)cell;

@end


@interface MTDealCell : UICollectionViewCell
@property (nonatomic, strong) MTDeal *deal;
@property(nonatomic,strong)id<mtdealcell>delegate;

@end
