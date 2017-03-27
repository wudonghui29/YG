//
//  YLDDataManager.h
//  YLDGPS
//
//  Created by user on 15/6/19.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

///用户地图选择
typedef NS_ENUM(NSInteger, userMapSelected){
    userMapBaidu   = 1,
    userMapGoogle  = 2
};

///追踪刷新间隔 （5、10、15、30秒）
typedef NS_ENUM(NSInteger, traceRefreshTime){
    traceRefresh5   = 0,
    traceRefresh10  = 1,
    traceRefresh15  = 2,
    traceRefresh30  = 3,
};

///首页刷新间隔 （30、40、50、60秒）
typedef NS_ENUM(NSInteger, mainRefreshTime){
    mainRefresh30   = 0,
    mainRefresh40   = 1,
    mainRefresh50   = 2,
    mainRefresh60   = 3,
};

@interface YLDUserData : NSObject
@property (nonatomic, copy) NSString                                *userName;
@property (nonatomic, copy) NSString                                *passWord;
@property (nonatomic, copy) NSString                                *accountID;
@property (nonatomic, copy) NSString                                *pushToken;
@property (nonatomic, copy) NSString                                *jPushToken;
@property (nonatomic, copy) NSString                                *appLanguage;
@property (nonatomic, assign, getter=isLogin) BOOL                  login;
@property (nonatomic, assign) userMapSelected                       userMapSelected;
@property (nonatomic, assign) traceRefreshTime                      traceRefreshTime;
@property (nonatomic, assign) mainRefreshTime                       mainRefreshTime;
@end

@interface YLDDataManager : NSObject
@property (nonatomic, strong) YLDUserData           *userData;
@property (nonatomic, strong) NSDictionary          *currentDevice;
@property (nonatomic, strong) NSMutableArray        *devices;
@property (nonatomic, strong) NSMutableArray        *deviceNames;

+ (YLDDataManager*)manager;
@end
