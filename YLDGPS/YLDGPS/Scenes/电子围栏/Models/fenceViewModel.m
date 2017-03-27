//
//  fenceViewModel.m
//  YLDGPS
//
//  Created by user on 15/7/18.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "fenceViewModel.h"
#import "YLDCommon.h"
@implementation fenceViewModel

#pragma mark - public 
///获取围栏
- (void)getFences{
    [YLDAPIManager getFenceWithDeviceID:self.deviceID success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        NSArray *fences = responseObject[@"fence"];
        NSMutableArray *fence1 = [NSMutableArray array];
        for(NSDictionary *dic in fences){
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
            [fence1 addObject:dic1];
        }
        self.fences = [NSMutableArray arrayWithArray:fence1];
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.description;
        self.r = -1;
    }];
}

///启用停用围栏
- (void)enableFence:(BOOL)enable{
    NSString *status = [NSString stringWithFormat:@"%d", enable];
    [YLDAPIManager deleteOrEnableFenceWithDeviceID:self.deviceID fenceID:self.fenceID status:status success:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            for(NSMutableDictionary *dic in self.fences){
                NSString *fenceID = dic[@"fence_id"];
                if([fenceID isEqualToString:self.fenceID]){
                    [dic setObject:[NSString stringWithFormat:@"%d", enable] forKey:@"status"];
                    break;
                }
            }
        }
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.description;
        self.r = -1;
    }];
}

///删除围栏
- (void)deleteFence{
    [YLDAPIManager deleteOrEnableFenceWithDeviceID:self.deviceID fenceID:self.fenceID status:@"-1" success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            if(r){
                for(NSDictionary *dic in self.fences){
                    NSString *fenceID = dic[@"fence_id"];
                    if([fenceID isEqualToString:self.fenceID]){
                        [self.fences removeObject:dic];
                        break;
                    }
                }
            }

        }
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.description;
        self.r = -1;
    }];
}

#pragma mark - getters and setters
- (void)setFences:(NSMutableArray *)fences{
    _fences = fences;
}

- (void)setR:(BOOL)r{
    _r = r;
}

- (void)setMsg:(NSString *)msg{
    _msg = msg;
}

@end
