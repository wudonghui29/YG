//
//  deviceInfoViewModel.h
//  YLDGPS
//
//  Created by user on 15/7/11.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLDCommon.h"

@interface deviceInfoViewModel : NSObject
@property (nonatomic, copy) NSString                  *deviceID;
@property (nonatomic, copy, readonly) NSString        *headIconUrl;
@property (nonatomic, copy, readonly) NSString        *deviceName;
@property (nonatomic, copy, readonly) NSString        *deviceIMEI;
@property (nonatomic, copy, readonly) NSString        *deviceStauts;
@property (nonatomic, copy, readonly) NSString        *deviceAddress;
@property (nonatomic, copy, readonly) NSString        *address;

@property (nonatomic, copy, readonly) NSString        *deviceSpeed;
@property (nonatomic, copy, readonly) NSString        *locWay;
@property (nonatomic, copy, readonly) NSNumber        *bds;
@property (nonatomic, copy, readonly) NSString        *power;
@property (nonatomic, copy, readonly) NSString        *deviceLocation;
@property (nonatomic, assign ,readonly) BOOL          isDefend;
@property (nonatomic, assign ,readonly) BOOL          isACC;
@property (nonatomic, assign ,readonly) BOOL          isMonitorMoblieOn;
@property (nonatomic, assign ,readonly) BOOL          isVibrationAlarmOn;
@property (nonatomic, assign ,readonly) BOOL          isACCAlarmOn;
@property (nonatomic, assign ,readonly) NSInteger     SOSAlarmModel;
@property (nonatomic, assign ,readonly) BOOL          isPowerOffAlarmOn;
@property (nonatomic, assign ,readonly) BOOL          isOverspeedAlarmOn;
///超速速度
@property (nonatomic, assign, readonly) NSInteger     overspeed;
///设备上传频率
@property (nonatomic, assign, readonly) NSInteger     deviceUploadRate;
@property (nonatomic, assign ,readonly) NSInteger     workMode;
@property (nonatomic, copy ,readonly) NSString        *starTime;
@property (nonatomic, copy ,readonly) NSString        *workTime;
@property (nonatomic, copy ) NSString        *time;
@property (nonatomic, assign ,readonly) BOOL          isLowPowerAlarmOn;
@property (nonatomic, assign ,readonly) BOOL          isPetLightOn;
@property (nonatomic, assign ,readonly) BOOL          r;
@property (nonatomic, copy, readonly) NSString        *msg;
@property (nonatomic, assign, readonly) BOOL          getAddressReqFinshed;
@property (nonatomic, assign, readonly) BOOL                            isGetDevicesFinshed;


// wu
- (void)getDevicesList;
//end
///刷新数据
- (void)refreshData;
///设防、撤防
- (void)setDefendonoff:(BOOL)onoff;
///电话回拨
- (void)phoneCallBack;
///断油断电
- (void)setOilPoweronoff:(BOOL)onoff;
///震动报警
- (void)setVibrationAlarmonoff:(BOOL)onoff;
///SOS报警模式 1：短信报警、2：电话报警
- (void)setSOSAlarmMode:(NSInteger)mode;
///ACC报警
- (void)setACCAlarmonoff:(BOOL)onoff;
///重启
- (void)restart;
///恢复出产设置
- (void)factoryReset;
///断电报警
- (void)setPowerOffonoff:(BOOL)onoff;
///设置超速速度
- (void)setOverspeedonAlarmOnoff:(BOOL)onoff;
///设置超速速度
- (void)setOverspeedWithValue:(NSInteger)value;
///设置设备上传频率
- (void)setDeviceUploadRateWithMinute:(NSInteger)minute;
///设置工作模式 1:正常模式,2:一般省电,3:超长省电 {work_time:9030, app_time:2300, sleep:20}   //定时启动时间9:30 工作20分钟 app_time 参考值
- (void)setWorkMode:(NSInteger)mode starTime:(NSString*)starTime workTime:(NSString*)workTime;
///设置低电量警报开关
- (void)setLowPowerWarningonoff:(BOOL)onoff;
///宠物灯开关
- (void)setPetLightOnoff:(BOOL)onoff;
@end
