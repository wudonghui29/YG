//
//  YLDLoginViewModel.h
//  YLDGPS
//
//  Created by user on 15/6/19.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDLoginViewModel : NSObject
@property (nonatomic, strong, readonly) NSString        *loginFailMsg;
- (void)loginWithName:(NSString*)name password:(NSString*)password;
@end
