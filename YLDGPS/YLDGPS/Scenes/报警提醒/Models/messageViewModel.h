//
//  messageViewModel.h
//  YLDGPS
//
//  Created by user on 15/7/24.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLDCommon.h"

@interface messageViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray       *warningMsgs;
@property (nonatomic, assign, readonly) BOOL          r;
@property (nonatomic, copy, readonly) NSString        *msg;

///获取报警信息
- (void)getWarningMsgWithCatID:(NSInteger)catID;
@end
