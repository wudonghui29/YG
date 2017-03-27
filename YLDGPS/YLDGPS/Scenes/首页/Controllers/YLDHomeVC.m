//
//  YLDHomeVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDHomeVC.h"
#import "YLDCommon.h"
static NSString * const cellReuseIdentifierID = @"YLDGridView";


@interface YLDHomeVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic,strong) BMKMapView *mapView;//地图视图
@property (nonatomic,strong) BMKLocationService *service;//定位服务
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong)UIButton *resetButton;
@property (nonatomic, strong) mainViewModel *viewModel;
@property (nonatomic, assign) userMapSelected       userMapSelected;            //用户选择的地图（百度、google）
@end

@implementation YLDHomeVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIColor *navigationBarColor = HomeNavigationBar_COLOR;
    UIColor *navigationBarTitleColor = NavigationBar_COLOR;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:navigationBarTitleColor,NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    self.title = self.viewModel.currentDeviceName;
    [self showMapMarks];
}
#pragma mark - getters and setters
- (mainViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[mainViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.currentDeviceName;
    [self.view addSubview:self.mapView];
    [self initGridView];
    self.userMapSelected = userMapBaidu;
    [self.view addSubview:self.resetButton];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, KMapHeight, kScreenWidth, 1)];
    lineView.backgroundColor = SeparatorLine_COLOR;
    [self.view addSubview:lineView];
    self.service = [[BMKLocationService alloc] init];
    
    //设置代理
    self.service.delegate = self;
    //开启定位
    [self.service startUserLocationService];
    [self showMapMarks];

}
- (NSArray *)titleArray{
    if(!_titleArray){
        _titleArray = [[NSArray alloc] initWithObjects:@"实时定位",@"轨迹回放",@"电子围栏",@"报警提醒",@"离线地图",@"街景导航",@"设备管理",@"系统设置",@"省电模式",@"充值(卡)",@"客服中心",@"注销登录", nil];
    }
    return _titleArray;
}
- (UIButton *)resetButton{
    if(!_resetButton){
        _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-10-36,KMapHeight-10-36, 36, 36)];
        [_resetButton setBackgroundImage:[UIImage imageNamed:@"reset"] forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (BMKMapView*)mapView{
    if(_mapView == nil) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KMapHeight)];
        _mapView.rotateEnabled = NO;
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
//        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
//        _mapView.showsUserLocation = YES;
    }
    return _mapView;
}
- (void)initGridView{
    __block YLDLoginVC *weakLoginVC = self;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KMapHeight, kScreenWidth, kScreenHeight-KMapHeight)];
    [self.view addSubview:bgView];
    for (int index=0; index<12; index++) {
        int totalColumns = 3;
        int row=index/totalColumns;
        int col=index%totalColumns;
        int appW = kGirdWidth;
        int appH = kGirdHeight;
        
        YLDGridView *gridView = [[YLDGridView alloc]init];
        gridView.tag = index;
        gridView.frame = CGRectMake(col*appW, row*appH, appW, appH);
        gridView.titleLbl.text = self.titleArray[index];
        gridView.icon.image = [UIImage imageNamed:self.titleArray[index]];
        gridView.didSelectedBlock = ^(NSInteger tag){
            UIViewController* vc = nil;
            switch (tag) {
                case 0:
                    vc = [[YLDLocationVC alloc] init];
                    break;
                case 1:
                    vc = [[YLDTrackReplayVC alloc] init];
                    break;
                case 2:
                    vc = [[YLDFenceVC alloc] init];
                    break;
                case 3:
                    vc = [[YLDAlarmReminderVC alloc] init];
                    break;
                case 4:
                    vc = [[YLDOfflineMapVC alloc] init];
                    break;
                case 5:
                    vc = [[YLDStreeViewNavigationVC alloc] init];
                    break;
                case 6:
                    vc = [[YLDDeviceMangerVC alloc] init];
                    break;
                case 7:
                    vc = [[YLDSystemSettingVC alloc] init];
                    break;
                case 8:
                    vc = [[YLDPoverSaverVC alloc] init];
                    break;
                case 9:{
                    [SVProgressHUD showInfoWithStatus:@"此功能正在建设中,敬请期待"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });

                }
                    
                    
                    break;
                case 10:
                    vc = [[YLDServiceCenterVC alloc] init];
                    break;
                case 11:{
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"注销" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        NSLog(@"取消执行");
                    }];
                    
                    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [YLDDataManager manager].userData.login = NO;
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:otherAction];
                    [self presentViewController:alertController animated:YES completion:nil]
                    ;
                }
            
//                    [self showAlertView];
                    break;
                    default:
                    break;
            }
            if([vc isKindOfClass:[YLDLoginVC class]]){
                
                [TSMessage setDefaultViewController:vc];
                [self presentViewController:vc animated:YES completion:nil];
                return;
            }
            [self.navigationController pushViewController:vc animated:YES];
        };
        [bgView addSubview:gridView];
    }
    for(int i = 0; i < 4; i ++){
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*kGirdHeight, kScreenWidth, 1)];
        lineView.backgroundColor = SeparatorLine_COLOR;
        [bgView addSubview:lineView];
    }
    for(int j = 1; j <3; j++){
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(j*kGirdWidth, 0, 1, kScreenHeight - KMapHeight - 64)];
        lineView.backgroundColor = SeparatorLine_COLOR;
        [bgView addSubview:lineView];
    }


}
- (void)resetAction{
     [self.mapView setCenterCoordinate:self.viewModel.currentDeviceCoor];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    NSString *AnnotationViewID = @"deviceMark";
    BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.enabled3D = YES;
//        annotationView.image = [UIImage imageNamed:@"car"];
        CGPoint centerPoint = annotationView.centerOffset;
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
- (void)showMapMarks {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
//    [self.googleMapView clear];
    

    
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
            
//            coor = transform(coor.latitude, coor.longitude);
//            GMSMarker *marker = [[GMSMarker alloc] init];
//            marker.tappable = YES;
//            marker.position = coor;
//            marker.title = title;
//            marker.snippet = subTitle;
//            marker.userData = dic;
//            marker.map = self.googleMapView;
//            
//            marker.icon = [UIImage imageNamed:@"deviceMark"];
//            UIImageView *imageView = [[UIImageView alloc] init];
//            [self.googleMapView addSubview:imageView];
//            NSString *head_icon = dic[@"head_icon"];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:head_icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if(image != nil){
//                    marker.icon = [self imageAddToMark:image MarkImage:@"deviceMark"];
//                }
//                [imageView removeFromSuperview];
//            }];
//            
        }
        
    }
    
    [self showCurrentDevice];
}
- (void)showCurrentDevice {
    if(self.userMapSelected == userMapBaidu){
        
        [self.mapView setCenterCoordinate:self.viewModel.currentDeviceCoor];
        
    }else{
        
//        GMSCameraUpdate *camerUpdate = [GMSCameraUpdate setTarget:self.viewModel.currentDeviceCoor];
//        [self.googleMapView moveCamera:camerUpdate];
        
    }
    
//    [self showInfoViewWithDic:self.viewModel.currentDevice];
}


//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
//    [self.mapView updateLocationData:userLocation];
//}

@end
