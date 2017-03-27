//
//  deviceViewModel.m
//  YLDGPS
//
//  Created by user on 15/7/6.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "deviceViewModel.h"


@implementation deviceViewModel
@synthesize devices = _devices;

#pragma mark - life cyle
- (id)init{
    self = [super init];
    if(self != nil){
        [self rac];
    }
    return self;
}

#pragma mark - public methods
- (void)getDevicesList{
    [YLDAPIManager getDevicesSuccess:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        if(r){
            NSArray *devices = responseObject[@"dt"];
            [YLDDataManager manager].devices = [NSMutableArray arrayWithArray:devices];
        }
        NSString *msg = responseObject[@"msg"];
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

#pragma mark - private methods
- (void)rac{
    [RACObserve([YLDDataManager manager], devices) subscribeNext:^(id x) {
        self.devices = [YLDDataManager manager].devices;
    }];
}

#pragma mark - getters and setters
- (void)setDevices:(NSMutableArray *)devices{
    _devices = devices;
}

- (NSMutableArray*)devices{
    if(_devices == nil){
        _devices = [YLDDataManager manager].devices;
    }
    return _devices;
}

- (void)setR:(BOOL)r{
    _r = r;
}

- (void)setMsg:(NSString *)msg{
    _msg = msg;
}

@end
