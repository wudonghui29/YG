//
//  YLDSwitchView.h
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SwitchBlock)(NSInteger);
@interface YLDSwitchView : UIView
@property(nonatomic, strong)SwitchBlock switchBlock;
@end
