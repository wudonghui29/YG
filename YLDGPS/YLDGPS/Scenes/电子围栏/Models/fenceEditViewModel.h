//
//  fenceEditViewModel.h
//  YLDGPS
//
//  Created by user on 15/7/18.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLDCommon.h"
#import "remindRecevieViewModel.h"
@interface fenceEditViewModel : NSObject
@property (nonatomic, strong)NSString                             *deviceID;
@property (nonatomic, strong)NSDictionary                         *fenceDic;
@property (nonatomic, copy, readonly) NSString                    *fenceName;
@property (nonatomic, assign, readonly) NSInteger                 remindType;
@property (nonatomic, copy, readonly) NSString                    *circleRadius;                //圆半径
@property (nonatomic, copy, readonly) NSString                    *circleLonlat;                //圆中心点坐标
@property (nonatomic, strong, readonly) remindRecevieViewModel    *remindRecevieViewModel;
@property (nonatomic, assign, readonly) BOOL                      r;
@property (nonatomic, copy, readonly) NSString                    *msg;
- (void)submitFence;
@end
