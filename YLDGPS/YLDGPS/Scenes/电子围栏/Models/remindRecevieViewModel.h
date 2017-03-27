//
//  remindRecevieViewModel.h
//  YLDGPS
//
//  Created by user on 15/7/18.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface remindRecevieViewModel : NSObject
@property (nonatomic, strong)NSDictionary             *fenceDic;
@property (nonatomic, copy, readonly) NSString        *receiveWayText;    //通知方式的电话号码 或者 电邮
@property (nonatomic, assign,readonly) NSInteger      receiveInterval;
@property (nonatomic, assign, readonly) NSInteger     receiveTimes;

@end
