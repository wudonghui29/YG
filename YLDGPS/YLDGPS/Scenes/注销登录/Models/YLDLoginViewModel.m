//
//  YLDLoginViewModel.m
//  YLDGPS
//
//  Created by user on 15/6/19.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "YLDLoginViewModel.h"
#import "YLDCommon.h"

@implementation YLDLoginViewModel

#pragma mark - public methods
- (void)loginWithName:(NSString*)name password:(NSString*)password {
    NSString *pushID = [JPUSHService registrationID];
    (pushID.length <= 0)?(pushID = @""):0;
    
    [YLDAPIManager loginWithAccount:name passWord:password pushID:pushID success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        [self setLoginFailMsg:msg];
        if(r){
            [YLDDataManager manager].devices = [NSMutableArray array];
            YLDUserData *userData = [YLDDataManager manager].userData;
            userData.userName = name;
            userData.passWord = password;
            NSDictionary *accountDic = responseObject[@"account"];
            userData.accountID = accountDic[@"account_id"];
            userData.login = YES;
        }
    } fail:^(NSError *error) {
        [self setLoginFailMsg:error.localizedDescription];
    }];
}

#pragma mark - setters and getters 
- (void)setLoginFailMsg:(NSString *)loginFailMsg{
    _loginFailMsg = loginFailMsg;
}

@end
