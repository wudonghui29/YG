//
//  NumbersBindingVIewModel.m
//  YLDGPS
//
//  Created by user on 15/7/22.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "NumbersBindingVIewModel.h"
#import "YLDCommon.h"
@implementation NumbersBindingVIewModel

#pragma mark - public methods
///获取亲情号码 sos号码
- (void)getParentNumbersAndSosNumbers{
    [YLDAPIManager familyNumsWithDeviceID:self.deviceID familyNums:@"" cateID:@"0" success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        NSString *family_num = responseObject[@"family_num"];
        self.parentNumbers = family_num;
        if(r){
            [YLDAPIManager sosNumsWithDeviceID:self.deviceID sosNums:@"" cateID:@"0" success:^(id responseObject) {
                BOOL r = [responseObject[@"r"] boolValue];
                NSString *msg = responseObject[@"msg"];
                NSString *sos_num = responseObject[@"sos_num"];
                self.sosNumbers = sos_num;
                self.msg = msg;
                self.r = r;
            } fail:^(NSError *error) {
                self.msg = error.localizedDescription;
                self.r = NO;
            }];
        }else{
            self.msg = msg;
            self.r = r;
        }
        
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

///修改亲情号码 soso号码
- (void)modifParentNumbersAndSosNUmbers{
    [YLDAPIManager familyNumsWithDeviceID:self.deviceID familyNums:self.parentNumbers cateID:@"2" success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            [YLDAPIManager sosNumsWithDeviceID:self.deviceID sosNums:self.sosNumbers cateID:@"2" success:^(id responseObject) {
                BOOL r = [responseObject[@"r"] boolValue];
                NSString *msg = responseObject[@"msg"];
                self.msg = msg;
                self.r1 = r;
            } fail:^(NSError *error) {
                self.msg = error.localizedDescription;
                self.r1 = NO;
            }];
        }else{
            self.msg = msg;
            self.r1 = r;
        }
        
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r1 = NO;
    }];
}

#pragma mark - getters and setters
- (void)setR:(BOOL)r{
    _r = r;
}

- (void)setR1:(BOOL)r1{
    _r1 = r1;
}

- (void)setMsg:(NSString *)msg{
    _msg = msg;
}

- (void)setParentNumbers:(NSString *)parentNumbers{
    _parentNumbers = parentNumbers;
}

- (void)setSosNumbers:(NSString *)sosNumbers{
    _sosNumbers = sosNumbers;
}

@end
