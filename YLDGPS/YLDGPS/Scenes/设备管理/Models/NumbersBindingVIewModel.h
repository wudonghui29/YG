//
//  NumbersBindingVIewModel.h
//  YLDGPS
//
//  Created by user on 15/7/22.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NumbersBindingVIewModel : NSObject
@property (nonatomic, copy) NSString                *deviceID;
@property (nonatomic, copy, readonly) NSString      *parentNumbers;
@property (nonatomic, copy, readonly) NSString      *sosNumbers;
@property (nonatomic, assign, readonly) BOOL        r;
@property (nonatomic, assign, readonly) BOOL        r1;
@property (nonatomic, copy, readonly) NSString      *msg;

///获取亲情号码 sos号码
- (void)getParentNumbersAndSosNumbers;
///修改亲情号码 soso号码
- (void)modifParentNumbersAndSosNUmbers;
@end
