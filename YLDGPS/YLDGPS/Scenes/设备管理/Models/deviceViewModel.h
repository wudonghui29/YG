//
//  deviceViewModel.h
//  YLDGPS
//
//  Created by user on 15/7/6.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLDCommon.h"

@interface deviceViewModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray    *devices;
@property (nonatomic, assign, readonly) BOOL              r;
@property (nonatomic, copy, readonly) NSString            *msg;
- (void)getDevicesList;
@end
