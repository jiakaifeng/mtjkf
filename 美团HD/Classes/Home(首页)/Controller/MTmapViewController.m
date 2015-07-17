//
//  MTmapViewController.m
//  美团HD
//
//  Created by jiakaifeng on 15/7/13.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "MTmapViewController.h"
#import "MTNavigationController.h"
#import "UIImageView+HighlightedWebCache.h"
#import "UIImage+MultiFormat.h"
#import "UIBarButtonItem+Extension.h"
#import <MapKit/MapKit.h>
#import "MTSearchViewController.h"
#import "DPAPI.h"
@interface MTmapViewController ()<MKMapViewDelegate,DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property(strong,nonatomic)CLGeocoder *coder;

@end

@implementation MTmapViewController
-(CLGeocoder *)coder{
    if (!_coder) {
        self.coder=[[CLGeocoder alloc]init];
        
    }
    return _coder;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
self.title=@"地图信息";
    self.mapview.userTrackingMode=MKUserTrackingModeFollow;
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self.coder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks==0) return ;
        CLPlacemark *pm=[placemarks firstObject];
        DPAPI *api = [[DPAPI alloc] init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        // 调用子类实现的方法
        NSString *city= pm.locality ? pm.locality :pm.addressDictionary[@"State"];
        [city substringToIndex:city.length-1];
        params[@"city"] = city;
        params[@"latitude"] = @(userLocation.location.coordinate.latitude);
        params[@"longitude"] = @(userLocation.location.coordinate.longitude);
        params[@"radius"] = @5000;
        NSLog(@"diming %@,%@",pm.locality,pm.addressDictionary);

        [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    }];

}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)request:(DPRequest *)request didFailWithError:(NSError *)error{




}
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
