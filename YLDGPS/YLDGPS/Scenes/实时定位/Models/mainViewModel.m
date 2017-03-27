//
//  mainViewModel.m
//  YLDGPS
//
//  Created by user on 15/7/4.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "mainViewModel.h"
#import "ADInfo.h"

@interface mainViewModel () {
    BMKGeoCodeSearch *geoCodeSearch;
    GMSGeocoder *myGeocoder;
}

@end

@implementation mainViewModel
@synthesize devices             = _devices;
@synthesize currentDevice       = _currentDevice;
@synthesize currentDeviceID     = _currentDeviceID;
@synthesize currentDeviceName   = _currentDeviceName;
@synthesize currentDeviceCoor   = _currentDeviceCoor;


#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    searcher.delegate = nil;
    if(searcher != geoCodeSearch) return;
    
    if(error == BMK_SEARCH_NO_ERROR) {
        
        self.deviceAddress = result.address;
        NSArray *poiS = result.poiList;
        poiS = [poiS sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            BMKPoiInfo *info1 = obj1;
            BMKPoiInfo *info2 = obj2;
            BMKMapPoint point1 = BMKMapPointForCoordinate(info1.pt);
            BMKMapPoint point2 = BMKMapPointForCoordinate(info2.pt);
            BMKMapPoint point3 = BMKMapPointForCoordinate(result.location);
            double meters1 = BMKMetersBetweenMapPoints(point3, point1);
            double meters2 = BMKMetersBetweenMapPoints(point3, point2);
            return (meters1 < meters2)?NSOrderedAscending:NSOrderedDescending;
        }];
        
        NSUInteger maxNumPoiAddress = 2;
        for(BMKPoiInfo *info in poiS) {
            if(maxNumPoiAddress > 0) {
                maxNumPoiAddress--;
                BMKMapPoint point1 = BMKMapPointForCoordinate(info.pt);
                BMKMapPoint point2 = BMKMapPointForCoordinate(result.location);
                CLLocationDistance meters = BMKMetersBetweenMapPoints(point2, point1);
                NSString *address = [NSString stringWithFormat:@"\n%@%.0f%@", info.name, meters, localizedString(@"meters")];
                self.deviceAddress = [self.deviceAddress stringByAppendingString:address];
            }
        }
        
    }else {
        
        self.deviceAddress = @"No address";
        
    }
    
    self.getAddressReqFinshed = YES;
}

#pragma mark - public methods
///获取设备列表
- (void)getDevicesList {
    
    self.isGetDevicesFinshed = NO;
    self.msg = nil;
    
    [YLDAPIManager getDevicesSuccess:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        if(r){
            NSArray *devices = responseObject[@"dt"];
            [YLDDataManager manager].devices = [NSMutableArray arrayWithArray:devices];
        }
        NSString *msg = responseObject[@"msg"];
        self.msg = msg;
        self.isGetDevicesFinshed = YES;
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.isGetDevicesFinshed = YES;
    }];
    
}

///检查版本更新
- (void)checkAppUpdate{
    NSString *ver = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    [YLDAPIManager checkUpdateWithAppBuild:ver success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        if(r){
            NSString *appUrl = responseObject[@"app_url"];
            BOOL hasNew = [responseObject[@"has_new"] boolValue];
            NSString *releaesLog = responseObject[@"release_log"];
            self.appUrl = appUrl;
            self.releaseLog = releaesLog;
            self.hasNewVer = hasNew;
        }
    } fail:^(NSError *error) {
        
    }];
}

///获取广告信息
- (void)getADInfo {
    
    self.isGetADinfoFinshed = NO;
    
    NSString *pushID = [JPUSHService registrationID];
    (pushID.length <= 0)?(pushID = @""):0;
    
    YLDUserData *userData = [YLDDataManager manager].userData;
    
    [YLDAPIManager loginWithAccount:userData.userName passWord:userData.passWord pushID:pushID success:^(id responseObject) {
        
        NSDictionary *ad = responseObject[@"ad"];
        NSString *img = ad[@"img"];
        NSString *url = ad[@"url"];
        
        if(img.length > 0) {
            ADInfo *info = [[ADInfo alloc] init];
            info.imgUrl = img;
            info.webUrl = url;
            info.imgUrl = nilString2Empty(info.imgUrl);
            info.webUrl = nilString2Empty(info.webUrl);
            self.adInfo = info;
        }
        
        self.isGetADinfoFinshed = YES;
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)getDeviceAddressWithCoor:(CLLocationCoordinate2D)coor {
    
    self.getAddressReqFinshed = NO;
    self.deviceAddress = nil;
    
    if([YLDDataManager manager].userData.userMapSelected == userMapBaidu) {
        
        geoCodeSearch.delegate = nil;
        geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        geoCodeSearch.delegate = self;
        BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
        reverseGeoCodeOption.reverseGeoPoint = coor;
        [geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
        
    }else {
        GMSGeocoder *geocoder = [[GMSGeocoder alloc] init];
        myGeocoder = geocoder;
        [geocoder reverseGeocodeCoordinate:coor completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
            
            if (geocoder == myGeocoder) {
                if(error == nil) {
                    
                    GMSAddress *firstResult = response.firstResult;
                    
                    NSString *country = firstResult.country;
                    NSString *administrativeArea = firstResult.administrativeArea;
                    NSString *locality = firstResult.locality;
                    NSString *subLocality = firstResult.subLocality;
                    NSString *thoroughfare = firstResult.thoroughfare;
                    
                    if(country.length <= 0) country = @"";
                    if(administrativeArea.length <= 0) administrativeArea = @"";
                    if(locality.length <= 0) locality = @"";
                    if(subLocality.length <= 0) subLocality = @"";
                    if(thoroughfare.length <= 0) thoroughfare = @"";
                    
                    self.deviceAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", country, administrativeArea, locality, subLocality, thoroughfare];
                    
                }else {
                    
                    self.deviceAddress = @"No address";
                    
                }
                
                self.getAddressReqFinshed = YES;
            }
            
        }];
        
    }
    
}

#pragma mark - getters and setters
- (void)setDevices:(NSMutableArray *)devices{
    _devices = devices;
}

- (NSMutableArray*)devices {
    _devices = [YLDDataManager manager].devices;
    return _devices;
}

- (void)setMsg:(NSString *)msg{
    _msg = msg;
}

- (void)setIsGetDevicesFinshed:(BOOL)isGetDevicesFinshed {
    _isGetDevicesFinshed = isGetDevicesFinshed;
}

- (void)setHasNewVer:(BOOL)hasNewVer{
    _hasNewVer = hasNewVer;
}

- (void)setAppUrl:(NSString *)appUrl{
    _appUrl = appUrl;
}

- (void)setReleaseLog:(NSString *)releaseLog{
    _releaseLog = releaseLog;
}

- (void)setGetAddressReqFinshed:(BOOL)getAddressReqFinshed {
    _getAddressReqFinshed = getAddressReqFinshed;
}

- (void)setDeviceAddress:(NSString *)deviceAddress {
    _deviceAddress = deviceAddress;
}

- (void)setCurrentDevice:(NSDictionary *)currentDevice {
    _currentDevice = currentDevice;
    if(_currentDevice != nil) {
        [YLDDataManager manager].currentDevice = _currentDevice;
    }
}

- (NSDictionary*)currentDevice {
    _currentDevice = [YLDDataManager manager].currentDevice;
    return _currentDevice;
}

- (NSString*)currentDeviceID {
    _currentDeviceID = [self.currentDevice[@"device_id"] stringValue];
    return _currentDeviceID;
}

- (NSString*)currentDeviceName {
    _currentDeviceName = self.currentDevice[@"nick_name"];
    return _currentDeviceName;
}

- (CLLocationCoordinate2D)currentDeviceCoor {
    NSDictionary *locationDic = self.currentDevice[@"location"];
    NSString *lonlat = locationDic[@"lonlat"];
    _currentDeviceCoor.latitude = [[lonlat componentsSeparatedByString:@","].lastObject floatValue];
    _currentDeviceCoor.longitude = [[lonlat componentsSeparatedByString:@","].firstObject floatValue];
    
    if([YLDDataManager manager].userData.userMapSelected == userMapBaidu) {
       _currentDeviceCoor = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(_currentDeviceCoor,BMK_COORDTYPE_GPS));
    }else {
        _currentDeviceCoor = transform(_currentDeviceCoor.latitude, _currentDeviceCoor.longitude);
    }
    return _currentDeviceCoor;
}

- (void)setAdInfo:(ADInfo *)adInfo {
    _adInfo = adInfo;
}

- (void)setIsGetADinfoFinshed:(BOOL)isGetADinfoFinshed {
    _isGetADinfoFinshed = isGetADinfoFinshed;
}

@end
