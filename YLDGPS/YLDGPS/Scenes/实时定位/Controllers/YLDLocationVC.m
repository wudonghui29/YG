//
//  YLDLocationVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDLocationVC.h"
#import "YLDCommon.h"



@interface YLDLocationVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,GMSMapViewDelegate>
@property (nonatomic,strong) BMKMapView *mapView;//地图视图
@property (nonatomic,strong) BMKLocationService *service;//定位服务
@property (nonatomic, strong) mainViewModel *viewModel;
@property (nonatomic, strong) BMKMapView *baiduMapView;
@property (nonatomic, strong) GMSMapView *googleMapView;
@property (nonatomic, assign) userMapSelected       userMapSelected;            //用户选择的地图（百度、google）
@property(nonatomic, strong) YLDSwitchView *switchView;
@property(nonatomic, strong) YLDPositionInforView *inforView;
@property(nonatomic, strong) UIButton *currentDevice;

@property (nonatomic, strong) NSMutableArray *deviceCacheAddressList;    //缓存的地址

@end

@implementation YLDLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实时定位";
    self.userMapSelected = userMapBaidu;
    [self rac];
    self.service = [[BMKLocationService alloc] init];
    [self addSubViews];
    //设置代理
    self.service.delegate = self;
    //开启定位
    [self.service startUserLocationService];
    [self.viewModel getDevicesList];
    [self showMapMarks];

}
- (void)addSubViews{
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.switchView];
    [self.view addSubview:self.inforView];
    [self initZoomView];
    [self.view addSubview:self.currentDevice];
}
- (void)initZoomView{
    UIImageView *zoomImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 126, 36, 73)];
    zoomImage.userInteractionEnabled = YES;
    zoomImage.image = [UIImage imageNamed:@"zoom"];
    [self.view addSubview:zoomImage];
    
    UIButton *zoomIn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 37)];
    zoomIn.tag = 0;
    [zoomIn addTarget:self action:@selector(zoomAction:) forControlEvents:UIControlEventTouchUpInside];
    [zoomImage addSubview:zoomIn];
    
    UIButton *zoomOut = [[UIButton alloc] initWithFrame:CGRectMake(0, 37, 36, 36)];
    zoomOut.tag = 1;
    [zoomOut addTarget:self action:@selector(zoomAction:) forControlEvents:UIControlEventTouchUpInside];
    [zoomImage addSubview:zoomOut];

}
- (UIButton *)currentDevice{
    if(!_currentDevice){
        _currentDevice = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-51, kScreenHeight-200-64, 36, 36)];
        [_currentDevice setBackgroundImage:[UIImage imageNamed:@"currentDevice"] forState:UIControlStateNormal];
    }
    return _currentDevice;
}
- (BMKMapView*)mapView{
    if(_mapView == nil) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _mapView.rotateEnabled = NO;
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
//        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
//        _mapView.showsUserLocation = YES;
    }
    return _mapView;
}
- (YLDSwitchView *)switchView{
    __block YLDLocationVC *weakLocationVC = self;
    if(!_switchView){
        _switchView = [[YLDSwitchView alloc] initWithFrame:CGRectMake(kScreenWidth-90, 10, 80, 32)];
        _switchView.switchBlock = ^(NSInteger tag){
            if(tag ==0){
                weakLocationVC.mapView.mapType = BMKMapTypeStandard;
            }else{
                weakLocationVC.mapView.mapType = BMKMapTypeSatellite;

            }
        };
    }
    return _switchView;
}
- (YLDPositionInforView *)inforView{
    if(!_inforView){
        _inforView = [[YLDPositionInforView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
        _inforView.detailBlock = ^{
            YLDVDeviceDetailVC *deviceDetailVC = [[YLDVDeviceDetailVC alloc] init];
            deviceDetailVC.deviceID = self.viewModel.currentDeviceID;
            [self.navigationController pushViewController:deviceDetailVC animated:YES];
        };
    }
    return _inforView;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [self.mapView updateLocationData:userLocation];
}
#pragma mark - Actions
- (void)zoomAction:(UIButton *)button{
    NSInteger tag = button.tag;
    if(tag ==0){
        [self.mapView zoomIn];
    }else{
        [self.mapView zoomOut];
    }
}

#pragma mark - getters and setters
- (mainViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[mainViewModel alloc] init];
    }
    return _viewModel;
}
- (void)showMapMarks {
    
    [self.baiduMapView removeAnnotations:self.baiduMapView.annotations];
    [self.googleMapView clear];
    
    [self.deviceCacheAddressList removeAllObjects];
    
    CLLocationCoordinate2D coor = {0};
    
    for(NSDictionary *dic in self.viewModel.devices) {
        
        NSString *nickName = dic[@"nick_name"];
        NSDictionary *locationDic = dic[@"location"];
        NSString *address = locationDic[@"address"];
        NSString *lonlat = locationDic[@"lonlat"];
        NSString *loc_way = locationDic[@"loc_way"];
        NSNumber *bds = locationDic[@"bds"];
        
        NSString *locWayString = @"";
        if(bds.integerValue == 1) {
            locWayString = localizedString(@"locBDS");
        }else {
            if(loc_way.integerValue == 1) {
                locWayString = @"GPS";
            }else {
                locWayString = @"LBS";
            }
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([locationDic[@"time"] floatValue]/1000)];
        
        NSString *time = [formatter stringFromDate:date];
        NSString *title = nickName;
        NSString *subTitle = [NSString stringWithFormat:@"%@\n%@（%@）", address, time, locWayString];
        
        coor.latitude = [[lonlat componentsSeparatedByString:@","].lastObject floatValue];
        coor.longitude = [[lonlat componentsSeparatedByString:@","].firstObject floatValue];
        
        if(self.userMapSelected == userMapBaidu) {
            
            CSBMKPointAnnotation *pointAnnotation = [[CSBMKPointAnnotation alloc]init];
            coor = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS));
            pointAnnotation.coordinate = coor;
            pointAnnotation.title = title;
            pointAnnotation.subtitle = subTitle;
            pointAnnotation.annotationDic = dic;
            [self.mapView addAnnotation:pointAnnotation];
            
        }else {
            
            coor = transform(coor.latitude, coor.longitude);
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.tappable = YES;
            marker.position = coor;
            marker.title = title;
            marker.snippet = subTitle;
            marker.userData = dic;
            marker.map = self.googleMapView;
            
            marker.icon = [UIImage imageNamed:@"deviceMark"];
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.googleMapView addSubview:imageView];
            NSString *head_icon = dic[@"head_icon"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:head_icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    marker.icon = [self imageAddToMark:image MarkImage:@"deviceMark"];
                }
                [imageView removeFromSuperview];
            }];
            
        }
        
    }
    
    [self showCurrentDevice];
}
- (NSMutableArray*)deviceCacheAddressList {
    if(_deviceCacheAddressList == nil) {
        _deviceCacheAddressList = [NSMutableArray array];
    }
    return _deviceCacheAddressList;
}
- (NSString*)cacheAddressWithDeviceID:(NSString*)deviceID {
    NSString *address = nil;
    
    for (NSDictionary *dic in self.deviceCacheAddressList) {
        NSString *deviceID1 = dic[@"deviceID"];
        if([deviceID1 isEqualToString:deviceID]) {
            address = dic[@"address"];
            break;
        }
    }
    
    return address;
}
- (UIImage *)imageAddToMark:(UIImage *)image MarkImage:(NSString*)markImage{
    
    UIImageView *markImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:markImage]];
    
    if(image != nil) {
        UIImageView *circleHeadImageView = [[UIImageView alloc] init];
        circleHeadImageView.image = image;
        circleHeadImageView.frame = CGRectMake(14, 5, 36, 36);
        circleHeadImageView.layer.cornerRadius = circleHeadImageView.frame.size.height/2;
        circleHeadImageView.layer.masksToBounds = YES;
        [markImageView addSubview:circleHeadImageView];
    }
    
    UIGraphicsBeginImageContext(markImageView.bounds.size);
    [markImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}
- (void)showCurrentDevice {
    if(self.userMapSelected == userMapBaidu){
        
        [self.mapView setCenterCoordinate:self.viewModel.currentDeviceCoor];
        
    }else{
        
        GMSCameraUpdate *camerUpdate = [GMSCameraUpdate setTarget:self.viewModel.currentDeviceCoor];
        [self.googleMapView moveCamera:camerUpdate];
        
    }
    
    [self showInfoViewWithDic:self.viewModel.currentDevice];
}
- (void)showInfoViewWithDic:(NSDictionary*)dic {
    
    if(dic == nil) return;
    NSString *deviceID = [dic[@"device_id"] stringValue];
    NSString *nickName = dic[@"nick_name"];
    NSString *imei = [NSString stringWithFormat:@"%@",dic[@"imei"]];
    NSDictionary *locationDic = dic[@"location"];
    NSDictionary *statusDic = dic[@"status"];
    NSNumber *loc_way = locationDic[@"loc_way"];
    NSNumber *bds = locationDic[@"bds"];
    NSString *address = locationDic[@"address"];
    NSString *speed = locationDic[@"speed"];
    NSString *power = statusDic[@"power"];
    BOOL online = [dic[@"online"] boolValue];
    NSString *onlineStr;
    if(online){
        onlineStr = @"在线";
    }else{
        onlineStr = @"离线";
    }
    NSString *locWayString = @"";
    if(bds.integerValue == 1) {
        locWayString = localizedString(@"locBDS");
    }else {
        if(loc_way.integerValue == 1) {
            locWayString = @"GPS";
        }else {
            locWayString = @"LBS";
        }
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([locationDic[@"time"] floatValue]/1000)];
    NSString *time = [formatter stringFromDate:date];
    
    self.inforView.nickName = [NSString stringWithFormat:@"%@, (IME:%@)",nickName,imei];
    self.inforView.speedPower = [NSString stringWithFormat:@"速度:%@km/h  电量:%@%%",speed,power];
    self.inforView.positionStatus = [NSString stringWithFormat:@"定位方式 : %@  状态 : %@",locWayString,onlineStr];
    self.inforView.time = [NSString stringWithFormat:@"时间 : %@",time];
    address = [NSString stringWithFormat:@"地址 : %@",address];
    self.inforView.address = address;
    CGSize s = [address textSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreenWidth - 30, 400) lineBreakMode:NSLineBreakByCharWrapping];
    [UIView animateWithDuration:0.3 animations:^{
        self.inforView.top = kScreenHeight-(130+s.height)-64;
    }];

}
- (void)rac{
    
    @weakify(self)
//    [[RACObserve([YLDDataManager manager].userData, userMapSelected) skip:1] subscribeNext:^(id x) {
//        @strongify(self);
//        [self.markInfoView hiden];
//        
//        self.satelliteButton.selected = NO;
//        self.buildingsButton.selected = NO;
//        self.isShowPanorama = NO;
//        [self.baiduMapView removeAnnotations:self.baiduMapView.annotations];
//        [self.googleMapView clear];
//        if(self.userMapSelected == userMapBaidu){
//            self.googleMapView.delegate = nil;
//            [self.googleMapView removeFromSuperview];
//            self.googleMapView = nil;
//            [self.view insertSubview:self.baiduMapView atIndex:0];
//        }else{
//            [self.baiduMapView viewWillDisappear];
//            self.baiduMapView.delegate = nil;
//            [self.baiduMapView removeFromSuperview];
//            self.baiduMapView = nil;
//            [self.view insertSubview:self.googleMapView atIndex:0];
//        }
//        [self showMapMarks];
//    }];
//    
//    [[RACObserve([YLDDataManager manager].userData, mainRefreshTime) skip:1] subscribeNext:^(id x) {
//        @strongify(self);
//        [self startRefreshTimer];
//    }];
    
//    [[self.satelliteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        if(self.userMapSelected == userMapBaidu){
//            self.baiduMapView.mapType = (self.baiduMapView.mapType == BMKMapTypeStandard)?BMKMapTypeSatellite:BMKMapTypeStandard;
//            self.baiduMapView.buildingsEnabled = NO;
//            self.baiduMapView.overlooking = 0;
//            self.satelliteButton.selected = (self.baiduMapView.mapType == BMKMapTypeStandard)?NO:YES;
//        }else{
//            self.googleMapView.mapType = (self.googleMapView.mapType == kGMSTypeNormal)?kGMSTypeSatellite:kGMSTypeNormal;
//            self.googleMapView.buildingsEnabled = NO;
//            self.satelliteButton.selected = (self.googleMapView.mapType == kGMSTypeNormal)?NO:YES;
//        }
//        self.buildingsButton.selected = NO;
//    }];
//    
//    [[self.buildingsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        if(self.userMapSelected == userMapBaidu){
//            self.baiduMapView.mapType = BMKMapTypeStandard;
//            self.baiduMapView.buildingsEnabled = !self.baiduMapView.buildingsEnabled;
//            self.baiduMapView.overlooking = self.baiduMapView.buildingsEnabled?-25:0;
//            self.buildingsButton.selected = self.baiduMapView.buildingsEnabled?YES:NO;
//        }else{
//            self.googleMapView.mapType = kGMSTypeNormal;
//            self.googleMapView.buildingsEnabled = !self.googleMapView.buildingsEnabled;
//            [self.googleMapView animateToViewingAngle:(self.googleMapView.buildingsEnabled?25:0)];
//            self.buildingsButton.selected = self.googleMapView.buildingsEnabled?YES:NO;
//        }
//        self.satelliteButton.selected = NO;
//    }];
//    
//    [[self.zoomInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        if(self.userMapSelected == userMapBaidu){
//            [self.baiduMapView zoomIn];
//        }else{
//            [self.googleMapView animateToZoom:(self.googleMapView.camera.zoom + 1)];
//        }
//    }];
//    
//    [[self.zoomOutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        if(self.userMapSelected == userMapBaidu){
//            [self.baiduMapView zoomOut];
//        }else{
//            [self.googleMapView animateToZoom:(self.googleMapView.camera.zoom - 1)];
//        }
//    }];
    
      
//    [[RACObserve(self.viewModel, hasNewVer) skip:1] subscribeNext:^(id x) {
//        @strongify(self);
//        if(self.viewModel.hasNewVer){
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:self.viewModel.releaseLog delegate:self cancelButtonTitle:localizedString(@"cancel") destructiveButtonTitle:localizedString(@"update") otherButtonTitles:nil];
//            sheet.tag = appUpdateSheetTag;
//            [sheet showInView:self.view];
//            
//        }
//    }];
    
    
    [[self.inforView.from rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        if(self.viewModel.devices.count <= 0) return;
        
        NSInteger index = 0;
        for(NSInteger i = 0; i < self.viewModel.devices.count; i++) {
            NSDictionary *dic = self.viewModel.devices[i];
            NSString *deviceID = [dic[@"device_id"] stringValue];
            if([deviceID isEqualToString:self.viewModel.currentDeviceID]) {
                index = i;
                break;
            }
        }
        
        if(index == 0) {
            index = self.viewModel.devices.count - 1;
        }else if (index > 0) {
            index --;
        }
        
        self.viewModel.currentDevice = self.viewModel.devices[index];
        
        [self showCurrentDevice];
        
    }];
    
    [[self.inforView.to rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        if(self.viewModel.devices.count <= 0) return;
        
        NSInteger index = 0;
        for(NSInteger i = 0; i < self.viewModel.devices.count; i++) {
            NSDictionary *dic = self.viewModel.devices[i];
            NSString *deviceID = [dic[@"device_id"] stringValue];
            if([deviceID isEqualToString:self.viewModel.currentDeviceID]) {
                index = i;
                break;
            }
        }
        
        if(index < (self.viewModel.devices.count - 1)) {
            index ++;
        }else if (index >= (self.viewModel.devices.count - 1)) {
            index = 0;
        }
        
        self.viewModel.currentDevice = self.viewModel.devices[index];
        
        [self showCurrentDevice];
        
    }];
    
//    [RACObserve(self.viewModel, isGetADinfoFinshed) subscribeNext:^(id x) {
//        @strongify(self);
//        
//        if(self.viewModel.isGetADinfoFinshed) {
//            
//            if(self.viewModel.adInfo != nil) {
//                [ADView showInView:self.view ADInfo:self.viewModel.adInfo];
//            }
//            
//        }
//        
//    }];
    
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    NSString *AnnotationViewID = @"deviceMark";
    BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.enabled3D = YES;
        annotationView.image = [UIImage imageNamed:@"car"];
        CGPoint centerPoint = annotationView.centerOffset;
        centerPoint.y = -26;
        annotationView.centerOffset = centerPoint;
    }
    CSBMKPointAnnotation *pointAnnotation = annotation;
    NSDictionary *dic = pointAnnotation.annotationDic;
    NSString *head_icon = dic[@"head_icon"];
    UIImageView *imageView = [[UIImageView alloc] init];
    [annotationView addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:head_icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image != nil){
            annotationView.image = [self imageAddToMark:image  MarkImage:@"car"];
        }
        [imageView removeFromSuperview];
    }];
    annotationView.canShowCallout = NO;
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    [self.inforView dissmiss];
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    CSBMKPointAnnotation *pointAnnotation = view.annotation;
    NSDictionary *dic = pointAnnotation.annotationDic;
    self.viewModel.currentDevice = dic;
    [self showInfoViewWithDic:dic];
}
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi {
    [self.inforView dissmiss];

}

@end
