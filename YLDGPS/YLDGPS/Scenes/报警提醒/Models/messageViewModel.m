//
//  messageViewModel.m
//  YLDGPS
//
//  Created by user on 15/7/24.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "messageViewModel.h"

@implementation messageViewModel

#pragma mark - public methods
///获取报警信息
- (void)getWarningMsgWithCatID:(NSInteger)catID{
    [YLDAPIManager getWarningMsgWithCateID:[NSString stringWithFormat:@"%ld", (long)catID] success:^(id responseObject) {
        BOOL r = [responseObject[@"r"] boolValue];
        NSString *msg = responseObject[@"msg"];
        if(r){
            self.warningMsgs = responseObject[@"dt"];
        }
        self.msg = msg;
        self.r = r;
    } fail:^(NSError *error) {
        self.msg = error.localizedDescription;
        self.r = NO;
    }];
}

#pragma mark - getters and setters
- (void)setWarningMsgs:(NSArray *)warningMsgs{
    _warningMsgs = warningMsgs;
}

- (void)setR:(BOOL)r{
    _r = r;
}

- (void)setMsg:(NSString *)msg{
    _msg = msg;
}

@end
