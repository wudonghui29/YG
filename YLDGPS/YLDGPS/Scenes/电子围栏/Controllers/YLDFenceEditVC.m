//
//  YLDFenceEditVC.m
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDFenceEditVC.h"
#import "YLDCommon.h"
@interface YLDFenceEditVC ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewTitles;
@property (nonatomic, strong) BMKMapView            *baiduMapView;
@property (nonatomic, strong) BMKLocationService    *baiduLocationService;
@property (nonatomic, strong) BMKCircle             *baiduOldCircle;
@property (nonatomic, strong) BMKCircle             *baiduCircle;
@property (nonatomic, assign) userMapSelected       userMapSelected;            //用户选择的地图（百度、google）

@property (nonatomic,strong) NSString *fenceName;
@property (nonatomic,assign) NSInteger remindType;
@property (nonatomic,strong) NSString *remindTypeString;
@property (nonatomic,strong) NSString *receiveIntervalStr;
@property (nonatomic,strong) NSString *receiveTimesStr;
@property (nonatomic, strong) UILabel *radiusLabel;
@property (nonatomic, strong) UILabel *footerView;
@end

@implementation YLDFenceEditVC
@synthesize viewModel = _viewModel;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.baiduMapView viewWillAppear];
    self.baiduMapView.delegate = self;
    self.baiduLocationService.delegate = self;
    [self reloadTableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.baiduMapView viewWillDisappear];
    self.baiduMapView.delegate = nil;
    self.baiduLocationService.delegate = nil;
}
- (void)reloadTableView{
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initData];
//    self.service = [[BMKLocationService alloc] init];
//    //设置代理
//    self.service.delegate = self;
//    //开启定位
//    [self.service startUserLocationService];

//    [self addSubViews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.baiduMapView];
//    [self.view addSubview:self.googleMapView];
    [self.view addSubview:self.radiusLabel];
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 60, 20)];
    [submitButton setTitleColor:HomeNavigationBar_COLOR forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *submitButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = submitButtonItem;
    [self performSelector:@selector(setCricle) withObject:nil afterDelay:0.3];
    [self rac];
}
- (void)initData{
    _fenceName = @"公司";
    _remindType = @"进入提醒";
    _receiveIntervalStr = @"5分钟";
    _receiveTimesStr = @"1次/24小时";
}
- (NSArray*)tableViewTitles{
    if(_tableViewTitles == nil){
        _tableViewTitles = @[@"围栏名字", @"提醒类型", @"接收提醒"];
    }
    return _tableViewTitles;
}
#pragma mark - getters and setters
- (fenceEditViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[fenceEditViewModel alloc] init];
        _viewModel.deviceID = self.deviceID;
    }
    return _viewModel;
}


- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44*3+10+20)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);

        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [YLDShow fullSperatorLine:_tableView];
    }
    return _tableView;
}
- (BMKMapView*)baiduMapView{
    if((_baiduMapView == nil) && (self.userMapSelected == userMapBaidu)){
        _baiduMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 44*3+10+20, kScreenWidth, kScreenHeight-64-44*3-20-10)];
    }
    return _baiduMapView;
}

- (BMKLocationService*)baiduLocationService{
    if((_baiduLocationService == nil) && (self.userMapSelected == userMapBaidu)){
        _baiduLocationService = [[BMKLocationService alloc]init];
    }
    return _baiduLocationService;
}

- (BMKCircle*)baiduOldCircle{
    if((_baiduOldCircle == nil) && (self.userMapSelected == userMapBaidu) && !self.isCreate){
        _baiduOldCircle = [[BMKCircle alloc] init];
        [self.baiduMapView addOverlay:_baiduOldCircle];
    }
    return _baiduOldCircle;
}

- (BMKCircle*)baiduCircle{
    if((_baiduCircle == nil) && (self.userMapSelected == userMapBaidu)){
        _baiduCircle = [[BMKCircle alloc] init];
        [self.baiduMapView addOverlay:_baiduCircle];
    }
    return _baiduCircle;
}
- (UILabel*)radiusLabel{
    if(_radiusLabel == nil){
//        frame.size.width = 80;
//        frame.size.height = 20;
//        frame.origin.x = self.view.frame.size.width - 10 - frame.size.width;
//        frame.origin.y += 10;
//        self.radiusLabel.frame = frame;

        _radiusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-80, 44*3+10+20+10, 80, 20)];
        _radiusLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        _radiusLabel.textColor = [UIColor whiteColor];
        _radiusLabel.textAlignment = NSTextAlignmentCenter;
        _radiusLabel.font = [UIFont systemFontOfSize:13];
        _radiusLabel.layer.cornerRadius = 3;
        _radiusLabel.layer.masksToBounds = YES;
    }
    return _radiusLabel;
}


//- (void)addSubViews{
//    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.mapView];
//    [self initZoomView];
//}
- (void)initZoomView{
    UIImageView *zoomImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, kScreenHeight-64-30-73, 36, 73)];
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

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    return headView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = COLOR_WITH_HEX(0x333333);
    cell.textLabel.text = self.tableViewTitles[indexPath.row];
    UIView *parameterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
    UILabel *parameterLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 176, 24)];
    parameterLbl.textColor = COLOR_WITH_HEX(0x808080);
    parameterLbl.textAlignment = NSTextAlignmentRight;
    parameterLbl.font = [UIFont systemFontOfSize:12];
    [parameterView addSubview:parameterLbl];
    UIImageView *nest = [[UIImageView alloc] init];
    nest.frame = CGRectMake(175, 0, 24, 24);
    [parameterView addSubview:nest];
    cell.accessoryView = parameterView;
    NSString *p = @"";
    UIImage *image = [UIImage imageNamed:@"nest"];
    if(indexPath.row ==0){
        p = _fenceName;
    }else if (indexPath.row ==1){
        p = _remindTypeString;
    }else if (indexPath.row ==2){
        NSString *detailText = @"";
        NSInteger receiveInterval = self.viewModel.remindRecevieViewModel.receiveInterval + 1;
        detailText = localizedString([NSString stringWithFormat:@"receiveInterval%d", (int)receiveInterval]);
        NSInteger receiveTimes = self.viewModel.remindRecevieViewModel.receiveTimes + 1;
        detailText = [detailText stringByAppendingString:@","];
        detailText = [detailText stringByAppendingString:localizedString([NSString stringWithFormat:@"receiveTimes%d", (int)receiveTimes])];
        p = detailText;
//        p = [NSString stringWithFormat:@"%@ %@",self.receiveIntervalStr,self.receiveTimesStr];
    }
    parameterLbl.text = p;
    nest.image = image;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0){
        YLDFenceNameSelectView *fenceNameSelectView = [[YLDFenceNameSelectView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        fenceNameSelectView.buttonBlock = ^(NSString *str){
            if(str.length ==0 || !str) return ;
            self.fenceName = str;
            [self.tableView reloadData];

        };
        [self.view.window addSubview:fenceNameSelectView];
    }else if (indexPath.row ==1){
        YLDRemindView *remindView = [[YLDRemindView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        [remindView setFirstStatusWithType:self.remindType];
        remindView.confirmBlock = ^(BOOL isSelected){
            if(!isSelected){
                NSString *str = localizedString(@"inRemind");
                _remindTypeString = str;
                [self.tableView reloadData];
            }
        };
        remindView.selectFenceRemindType = ^(NSString *str){
            _remindTypeString = str;
            if(str.length ==0 || !str){
                str = localizedString(@"inRemind");
            }
            if([str isEqualToString:localizedString(@"inRemind")]){
                self.remindType = 0;
            }else{
                self.remindType = 1;
            }

            [self.tableView reloadData];

        };
        [self.view.window addSubview:remindView];
    }else if (indexPath.row ==2){
        remindRecevieViewController *remindReceiveVC = [[remindRecevieViewController alloc] init];
        remindReceiveVC.viewModel = self.viewModel.remindRecevieViewModel;
//        YLDRemindReceiveVC *remindReceiveVC = [[YLDRemindReceiveVC alloc] init];
//        remindReceiveVC.selectIntervalTimeBlock = ^(NSString *receiveIntervalStr, NSString *receiveTimesStr){
//            self.receiveIntervalStr = receiveIntervalStr;
//            self.receiveTimesStr = receiveTimesStr;
//            [self.tableView reloadData];
//        };
        [self.navigationController pushViewController:remindReceiveVC animated:YES];
    }
    
}
- (userMapSelected)userMapSelected{
    _userMapSelected = [YLDDataManager manager].userData.userMapSelected;
    return _userMapSelected;
}
- (void)setViewModel:(fenceEditViewModel *)viewModel {
    
    _viewModel = viewModel;
    _viewModel.deviceID = self.deviceID;
    self.fenceName = _viewModel.fenceName;
    
    self.remindType = _viewModel.remindType;
    switch (self.remindType) {
        case 0:{
            _remindTypeString = localizedString(@"inRemind");
        }
            break;
            
        case 1:{
            _remindTypeString = localizedString(@"outRemind");
        }
            break;
    }

    NSArray *lonlatarr = [_viewModel.circleLonlat componentsSeparatedByString:@","];
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = [lonlatarr.firstObject doubleValue];
    coordinate.latitude = [lonlatarr.lastObject doubleValue];
    
    if(self.userMapSelected == userMapBaidu){
        self.baiduOldCircle.coordinate = coordinate;
        self.baiduOldCircle.radius = _viewModel.circleRadius.integerValue;
        self.baiduCircle.coordinate = coordinate;
        self.baiduCircle.radius = _viewModel.circleRadius.integerValue;
        [self.baiduMapView setCenterCoordinate:coordinate];
    }else{
//        self.googleOldCircle.position = coordinate;
//        self.googleOldCircle.radius = _viewModel.circleRadius.integerValue;
//        self.googleCircle.position = coordinate;
//        self.googleCircle.radius = _viewModel.circleRadius.integerValue;
//        GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:10];
//        self.googleMapView.camera = camera;
    }
    
}
///设置围栏
- (void)setCricle {
    
    NSArray *devices = [YLDDataManager manager].devices;
    
    for(NSInteger i = 0; i < devices.count; i++) {
        
        NSDictionary *dic = devices[i];
        NSString *deviceID = [dic[@"device_id"] stringValue];
        
        if([deviceID isEqualToString:self.deviceID]) {
            
            NSDictionary *locationDic = dic[@"location"];
            NSString *lonlat = locationDic[@"lonlat"];
            
            CLLocationCoordinate2D coor = {0};
            
            coor.latitude = [[lonlat componentsSeparatedByString:@","].lastObject floatValue];
            coor.longitude = [[lonlat componentsSeparatedByString:@","].firstObject floatValue];
            
            if([YLDDataManager manager].userData.userMapSelected == userMapBaidu) {
                coor = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS));
            }else {
                coor = transform(coor.latitude, coor.longitude);
            }
            
            if((coor.latitude != 0) && (coor.longitude != 0)) {
                [self setFenceWithCoor:coor Meters:1000];
                return;
            }
            
            break;
        }
    }
    
}

- (void)setFenceWithCoor:(CLLocationCoordinate2D)coor Meters:(CLLocationDistance)meters {
    meters *=1.2;
    if(self.userMapSelected == userMapBaidu){
        BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance(coor, meters*2, meters*2);
        [self.baiduMapView setRegion:region];
    }else{
//        CGFloat adjust = [self.googleMapView.projection pointsForMeters:meters atCoordinate:coor];
//        CGPoint centerPoint = [self.googleMapView.projection pointForCoordinate:coor];
//        CLLocationCoordinate2D coor = [self.googleMapView.projection coordinateForPoint:CGPointMake(centerPoint.x - adjust, centerPoint.y)];
//        CLLocationCoordinate2D coor1 = [self.googleMapView.projection coordinateForPoint:CGPointMake(centerPoint.x + adjust, centerPoint.y)];
//        GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:coor coordinate:coor1];
//        GMSCameraPosition *cameraPosition = [self.googleMapView cameraForBounds:coordinateBounds insets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [self.googleMapView animateToCameraPosition:cameraPosition];
    }
}
#pragma mark BMKMapViewDelegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        if(overlay == self.baiduOldCircle){
            circleView.fillColor = [UIColor colorWithRed:0.98 green:0.35 blue:0.4 alpha:0.3];
            circleView.strokeColor = [UIColor colorWithRed:0.85 green:0.4 blue:0.39 alpha:0.8];
        }else{
            circleView.fillColor = [UIColor colorWithRed:0.24 green:0.62 blue:0.82 alpha:0.3];
            circleView.strokeColor = [UIColor colorWithRed:0.24 green:0.62 blue:0.82 alpha:0.8];
        }
        circleView.lineWidth = 1.0;
        return circleView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status{
    CGPoint p = CGPointZero;
    CGPoint p1 = CGPointZero;
    if(mapView.frame.size.width > mapView.frame.size.height){
        p.x = mapView.frame.size.width/2;
        p1.x = mapView.frame.size.width/2;
        p1.y = mapView.frame.size.height;
    }else{
        p.y =  mapView.frame.size.height/2;
        p1.x = mapView.frame.size.width;
        p1.y = mapView.frame.size.height/2;
    }
    CLLocationCoordinate2D coor = [mapView convertPoint:p toCoordinateFromView:mapView];
    CLLocationCoordinate2D coor1 = [mapView convertPoint:p1 toCoordinateFromView:mapView];
    BMKMapPoint point = BMKMapPointForCoordinate(coor);
    BMKMapPoint point1 = BMKMapPointForCoordinate(coor1);
    double meters = BMKMetersBetweenMapPoints(point, point1);
    meters/=2;
    self.baiduCircle.coordinate = mapView.region.center;
    self.baiduCircle.radius = meters/=1.2;
}
- (UILabel*)footerView{
    if(_footerView == nil){
        _footerView = [[UILabel alloc] init];
        _footerView.backgroundColor = [UIColor grayColor];
        _footerView.textColor = [UIColor whiteColor];
        _footerView.font = [UIFont systemFontOfSize:14];
        _footerView.text = [NSString stringWithFormat:@"  %@", localizedString(@"fenceEditTips")];
    }
    return _footerView;
}
- (void)rac{
    @weakify(self);
    if(self.userMapSelected == userMapBaidu){
        RAC(self.radiusLabel, text) = [RACSignal combineLatest:@[RACObserve(self.baiduCircle, radius)] reduce:^id{
            @strongify(self);
            return [NSString stringWithFormat:@"r = %.2f km", (self.baiduCircle.radius/1000)];
        }];
        RAC(self.viewModel, circleRadius) = [RACSignal combineLatest:@[RACObserve(self.baiduCircle, radius)] reduce:^id{
            @strongify(self);
            return [NSString stringWithFormat:@"%f", self.baiduCircle.radius];
        }];
        RAC(self.viewModel, circleLonlat) = [RACSignal combineLatest:@[RACObserve(self.baiduCircle, coordinate)] reduce:^id{
            @strongify(self);
            CLLocationCoordinate2D coor = self.baiduCircle.coordinate;
            return [NSString stringWithFormat:@"%f,%f", coor.longitude, coor.latitude];
        }];
    }
//    else{
//        RAC(self.radiusLabel, text) = [RACSignal combineLatest:@[RACObserve(self.googleCircle, radius)] reduce:^id{
//            @strongify(self);
//            return [NSString stringWithFormat:@"r = %.2f km", (self.googleCircle.radius/1000)];
//        }];
//        RAC(self.viewModel, circleRadius) = [RACSignal combineLatest:@[RACObserve(self.googleCircle, radius)] reduce:^id{
//            @strongify(self);
//            return [NSString stringWithFormat:@"%f", self.googleCircle.radius];
//        }];
//        RAC(self.viewModel, circleLonlat) = [RACSignal combineLatest:@[RACObserve(self.googleCircle, position)] reduce:^id{
//            @strongify(self);
//            return [NSString stringWithFormat:@"%f,%f", self.googleCircle.position.longitude, self.googleCircle.position.latitude];
//        }];
//    }
    
    RAC(self.viewModel, fenceName) = [RACSignal combineLatest:@[RACObserve(self, fenceName)] reduce:^id{
        @strongify(self);
        return self.fenceName;
    }];
    RAC(self.viewModel, remindType) = [RACSignal combineLatest:@[RACObserve(self, remindType)] reduce:^id{
        @strongify(self);
        return [NSNumber numberWithInteger:self.remindType];
    }];
    
    [RACObserve(self.viewModel, r) subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(self.viewModel.r){
//            [self navLeftButtonPressed];
        }
        
        if(self.viewModel.msg.length > 0){
            TSMessageNotificationType type = self.viewModel.r?TSMessageNotificationTypeSuccess:TSMessageNotificationTypeError;
            [TSMessage showNotificationInViewController:self.navigationController title:self.viewModel.msg subtitle:nil image:nil type:type duration:2 callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionNavBarOverlay canBeDismissedByUser:YES];
        }
        
    }];
}

- (void)submit{
    NSString *warningMsg = nil;
    if(self.viewModel.fenceName.length <= 0){
        warningMsg = localizedString(@"fenceWarning");
    }
    
    if(warningMsg.length > 0){
        [TSMessage showNotificationInViewController:self.navigationController title:nil subtitle:warningMsg image:nil type:TSMessageNotificationTypeWarning duration:2 callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionNavBarOverlay canBeDismissedByUser:YES];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        [self.viewModel submitFence];
    }

}

#pragma mark - Actions
- (void)zoomAction:(UIButton *)button{
//    NSInteger tag = button.tag;
//    if(tag ==0){
//        [self.mapView zoomIn];
//    }else{
//        [self.mapView zoomOut];
//    }
}

@end
