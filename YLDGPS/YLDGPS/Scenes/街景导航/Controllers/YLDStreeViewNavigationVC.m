//
//  YLDStreeViewNavigationVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDStreeViewNavigationVC.h"
#import "YLDCommon.h"
@interface YLDStreeViewNavigationVC ()<BMKLocationServiceDelegate>


@property (nonatomic,assign)CLLocationCoordinate2D currentDeviceCoor;
@property (nonatomic,strong)panoramaView *panorama;
@property (nonatomic,strong)YLDNavigationView *navigationView;
@property (nonatomic,strong)UIButton *resetButton;
@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic, strong) mainViewModel *viewModel;
@end

@implementation YLDStreeViewNavigationVC
@synthesize items = _items;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"街景导航";
    YLDSelectDeviceView *selectDeviceView = [[YLDSelectDeviceView alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 0, 110, 20)];
    __block YLDSelectDeviceView *weakSelectDeviceView = selectDeviceView;
    NSDictionary *deviceDic = [YLDDataManager manager].currentDevice;
    weakSelectDeviceView.typeString = deviceDic[@"nick_name"];
    selectDeviceView.selectBlock = ^{
        [YCXMenu setTintColor:COLOR_WITH_HEX(0x666666)];
        if ([YCXMenu isShow]){
            [YCXMenu dismissMenu];
        } else {
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 90, 0, 80, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
                weakSelectDeviceView.typeString = item.title;
                NSMutableArray *array = [YLDDataManager manager].devices;
                for(NSDictionary *dic in array){
                    if([dic[@"nick_name"] isEqualToString:item.title]){
                        [[YLDDataManager manager] setCurrentDevice:dic];
                        _currentDeviceCoor = self.viewModel.currentDeviceCoor;
                        CLLocationCoordinate2D position = self.viewModel.currentDeviceCoor;
                        NSString *title = @"";
                        [self showPanoramaWithCoordinate:position title:title];

                        break;
                    }
                }

            }];
        }
        
    };
    
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectDeviceView];
    self.navigationItem.rightBarButtonItem = selectItem;

    _currentDeviceCoor = self.viewModel.currentDeviceCoor;
    CLLocationCoordinate2D position = self.viewModel.currentDeviceCoor;
    NSString *title = @"";
    [self showPanoramaWithCoordinate:position title:title];
}
#pragma mark - getters and setters
- (mainViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[mainViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)resetButton{
    if(!_resetButton){
        _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-36, kScreenHeight-44-40-20-36-64, 36, 36)];
        [_resetButton setBackgroundImage:[UIImage imageNamed:@"reset"] forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}
- (YLDNavigationView *)navigationView{
    if(!_navigationView){
        _navigationView = [[YLDNavigationView alloc] initWithFrame:CGRectMake(20, kScreenHeight-44-40-64, kScreenWidth-40, 44)];
        __block YLDStreeViewNavigationVC *weakSelf = self;

        _navigationView.navigateBlock = ^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
                NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving",weakSelf.currentDeviceCoor.latitude, weakSelf.currentDeviceCoor.longitude, @"sd"];
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }

        };
    }
    return _navigationView;
}
- (void)resetAction{

}
- (void)showPanoramaWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title{
    if(!_panorama){
        _panorama = [[panoramaView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_panorama];
        [self.view addSubview:self.navigationView];
        [self.view addSubview:self.resetButton];
    }
    [_panorama setCoordinate:coordinate title:title];

}
#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        NSMutableArray *deviceNames = [YLDDataManager manager].deviceNames;
        //set item
        _items = [[NSMutableArray alloc] init];
        for(int i = 0 ; i < deviceNames.count ; i++){
            YCXMenuItem *item =[YCXMenuItem menuItem:deviceNames[i] image:nil tag:100
                                            userInfo:@{@"title":@"Menu"}];
            [_items addObject:item];
        }
    }
    return _items;
}


- (void)setItems:(NSMutableArray *)items {
    _items = items;
}

@end
