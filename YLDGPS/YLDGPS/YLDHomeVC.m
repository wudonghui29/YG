//
//  YLDHomeVC.m
//  YLDGPS
//
//  Created by faith on 17/3/9.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDHomeVC.h"
#import "YLDCommon.h"
@interface YLDHomeVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic,strong) BMKMapView *mapView;//地图视图
@property (nonatomic,strong) BMKLocationService *service;//定位服务
@end

@implementation YLDHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的爱车";
    [self.view addSubview:self.mapView];
    self.service = [[BMKLocationService alloc] init];
    
    //设置代理
    self.service.delegate = self;
    kScreenHeight - KMapHeight
    //开启定位
    [self.service startUserLocationService];
}
- (BMKMapView*)mapView{
    if(_mapView == nil) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 54, kScreenWidth, KMapHeight)];
        _mapView.rotateEnabled = NO;
        _mapView.zoomLevel = 15;
        _mapView.delegate = self;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
    }
    return _mapView;
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [self.mapView updateLocationData:userLocation];
}
@end
