//
//  ChangePasswordViewModel.h
//  YLDGPS
//
//  Created by user on 16/4/4.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLDCommon.h"

@interface ChangePasswordViewModel : NSObject
@property (nonatomic, assign, readonly) BOOL    reqChangePasswordFinshed;
@property (nonatomic, assign, readonly) BOOL    reqChangePasswordSucessed;
@property (nonatomic, copy, readonly) NSString  *reqChangePasswordmsg;

- (void)changePasswordWithOldPasswrod:(NSString*)oldPassword newPasswrod:(NSString*)newPasswrod;
@end
