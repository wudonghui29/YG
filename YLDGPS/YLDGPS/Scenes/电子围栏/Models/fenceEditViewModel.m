//
//  fenceEditViewModel.m
//  YLDGPS
//
//  Created by user on 15/7/18.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "fenceEditViewModel.h"
#import "YLDCommon.h"

@implementation fenceEditViewModel
@synthesize remindRecevieViewModel = _remindRecevieViewModel;

#pragma mark - public methods
- (void)submitFence{
    NSString *fenceId = @"";
    NSString *fenceName = self.fenceName;
    NSString *enable = @"1";
    NSString *alarmRate = @"";
    switch (self.remindRecevieViewModel.receiveInterval) {
        case 0:
            alarmRate = @"5";
            break;
            
        case 1:
            alarmRate = @"10";
            break;
            
        case 2:
            alarmRate = @"15";
            break;
            
        case 3:
            alarmRate = @"30";
            break;
    }
    NSString *alarmLimit = @"";
    switch (self.remindRecevieViewModel.receiveTimes) {
        case 0:
            alarmLimit = @"1";
            break;
            
        case 1:
            alarmLimit = @"2";
            break;
            
        case 2:
            alarmLimit = @"3";
            break;
    }
    NSString *alarmType = @"1";
    switch (self.remindType) {
        case 0:
            alarmType = @"1";
            break;
            
        case 1:
            alarmType = @"2";
            break;
    }
    NSString *circleRadius = self.circleRadius;
    NSString *circleLonlat = self.circleLonlat;
    if(self.fenceDic != nil){
        fenceId = self.fenceDic[@"fence_id"];
    }
    [YLDAPIManager editFenceWithFenceID:fenceId deviceID:self.deviceID fenceName:fenceName enable:enable alarmRate:alarmRate alarmLimit:alarmLimit alarmType:alarmType alarmBySMS:@"" alarmByEmail:@"" alarmByCall:@"" circleRadius:circleRadius circleLonlat:circleLonlat success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.localizedFailureReason;
        self.r = -1;
    }];
}

#pragma mark - getters and setters
- (remindRecevieViewModel*)remindRecevieViewModel{
    if(_remindRecevieViewModel == nil){
        _remindRecevieViewModel = [[remindRecevieViewModel alloc] init];
    }
    return _remindRecevieViewModel;
}

- (void)setFenceDic:(NSDictionary *)fenceDic{
    _fenceDic = fenceDic;
    self.fenceName = _fenceDic[@"name"];
    NSDictionary *alarmDic = _fenceDic[@"alarm"];
    self.remindType = ([alarmDic[@"alarm_type"] integerValue] - 1);
    self.remindRecevieViewModel.fenceDic = self.fenceDic;
    NSDictionary *circleDic = _fenceDic[@"circle"];
    self.circleRadius = [circleDic[@"radius"] stringValue];
    NSString *lonlat = circleDic[@"lonlat"];
    NSString *lon = [lonlat componentsSeparatedByString:@","].firstObject;
    NSString *lat = [lonlat componentsSeparatedByString:@","].lastObject;
    NSInteger mapType = [fenceDic[@"map_type"] integerValue];
    CLLocationCoordinate2D coordinate = {0};
    coordinate.latitude = [lat doubleValue];
    coordinate.longitude = [lon doubleValue];
    if([YLDDataManager manager].userData.userMapSelected == userMapBaidu){
        if(mapType == 2){
            coordinate = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(coordinate,BMK_COORDTYPE_GPS));
        }
    }else if([YLDDataManager manager].userData.userMapSelected == userMapGoogle){
        if(mapType == 1){
            coordinate = baidu2google(coordinate);
        }
        
    }
    lon = [NSString stringWithFormat:@"%f", coordinate.longitude];
    lat = [NSString stringWithFormat:@"%f", coordinate.latitude];
    self.circleLonlat = [NSString stringWithFormat:@"%@,%@", lon, lat];
}

- (void)setR:(BOOL)r{
    _r = r;
}

- (void)setMsg:(NSString *)msg{
    _msg = msg;
}

- (void)setFenceName:(NSString *)fenceName{
    _fenceName = fenceName;
}

- (void)setRemindType:(NSInteger)remindType{
    _remindType = remindType;
}

- (void)setCircleRadius:(NSString *)circleRadius{
    _circleRadius = circleRadius;
}

- (void)setCircleLonlat:(NSString *)circleLonlat{
    _circleLonlat = circleLonlat;
}

@end
