//
//  YLDSimulateView.h
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SimulateBlock)();
@interface YLDSimulateView : UIView
@property(nonatomic, strong) SimulateBlock simulateBlock;
@end
