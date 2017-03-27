//
//  YLDRemindReceiveVC.h
//  YLDGPS
//
//  Created by faith on 17/3/14.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDBaseVC.h"
typedef void(^SelectIntervalTimeBlock)(NSString *,NSString *);
@interface YLDRemindReceiveVC : YLDBaseVC
@property(nonatomic, strong)SelectIntervalTimeBlock selectIntervalTimeBlock;
@end
