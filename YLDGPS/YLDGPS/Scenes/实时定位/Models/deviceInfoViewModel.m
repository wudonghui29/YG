//
//  deviceInfoViewModel.m
//  YLDGPS
//
//  Created by user on 15/7/11.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "deviceInfoViewModel.h"
@interface deviceInfoViewModel()<BMKGeoCodeSearchDelegate>{
    BMKGeoCodeSearch *geoCodeSearch;
    GMSGeocoder *myGeocoder;
}


@end
@implementation deviceInfoViewModel

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


///刷新数据
- (void)refreshData {
    
    [YLDAPIManager getDevicesSuccess:^(id responseObject) {
        
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        
        if(r){
            
            NSArray *devices = responseObject[@"dt"];
            [YLDDataManager manager].devices = [NSMutableArray arrayWithArray:devices];
            
            [self getDeviceInfoWithDic:nil];
            
        }
        
        self.msg = msg;
        self.r = r;
        
    } fail:^(NSError *error) {
        
        self.msg = error.localizedDescription;
        self.r = NO;
        
    }];
    
}

///设防、撤防
- (void)setDefendonoff:(BOOL)onoff {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"7" onoff:onoff?@"1":@"0" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
           self.isDefend = !self.isDefend;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///电话监听
- (void)phoneCallBack {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"1" onoff:@"1" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.isMonitorMoblieOn = !self.isMonitorMoblieOn;
            msg = localizedString(@"commandHasBeenSent");
        }
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///断油断电
- (void)setOilPoweronoff:(BOOL)onoff {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"2" onoff:onoff?@"1":@"0" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.isACC = !self.isACC;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///SOS报警模式
- (void)setSOSAlarmMode:(NSInteger)mode {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"9" onoff:[NSString stringWithFormat:@"%d", (int)mode] related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.SOSAlarmModel = mode;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///震动报警
- (void)setVibrationAlarmonoff:(BOOL)onoff {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"8" onoff:onoff?@"1":@"0" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.isVibrationAlarmOn = !self.isVibrationAlarmOn;
        }
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///ACC报警
- (void)setACCAlarmonoff:(BOOL)onoff {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"10" onoff:onoff?@"1":@"0" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.isACCAlarmOn = !self.isACCAlarmOn;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///重启
- (void)restart {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"11" onoff:@"1" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            msg = localizedString(@"commandHasBeenSent");
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///恢复出产设置
- (void)factoryReset {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"12" onoff:@"1" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            msg = localizedString(@"commandHasBeenSent");
        }
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///断电报警
- (void)setPowerOffonoff:(BOOL)onoff {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"13" onoff:onoff?@"1":@"0" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.isPowerOffAlarmOn = !self.isPowerOffAlarmOn;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///超速报警
- (void)setOverspeedonAlarmOnoff:(BOOL)onoff {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"5" onoff:onoff?@"1":@"0" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.isOverspeedAlarmOn = !self.isOverspeedAlarmOn;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///设置超速速度
- (void)setOverspeedWithValue:(NSInteger)value {
    NSString *related = [NSString stringWithFormat:@"{speed:%ld}", (long)value];
    [YLDAPIManager deviceConfigModifWithDeviceID:self.deviceID objectID:@"3" related:related success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.overspeed = value;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.description;
        self.r = NO;
    }];
}

///设置设备上传频率
- (void)setDeviceUploadRateWithMinute:(NSInteger)minute {
    NSString *related = [NSString stringWithFormat:@"{loop:%ld}", (long)minute];
    [YLDAPIManager deviceConfigModifWithDeviceID:self.deviceID objectID:@"2" related:related success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.deviceUploadRate = minute;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.description;
        self.r = NO;
    }];
}

///设置工作模式 1:正常模式,2:一般省电,3:超长省电 {work_time:9030, app_time:2300, sleep:20}   //定时启动时间9:30 工作20分钟 app_time 参考值
- (void)setWorkMode:(NSInteger)mode starTime:(NSString*)starTime workTime:(NSString*)workTime {
    
    NSString *onoff = @"1";
    NSString *related = @"";
    
    if(mode == 2) {
        onoff = @"2";
    }else if(mode == 3) {
        onoff = @"3";
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *str = [dateFormatter stringFromDate:date];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *str1 = [dateFormatter stringFromDate:date];
        
        str = [str stringByAppendingString:@" 00:00"];
        NSDate *date1 = [dateFormatter dateFromString:str];
        NSDate *date2 = [dateFormatter dateFromString:str1];
        
        NSTimeInterval timeInterval = date2.timeIntervalSinceNow - date1.timeIntervalSinceNow;
        NSInteger hourInt = timeInterval/60/60;
        
        NSArray *dateArr = [str1 componentsSeparatedByString:@":"];
        NSString *hour = [NSString stringWithFormat:@"%d", (int)hourInt];
        NSString *minute = dateArr.lastObject;
        
        NSString *appTime = [NSString stringWithFormat:@"%02d%02d", (int)hour.integerValue, (int)minute.integerValue];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"work_time" : starTime,
                                                                     @"app_time"  : appTime,
                                                                     @"sleep"     : @(workTime.integerValue)}
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        
        related = [[NSString alloc] initWithData:jsonData
                                        encoding:NSUTF8StringEncoding];
    }
    
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"3" onoff:onoff related:related success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.starTime = starTime;
            self.workTime = workTime;
            self.workMode = mode;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///设置低电量警报开关
- (void)setLowPowerWarningonoff:(BOOL)onoff {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"6" onoff:onoff?@"1":@"0" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.isLowPowerAlarmOn = !self.isLowPowerAlarmOn;
        }
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.description;
        self.r = NO;
    }];
}

///宠物灯
- (void)setPetLightOnoff:(BOOL)onoff {
    [YLDAPIManager setDeviceSwitchWithDeviceID:self.deviceID objectID:@"14" onoff:onoff?@"1":@"0" related:nil success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.isPetLightOn = !self.isPetLightOn;
        }
        self.msg = msg;
        self.r = r;
        [self refreshData];
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

- (void)getDeviceAddressWithCoor:(CLLocationCoordinate2D)coor {
    
    self.getAddressReqFinshed = NO;
    self.deviceAddress = nil;
    
    if([YLDDataManager manager].userData.userMapSelected == userMapBaidu) {
        
        geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        geoCodeSearch.delegate = self;
        BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
        reverseGeoCodeOption.reverseGeoPoint = coor;
        [geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
        
    }else {
        
        GMSReverseGeocodeCallback callBack = ^(GMSReverseGeocodeResponse *response, NSError *error) {
            
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
            
        };
        
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coor completionHandler:callBack];
        
    }
}

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

#pragma mark - private methods
- (void)getDeviceInfoWithDic:(NSDictionary*)aDic {
    
    NSDictionary *dic = aDic;
    
    if(dic == nil){
        for(NSDictionary *dic1 in [YLDDataManager manager].devices){
            NSString *deviceID = [dic1[@"device_id"] stringValue];
            NSString *d = self.deviceID;
            NSLog(@"deviceID:%@",deviceID);
            NSLog(@"d:%@",d);
            if([deviceID isEqualToString:self.deviceID]) {
                dic = dic1;
                break;
            }
        }
    }
    
    if(dic != nil){
        NSDictionary *locationDic = dic[@"location"];
        NSString *headIcon = dic[@"head_icon"];
        NSString *name = dic[@"nick_name"];
        NSString *imeiStr = [dic[@"imei"] stringValue];
        BOOL isOnline = [dic[@"online"] boolValue];
        NSString *status = isOnline?localizedString(@"online"):localizedString(@"offline");
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([locationDic[@"time"] floatValue]/1000)];
        
        NSString *time = [formatter stringFromDate:date];
        NSString *speed = [locationDic[@"speed"] stringValue];
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

        
        
        NSDictionary *statusDic = dic[@"status"];
        BOOL is_defend = [statusDic[@"is_defend"] boolValue];
        BOOL acc = [statusDic[@"acc"] boolValue];
        BOOL shake_warn = [statusDic[@"shake_warn"] boolValue];
        NSInteger sos_mode = [statusDic[@"sos_mode"] integerValue];
        BOOL acc_warn = [statusDic[@"acc_warn"] boolValue];
        BOOL nopower_warn = [statusDic[@"nopower_warn"] boolValue];
        NSString *power = statusDic[@"power"];
        NSInteger top_speed = [statusDic[@"top_speed"] integerValue];
        NSInteger loop = [statusDic[@"loop"] integerValue];
        NSDictionary *workModeDic = statusDic[@"work_mode"];
        NSInteger workMode = [workModeDic[@"mode"] integerValue];
        NSString *starTime = workModeDic[@"work_time"];
        NSString *workTime = workModeDic[@"sleep"];
        BOOL lowpower_warn = [statusDic[@"lowpower_warn"] boolValue];
        BOOL MonitorMode = [statusDic[@"call_monitor"] boolValue];
        BOOL overspeed_warn = [statusDic[@"overspeed_warn"] boolValue];
        BOOL pet_lamp = [statusDic[@"pet_lamp"] boolValue];
        
        
        
        self.headIconUrl = headIcon;
        self.deviceName = name;
        self.deviceIMEI = imeiStr;
        self.deviceStauts = status;
        self.deviceAddress = address;
        self.address = address;
        self.deviceSpeed = speed;
        self.deviceLocation = lonlat;
        self.isDefend = is_defend;
        self.isACC = acc;
        self.isVibrationAlarmOn = shake_warn;
        self.SOSAlarmModel = sos_mode;
        self.isACCAlarmOn = acc_warn;
        self.isPowerOffAlarmOn = nopower_warn;
        self.overspeed = top_speed;
        self.deviceUploadRate = loop;
        self.power = power;
        self.locWay = locWayString;
        self.bds = bds;
        self.workMode = workMode;
        self.starTime = starTime;
        self.workTime = workTime;
        self.isLowPowerAlarmOn = lowpower_warn;
        self.isMonitorMoblieOn = MonitorMode;
        self.isOverspeedAlarmOn = overspeed_warn;
        self.isPetLightOn = pet_lamp;
        self.time = time;
        CLLocationCoordinate2D coor = {0};
        coor.latitude = [[lonlat componentsSeparatedByString:@","].lastObject floatValue];
        coor.longitude = [[lonlat componentsSeparatedByString:@","].firstObject floatValue];
        
        if([YLDDataManager manager].userData.userMapSelected == userMapBaidu){
            coor = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS));
        }else{
            coor = transform(coor.latitude, coor.longitude);
        }
        [self getDeviceAddressWithCoor:coor];
    }
    
}

#pragma mark - getters and setters
- (void)setIsGetDevicesFinshed:(BOOL)isGetDevicesFinshed {
    _isGetDevicesFinshed = isGetDevicesFinshed;
}

- (void)setDeviceID:(NSString*)deviceID {
    _deviceID = deviceID;
    [self getDeviceInfoWithDic:nil];
}

- (void)setHeadIconUrl:(NSString *)headIconUrl{
    _headIconUrl = headIconUrl;
}

- (void)setDeviceName:(NSString *)deviceName{
    _deviceName = deviceName;
}

- (void)setDeviceIMEI:(NSString *)deviceIMEI{
    _deviceIMEI = deviceIMEI;
}

- (void)setDeviceStauts:(NSString *)deviceStauts{
    _deviceStauts = deviceStauts;
}

- (void)setDeviceAddress:(NSString *)deviceAddress{
    _deviceAddress = deviceAddress;
}
- (void)setAddress:(NSString *)address{
    _address = address;
}
- (void)setLocWay:(NSString *)locWay {
    _locWay = locWay;
}

- (void)setBds:(NSNumber *)bds {
    _bds = bds;
}

- (void)setPower:(NSString *)power {
    _power = power;
}

- (void)setDeviceSpeed:(NSString *)deviceSpeed{
    _deviceSpeed = deviceSpeed;
}

- (void)setDeviceLocation:(NSString *)deviceLocation{
    _deviceLocation = deviceLocation;
}

- (void)setR:(BOOL)r{
    _r = r;
}

- (void)setMsg:(NSString *)msg{
    _msg = msg;
}

- (void)setIsDefend:(BOOL)isDefend {
    _isDefend = isDefend;
}

- (void)setIsACC:(BOOL)isACC {
    _isACC = isACC;
}

- (void)setIsVibrationAlarmOn:(BOOL)isVibrationAlarmOn {
    _isVibrationAlarmOn = isVibrationAlarmOn;
}

- (void)setIsACCAlarmOn:(BOOL)isACCAlarmOn {
    _isACCAlarmOn = isACCAlarmOn;
}

- (void)setSOSAlarmModel:(NSInteger)SOSAlarmModel {
    _SOSAlarmModel = SOSAlarmModel;
}

- (void)setIsPowerOffAlarmOn:(BOOL)isPowerOffAlarmOn {
    _isPowerOffAlarmOn = isPowerOffAlarmOn;
}

- (void)setIsOverspeedAlarmOn:(BOOL)isOverspeedAlarmOn {
    _isOverspeedAlarmOn = isOverspeedAlarmOn;
}

- (void)setOverspeed:(NSInteger)overspeed{
    _overspeed = overspeed;
}

- (void)setDeviceUploadRate:(NSInteger)deviceUploadRate{
    _deviceUploadRate = deviceUploadRate;
}

- (void)setWorkMode:(NSInteger)workMode {
    _workMode = workMode;
}

- (void)setStarTime:(NSString *)starTime {
    if(![starTime isKindOfClass:[NSString class]]) {
        starTime = [((id)starTime) stringValue];
    }
    _starTime = starTime;
}

- (void)setWorkTime:(NSString *)workTime {
    if(![workTime isKindOfClass:[NSString class]]) {
        workTime = [((id)workTime) stringValue];
    }
    _workTime = workTime;
}

- (void)setIsLowPowerAlarmOn:(BOOL)isLowPowerAlarmOn {
    _isLowPowerAlarmOn = isLowPowerAlarmOn;
}

- (void)setIsMonitorMoblieOn:(BOOL)isMonitorMoblieOn {
    _isMonitorMoblieOn = isMonitorMoblieOn;
}

- (void)setIsPetLightOn:(BOOL)isPetLightOn {
    _isPetLightOn = isPetLightOn;
}

- (void)setGetAddressReqFinshed:(BOOL)getAddressReqFinshed {
    _getAddressReqFinshed = getAddressReqFinshed;
}

@end
