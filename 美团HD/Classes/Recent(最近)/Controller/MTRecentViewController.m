//
//  MTRecentViewController.m
//  美团HD
//
//  Created by apple on 14/11/26.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTRecentViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MTConst.h"
#import "MTDealTool.h"
#import "MTDealCell.h"
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"
#import "MTDetailViewController.h"
#import "MJRefresh.h"
#import "MTDeal.h"



@interface MTRecentViewController ()
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) NSMutableArray *deals;
@property (nonatomic, weak) UIImageView *noDataView;
@property (nonatomic, assign) int currentPage;



@end

@implementation MTRecentViewController


static NSString * const reuseIdentifier = @"deal";

- (NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        self.backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backItem;
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近阅览";
    self.collectionView.backgroundColor = MTGlobalBg;
    // 左边的返回
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    [self loadMoreDeals];
    [self.collectionView reloadData];
    [MTNotificationCenter addObserver:self selector:@selector(RecentdealChange:) name:UPdatetheRecentDeal object:nil];
    
}
-(void)RecentdealChange:(NSNotification *)notification{
    [self.deals removeAllObjects];
    
    self.currentPage = 0;
    [self loadMoreDeals];
}



- (void)loadMoreDeals
{
    // 1.增加页码
    self.currentPage++;
    
    // 2.增加新数据
    [self.deals addObjectsFromArray:[MTDealTool recentDeals:self.currentPage]];
    
    // 3.刷新表格
    [self.collectionView reloadData];
    
    // 4.结束刷新
    [self.collectionView footerEndRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    
    // 控制尾部控件的显示和隐藏
    self.collectionView.footerHidden = (self.deals.count == [MTDealTool recentDealsCount]);
    
    // 控制"没有数据"的提醒
    self.noDataView.hidden = (self.deals.count != 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTDetailViewController *detailVc = [[MTDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
