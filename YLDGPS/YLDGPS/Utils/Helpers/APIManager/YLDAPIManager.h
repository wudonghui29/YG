//
//  YLDAPIManager.h
//  YLDGPS
//
//  Created by user on 15/6/19.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDAPIManager : NSObject

+ (void)getJSONDataWithUrl:(NSString *)url parameters:(NSDictionary*)parameters success:(void (^)(id json))success fail:(void (^)(NSError *error))fail;

+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(NSDictionary*)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///登入 (1号接口)
+ (void)loginWithAccount:(NSString*)account passWord:(NSString*)passWord pushID:(NSString*)pushID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///获取设备信息 (2号接口) objectID 1:位置明细,2:设备明细
+ (void)getDeviceWithDeviceID:(NSString*)deviceID objectID:(NSString*)objectID  Success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///获取设备列表 (3号接口)
+ (void)getDevicesSuccess:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///添加设备 （4号接口）
+ (void)deleteDeviceWithDeviceID:(NSString*)deviceID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///删除设备 （5号接口）
+ (void)addDeviceWithDeviceID:(NSString*)deviceID password:(NSString*)password success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///设备开关控制 （6号接口）
///objectID 1:电话监听开关,2:断油断电开关,3:工作模式选择，4:GPS开关,5:超速开关,6:低电开关,7:设防撤防开关,8:震动报警开关,9:SOS报警模式,10:ACC报警开关,11:重启,12:恢复出厂设置,13:断电报警开关
///14:宠物灯
+ (void)setDeviceSwitchWithDeviceID:(NSString*)deviceID  objectID:(NSString*)objectID onoff:(NSString*)onoff related:(NSString*)related success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///设备配置修改 （7号接口）
/*!**********************************
 *objectID 1:IP配置,2:设备上传频率,3: 超速速度
 *
 *related object_id=1：
 *related:{ip:192.168.1.1}   //设置IP
 *object_id=2：
 *related:{loop:5}          //设备上传频率（分钟）
 *选项：5/10/15/30
 *object_id=3：
 *related:{speed:120}       //设置超速速度
 *选项：80/90/100/110/120/130
 *
 **********************************!*/
+ (void)deviceConfigModifWithDeviceID:(NSString*)deviceID  objectID:(NSString*)objectID related:(NSString*)related success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///报警信息列表 （8号接口）
/*!**********************************
 *cate_id 报警类型[0:All，1:围栏,2:低电,3:超速]
 **********************************!*/
+ (void)getWarningMsgWithCateID:(NSString*)cateID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///亲情号码 （9号接口）
/*!**********************************
 *cateID 0:查询,1:新增,2:修改,3:删除
 **********************************!*/
+ (void)familyNumsWithDeviceID:(NSString*)deviceID familyNums:(NSString*)familyNums cateID:(NSString*)catID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///SOS号码 （10号接口）
/*!**********************************
 *cateID 0:查询,1:新增,2:修改,3:删除
 **********************************!*/
+ (void)sosNumsWithDeviceID:(NSString*)deviceID sosNums:(NSString*)sosNums cateID:(NSString*)catID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///电子围栏查询 （11号接口）
+ (void)getFenceWithDeviceID:(NSString*)deviceID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///电子围栏新增/编辑 （12号接口）
+ (void)editFenceWithFenceID:(NSString*)fenceID deviceID:(NSString*)deviceID fenceName:(NSString*)fenceName enable:(NSString*)enable alarmRate:(NSString*)alarmRate alarmLimit:(NSString*)alarmLimit alarmType:(NSString*)alarmType alarmBySMS:(NSString*)alarmBySMS alarmByEmail:(NSString*)alarmByEmail alarmByCall:(NSString*)alarmByCall circleRadius:(NSString*)circleRadius circleLonlat:(NSString*)circleLonlat success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///电子围栏查询 （13号接口）status -1 删除 0停用 1启用
+ (void)deleteOrEnableFenceWithDeviceID:(NSString*)deviceID fenceID:(NSString*)fenceID status:(NSString*)status success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///轨迹查询 （14号接口）
+ (void)getDeviceTrackWithDeviceID:(NSString*)deviceID filterLBS:(NSString*)filterLBS beginTime:(NSString*)beginTime endTime:(NSString*)endTime success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///版本更新检查 （15号接口）
+ (void)checkUpdateWithAppBuild:(NSString*)deviceID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

///修改密码（17号接口）
+ (void)changePasswordWithOldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;
@end
