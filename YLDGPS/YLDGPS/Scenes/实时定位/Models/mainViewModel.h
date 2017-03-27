//
//  mainViewModel.h
//  YLDGPS
//
//  Created by user on 15/7/4.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLDCommon.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@class ADInfo;

@interface mainViewModel : NSObject <BMKGeoCodeSearchDelegate>
@property (nonatomic, strong, readonly) NSMutableArray                  *devices;
@property (nonatomic, assign, readonly) BOOL                            isGetDevicesFinshed;
@property (nonatomic, assign, readonly) BOOL                            hasNewVer;
@property (nonatomic, copy, readonly) NSString                          *appUrl;
@property (nonatomic, copy, readonly) NSString                          *releaseLog;
@property (nonatomic, copy, readonly) NSString                          *msg;
@property (nonatomic, copy) NSDictionary                                *currentDevice;
@property (nonatomic, copy, readonly) NSString                          *currentDeviceID;
@property (nonatomic, copy, readonly) NSString                          *currentDeviceName;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D          currentDeviceCoor;
@property (nonatomic, copy, readonly) NSString                          *deviceAddress;
@property (nonatomic, assign, readonly) BOOL                            getAddressReqFinshed;
@property (nonatomic, strong, readonly) ADInfo                          *adInfo;
@property (nonatomic, assign, readonly) BOOL                            isGetADinfoFinshed;

///获取设备列表
- (void)getDevicesList;
///检查版本更新
- (void)checkAppUpdate;
///获取广告信息
- (void)getADInfo;
///获取设备地址
- (void)getDeviceAddressWithCoor:(CLLocationCoordinate2D)coor;
@end
