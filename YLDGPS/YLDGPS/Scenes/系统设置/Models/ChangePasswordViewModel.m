//
//  ChangePasswordViewModel.m
//  YLDGPS
//
//  Created by user on 16/4/4.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ChangePasswordViewModel.h"

@implementation ChangePasswordViewModel
#pragma mark - public 
- (void)changePasswordWithOldPasswrod:(NSString*)oldPassword newPasswrod:(NSString*)newPasswrod {
    
    self.reqChangePasswordFinshed = NO;
    self.reqChangePasswordSucessed = NO;
    self.reqChangePasswordmsg = nil;
    
    [YLDAPIManager changePasswordWithOldPassword:oldPassword newPassword:newPasswrod success:^(id responseObject) {
        
        self.reqChangePasswordSucessed = [responseObject[@"r"] boolValue];
        self.reqChangePasswordmsg = responseObject[@"msg"];
        self.reqChangePasswordFinshed = YES;
        
        [YLDDataManager manager].userData.passWord = newPasswrod;
        
    } fail:^(NSError *error) {
        
        self.reqChangePasswordmsg = error.localizedDescription;
        self.reqChangePasswordFinshed = YES;
        
    }];
    
}

#pragma mark - getters and setters
- (void)setReqChangePasswordFinshed:(BOOL)reqChangePasswordFinshed {
    _reqChangePasswordFinshed = reqChangePasswordFinshed;
}

- (void)setReqChangePasswordSucessed:(BOOL)reqChangePasswordSucessed {
    _reqChangePasswordSucessed = reqChangePasswordSucessed;
}

- (void)setReqChangePasswordmsg:(NSString*)reqChangePasswordmsg {
    _reqChangePasswordmsg = reqChangePasswordmsg;
}

@end
