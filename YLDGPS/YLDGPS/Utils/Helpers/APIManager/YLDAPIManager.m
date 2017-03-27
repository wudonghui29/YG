//
//  YLDAPIManager.m
//  YLDGPS
//
//  Created by user on 15/6/19.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "YLDAPIManager.h"
#import "YLDCommon.h"
#import <AFNetworking.h>

@implementation YLDAPIManager

+ (void)getJSONDataWithUrl:(NSString *)url parameters:(NSDictionary*)parameters retryTimes:(NSInteger)retryTimes success:(void (^)(id json))success fail:(void (^)(NSError *error))fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success != nil) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(retryTimes > 0){
            [self getJSONDataWithUrl:url parameters:parameters retryTimes:(retryTimes - 1) success:success fail:fail];
        }else{
            NSLog(@"getJSON parameters:%@\n fail:%@\n", parameters, error);
            if (fail != nil) {
                fail(error);
            }
        }
    }];
//    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"getJSON parameters:%@\n success:%@\n", parameters, responseObject);
//        if (success != nil) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if(retryTimes > 0){
//            [self getJSONDataWithUrl:url parameters:parameters retryTimes:(retryTimes - 1) success:success fail:fail];
//        }else{
//            NSLog(@"getJSON parameters:%@\n fail:%@\n", parameters, error);
//            if (fail != nil) {
//                fail(error);
//            }
//        }
//    }];
}

+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(NSDictionary*)parameters retryTimes:(NSInteger)retryTimes success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success != nil) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(retryTimes > 0){
            [self postJSONWithUrl:urlStr parameters:parameters retryTimes:(retryTimes - 1) success:success fail:fail];
        }else{
            NSLog(@"postJSON parameters:%@\n fail:%@\n", parameters, error);
            if (fail != nil) {
                fail(error);
            }
        }
    }];

}

+ (void)getJSONDataWithUrl:(NSString *)url parameters:(NSDictionary*)parameters success:(void (^)(id json))success fail:(void (^)(NSError *error))fail{
    [self getJSONDataWithUrl:url parameters:parameters retryTimes:3 success:success fail:fail];
}

+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(NSDictionary*)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    [self postJSONWithUrl:urlStr parameters:parameters retryTimes:3 success:success fail:fail];
}

+ (NSString*)t {
    return [NSString stringWithFormat:@"%.0ff", [NSDate date].timeIntervalSince1970*1000];
}

+ (NSString*)signature {
    return md5([NSString stringWithFormat:@"%@yulongda", [self t]]);
}

+ (NSString*)lang{
    NSString *langStr = @"en";
    if([getAppLanguage() isEqualToString:@"zh-Hans"]){
        langStr = @"zh-cn";
    }
    return langStr;
}

///项目ID
+ (NSString*)pid{
    return @"200";
}

+ (NSDictionary*)phoneInfo {
    return [[NSBundle mainBundle] infoDictionary];
}

///APP版本号
+ (NSString*)appBuild {
    return [self phoneInfo][@"CFBundleShortVersionString"];
}

///操作系统版本
+ (NSString*)sysVer {
    return [NSString stringWithFormat:@"%f", systemVersion];
}

///机型
+ (NSString*)phoneModel {
    return [[UIDevice currentDevice] model];
}

///联网方式
+ (NSString*)netType {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = @"无网络";
    int netType = 0;
    
    for (id child in children) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (netType) {
                case 1:
                    state = @"2G";
                    break;
                    
                case 2:
                    state = @"3G";
                    break;
                    
                case 3:
                    state = @"4G";
                    break;
                    
                case 5:
                    state = @"WIFI";
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
        
    }
    
    return state;
}

+ (NSMutableDictionary*)fixParametersWithDic:(NSDictionary*)dic{
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic1 setObject:[self signature]    forKey:@"signature"];
    [dic1 setObject:[self t]            forKey:@"t"];
    [dic1 setObject:[self pid]          forKey:@"pid"];
    [dic1 setObject:[self appBuild]     forKey:@"app_build"];
    [dic1 setObject:[self sysVer]       forKey:@"sys_ver"];
    [dic1 setObject:[self phoneModel]   forKey:@"model"];
    [dic1 setObject:[self netType]      forKey:@"net_type"];
    [dic1 setObject:[self lang]         forKey:@"lang"];
    return dic1;
}

///登入 (1号接口)
+ (void)loginWithAccount:(NSString*)account passWord:(NSString*)passWord pushID:(NSString*)pushID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"1",kSeverVer];
    NSDictionary *parameters = @{@"account"     :account,
                                 @"password"    :passWord,
                                 @"push_id"     :pushID};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///获取设备信息 (2号接口) objectID 1:位置明细,2:设备明细
+ (void)getDeviceWithDeviceID:(NSString*)deviceID objectID:(NSString*)objectID  Success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"2",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID,
                                 @"object_id":objectID};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///获取设备列表 (3号接口)
+ (void)getDevicesSuccess:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"3",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///添加设备 （4号接口）
+ (void)addDeviceWithDeviceID:(NSString*)deviceID password:(NSString*)password success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"4",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID,
                                 @"password":password};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///删除设备 （5号接口）
+ (void)deleteDeviceWithDeviceID:(NSString*)deviceID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"5",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///设备开关控制 （6号接口）
///objectID 1:电话监听开关,2:断油断电开关,3:工作模式选择，4:GPS开关,5:超速开关,6:低电开关,7:设防撤防开关,8:震动报警开关,9:SOS报警模式,10:ACC报警开关,11:重启,12:恢复出厂设置,13:断电报警开关
///14:宠物灯
+ (void)setDeviceSwitchWithDeviceID:(NSString*)deviceID  objectID:(NSString*)objectID onoff:(NSString*)onoff related:(NSString*)related success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    if(![related isKindOfClass:[NSString class]]) related = @"{}";
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"6",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID,
                                 @"object_id":objectID,
                                 @"onoff":onoff,
                                 @"related":related};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

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
+ (void)deviceConfigModifWithDeviceID:(NSString*)deviceID  objectID:(NSString*)objectID related:(NSString*)related success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"7",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID,
                                 @"object_id":objectID,
                                 @"related":related};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///报警信息列表 （8号接口）
/*!**********************************
 *cate_id 报警类型[0:All，1:围栏,2:低电,3:超速]
 **********************************!*/
+ (void)getWarningMsgWithCateID:(NSString*)cateID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"8",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"cate_id":cateID};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}


///亲情号码 （9号接口）
/*!**********************************
 *cateID 0:查询,1:新增,2:修改,3:删除
 **********************************!*/
+ (void)familyNumsWithDeviceID:(NSString*)deviceID familyNums:(NSString*)familyNums cateID:(NSString*)catID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"9",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID,
                                 @"cate_id":catID,
                                 @"family_num":familyNums};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///SOS号码 （10号接口）
/*!**********************************
 *cateID 0:查询,1:新增,2:修改,3:删除
 **********************************!*/
+ (void)sosNumsWithDeviceID:(NSString*)deviceID sosNums:(NSString*)sosNums cateID:(NSString*)catID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"10",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID,
                                 @"cate_id":catID,
                                 @"sos_num":sosNums};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///电子围栏查询 （11号接口）
+ (void)getFenceWithDeviceID:(NSString*)deviceID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"11",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///电子围栏新增/编辑 （12号接口）
+ (void)editFenceWithFenceID:(NSString*)fenceID deviceID:(NSString*)deviceID fenceName:(NSString*)fenceName enable:(NSString*)enable alarmRate:(NSString*)alarmRate alarmLimit:(NSString*)alarmLimit alarmType:(NSString*)alarmType alarmBySMS:(NSString*)alarmBySMS alarmByEmail:(NSString*)alarmByEmail alarmByCall:(NSString*)alarmByCall circleRadius:(NSString*)circleRadius circleLonlat:(NSString*)circleLonlat success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"12",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID,
                                 @"fence_id":fenceID,
                                 @"name":fenceName,
                                 @"status":enable,
                                 @"alarm_rate":alarmRate,
                                 @"alarm_limit":alarmLimit,
                                 @"alarm_type":alarmType,
                                 @"alarm_by_sms":alarmBySMS,
                                 @"alarm_by_email":alarmByEmail,
                                 @"alarm_by_call":alarmByCall,
                                 @"circle_radius":circleRadius,
                                 @"circle_lonlat":circleLonlat,
                                 @"map_type":[NSString stringWithFormat:@"%ld", (long)[YLDDataManager manager].userData.userMapSelected]};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///电子围栏查询 （13号接口）status -1 删除 0停用 1启用
+ (void)deleteOrEnableFenceWithDeviceID:(NSString*)deviceID fenceID:(NSString*)fenceID status:(NSString*)status success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"13",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID,
                                 @"fence_id":fenceID,
                                 @"status":status};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///轨迹查询 （14号接口）
+ (void)getDeviceTrackWithDeviceID:(NSString*)deviceID filterLBS:(NSString*)filterLBS beginTime:(NSString*)beginTime endTime:(NSString*)endTime success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"14",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"device_id":deviceID,
                                 @"sign":filterLBS,
                                 @"begin_time":beginTime,
                                 @"end_time":endTime};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///版本更新检查 （15号接口）
+ (void)checkUpdateWithAppBuild:(NSString*)deviceID success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"15",kSeverVer];
    NSString *accountID = [YLDDataManager manager].userData.accountID;
    NSDictionary *parameters = @{@"account_id":accountID,
                                 @"app_build":deviceID};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

///修改密码（17号接口）
+ (void)changePasswordWithOldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail {
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",kSeverAddress,@"17",kSeverVer];
    NSString *userName = [YLDDataManager manager].userData.userName;
    NSDictionary *parameters = @{@"account":userName,
                                 @"old_password":oldPassword,
                                 @"password":newPassword};
    parameters = [self fixParametersWithDic:parameters];
    [YLDAPIManager getJSONDataWithUrl:url parameters:parameters success:^(id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } fail:^(NSError *error){
        if (fail != nil) {
            fail(error);
        }
    }];
}

@end
