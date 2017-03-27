//
//  remindRecevieViewModel.m
//  YLDGPS
//
//  Created by user on 15/7/18.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "remindRecevieViewModel.h"

@implementation remindRecevieViewModel

#pragma life cyle
- (id)init{
    self = [super init];
    if(self != nil){
        self.receiveInterval = 0;
        self.receiveTimes = 0;
    }
    return self;
}

#pragma mark - getters and setters
- (void)setFenceDic:(NSDictionary *)fenceDic{
    _fenceDic = fenceDic;
    NSDictionary *alarmDic = _fenceDic[@"alarm"];
    NSInteger rate = [alarmDic[@"rate"] integerValue];
    if(rate == 5){
        self.receiveInterval = 0;
    }else if(rate == 10){
        self.receiveInterval = 1;
    }else if(rate == 15){
        self.receiveInterval = 2;
    }else if(rate == 30){
        self.receiveInterval = 3;
    }
    NSInteger limit = [alarmDic[@"limit"] integerValue];
    if(limit == 1){
        self.receiveTimes = 0;
    }else if(limit == 2){
        self.receiveTimes = 1;
    }else if(limit == 3){
        self.receiveTimes = 2;
    }
}

- (void)setReceiveWayText:(NSString *)receiveWayText{
    _receiveWayText = receiveWayText;
}

- (void)setReceiveInterval:(NSInteger)receiveInterval{
    _receiveInterval = receiveInterval;
}

- (void)setReceiveTimes:(NSInteger)receiveTimes{
    _receiveTimes = receiveTimes;
}

@end
