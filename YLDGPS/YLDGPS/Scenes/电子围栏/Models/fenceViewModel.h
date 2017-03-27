//
//  fenceViewModel.h
//  YLDGPS
//
//  Created by user on 15/7/18.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fenceViewModel : NSObject
@property (nonatomic, copy) NSString                        *deviceID;
@property (nonatomic, copy) NSString                        *fenceID;
@property (nonatomic, strong, readonly) NSMutableArray      *fences;
@property (nonatomic, assign, readonly) BOOL                r;                          //获取围栏请求返回状态
@property (nonatomic, copy, readonly) NSString              *msg;                        //返回的信息
///获取围栏
- (void)getFences;
///启用停用围栏
- (void)enableFence:(BOOL)enable;
///删除围栏
- (void)deleteFence;
@end
