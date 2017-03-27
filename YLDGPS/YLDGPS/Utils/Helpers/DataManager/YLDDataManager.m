//
//  YLDDataManager.m
//  YLDGPS
//
//  Created by user on 15/6/19.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "YLDDataManager.h"
#import "YLDCommon.h"

static YLDDataManager *dataManage;

#pragma mark - YLDUserData
@implementation YLDUserData
@synthesize userName            = _userName;
@synthesize passWord            = _passWord;
@synthesize accountID           = _accountID;
@synthesize login               = _login;
@synthesize pushToken           = _pushToken;
@synthesize jPushToken          = _jPushToken;
@synthesize appLanguage         = _appLanguage;
@synthesize userMapSelected     = _userMapSelected;
@synthesize traceRefreshTime    = _traceRefreshTime;
@synthesize mainRefreshTime     = _mainRefreshTime;

#pragma mark - getters and setters
- (NSString*)userName{
    if(_userName == nil){
        _userName = getUserDefault(@"userName");
    }
    _userName = nilString2Empty(_userName);
    return _userName;
}

- (NSString*)passWord{
    if(_passWord == nil){
        _passWord = getUserDefault(@"passWord");
    }
    _passWord = nilString2Empty(_passWord);
    return _passWord;
}
- (NSString*)accountID{
    if(_accountID == nil){
        _accountID = getUserDefault(@"accountID");
    }
    _accountID = nilString2Empty(_accountID);
    return _accountID;
}

- (BOOL)isLogin{
    _login = [getUserDefault(@"login") boolValue];
    return _login;
}

- (NSString*)pushToken{
    if(_pushToken == nil){
        _pushToken = getUserDefault(@"pushToken");
    }
    return _pushToken;
}

- (NSString*)jPushToken {
    if(_jPushToken == nil){
        _jPushToken = getUserDefault(@"jPushToken");
    }
    return _jPushToken;
}

- (NSString*)appLanguage{
    if(_appLanguage == nil){
        _appLanguage = getAppLanguage();
    }
    return _appLanguage;
}

- (userMapSelected)userMapSelected{
    _userMapSelected = [getUserDefault(@"userMapSelected") integerValue];
    if(_userMapSelected == 0) {
        
        if([getAppLanguage() isEqualToString:@"en"]) {
            _userMapSelected = userMapGoogle;
        }else {
            _userMapSelected = userMapBaidu;
        }
        //setUserDefault([NSString stringWithFormat:@"%ld",(long)_userMapSelected], @"userMapSelected");
    }
    
    return _userMapSelected;
}

- (traceRefreshTime)traceRefreshTime{
    if(getUserDefault(@"traceRefreshTime") == nil){
        self.traceRefreshTime = 1;
    }
    _traceRefreshTime = [getUserDefault(@"traceRefreshTime") integerValue];
    return _traceRefreshTime;
}

- (mainRefreshTime)mainRefreshTime {
    if(getUserDefault(@"mainRefreshTime") == nil){
        self.mainRefreshTime = 3;
    }
    _mainRefreshTime = [getUserDefault(@"mainRefreshTime") integerValue];
    return _mainRefreshTime;
}

- (void)setUserName:(NSString *)userName{
    _userName = userName;
    setUserDefault(_userName, @"userName");
}

- (void)setPassWord:(NSString *)passWord{
    _passWord = passWord;
    setUserDefault(_passWord, @"passWord");
}

- (void)setAccountID:(NSString *)accountID{
    _accountID = accountID;
    setUserDefault(_accountID, @"accountID");
}

- (void)setLogin:(BOOL)login{
    if(login == _login) return;
    _login = login;
    setUserDefault(@(_login), @"login");
}

- (void)setPushToken:(NSString *)pushToken{
    _pushToken = pushToken;
    setUserDefault(_pushToken, @"pushToken");
}

- (void)setJPushToken:(NSString *)jPushToken {
    _jPushToken = jPushToken;
    setUserDefault(_jPushToken, @"jPushToken");
}

- (void)setAppLanguage:(NSString *)appLanguage{
    if(!isValidLanguage(appLanguage)) return;
    if([appLanguage isEqualToString:_appLanguage]) return;
    _appLanguage = appLanguage;
    setUserDefault(_appLanguage, @"appLanguage");
}

- (void)setUserMapSelected:(userMapSelected)userMapSelected{
    if(userMapSelected == _userMapSelected) return;
    _userMapSelected = userMapSelected;
    setUserDefault([NSString stringWithFormat:@"%ld",(long)_userMapSelected], @"userMapSelected");
}

- (void)setTraceRefreshTime:(traceRefreshTime)traceRefreshTime{
    _traceRefreshTime = traceRefreshTime;
    setUserDefault([NSString stringWithFormat:@"%ld",(long)_traceRefreshTime], @"traceRefreshTime");
}

- (void)setMainRefreshTime:(mainRefreshTime)mainRefreshTime{
    _mainRefreshTime = mainRefreshTime;
    setUserDefault([NSString stringWithFormat:@"%ld",(long)_mainRefreshTime], @"mainRefreshTime");
}

@end


#pragma mark - YLDDataManager
@interface YLDDataManager ()

@end

@implementation YLDDataManager
@synthesize devices = _devices;
@synthesize currentDevice = _currentDevice;

#pragma mark - class methods
+ (YLDDataManager*)manager{
    if(dataManage == nil){
        dataManage = [[YLDDataManager alloc] init];
    }
    return dataManage;
}

#pragma mark - private methods
- (NSString*)userFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    NSString *userFilePath = [plistPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.userData.accountID]];
    BOOL isDirectory = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:userFilePath isDirectory:&isDirectory];
    
    if(!isExists && !isDirectory){
        [[NSFileManager defaultManager] createDirectoryAtPath:userFilePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return userFilePath;
}

- (NSString*)devicesCacheFilePath {
    NSString *userPath = [self userFilePath];
    NSString *devicesCachePath = [userPath stringByAppendingPathComponent:@"devicesCache"];
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:devicesCachePath];
    if(!isExists){
        [[NSFileManager defaultManager] createFileAtPath:devicesCachePath contents:nil attributes:nil];
    }
    return devicesCachePath;
}

- (NSArray*)loadLocalDevicesCache {
    NSArray *devices = [NSArray arrayWithContentsOfFile:[self devicesCacheFilePath]];
    return devices;
}

- (void)saveLocalDevicesCache {
    [self.devices writeToFile:[self devicesCacheFilePath] atomically:YES];
}

#pragma mark - getters and setters
- (YLDUserData*)userData{
    if(_userData == nil){
        _userData = [[YLDUserData alloc] init];
    }
    return _userData;
}
- (void)setCurrentDevice:(NSDictionary *)currentDevice{
    _currentDevice = currentDevice;
}
- (NSDictionary*)currentDevice {
    if(_currentDevice == nil) {
        if(self.devices.count > 0) {
            _currentDevice = self.devices.firstObject;
        }
    }else {
        BOOL isHave = NO;
        NSString *deviceID = [_currentDevice[@"device_id"] stringValue];
        for(NSDictionary *dic in self.devices) {
            NSString *deviceID1 = [dic[@"device_id"] stringValue];
            if([deviceID isEqualToString:deviceID1]) {
                isHave = YES;
                _currentDevice = dic;
                break;
            }
        }
        if(!isHave) {
            _currentDevice = self.devices.firstObject;
        }
    }
    return _currentDevice;
}
- (NSMutableArray *)deviceNames{
    NSMutableArray *names = [NSMutableArray array];
    if(self.devices){
        if(self.devices.count>0){
            for(int i = 0; i < self.devices.count;i++){
                NSDictionary *dic = self.devices[i];
                [names addObject:dic[@"nick_name"]];
            }
        }
    }
    return names;
}
- (NSMutableArray*)devices {
    if(_devices == nil) {
        NSArray *localDevicesCache = [self loadLocalDevicesCache];
        self.devices = [NSMutableArray arrayWithArray:localDevicesCache];
    }
    return _devices;
}

- (void)setDevices:(NSMutableArray *)devices {
    _devices = devices;
    [self saveLocalDevicesCache];
}


@end
