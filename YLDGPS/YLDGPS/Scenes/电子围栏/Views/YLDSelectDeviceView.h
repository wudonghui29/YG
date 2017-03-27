//
//  YLDSelectDeviceView.h
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectBlock)();
@interface YLDSelectDeviceView : UIView
@property(nonatomic , copy) NSString *typeString;
@property(nonatomic ,strong)SelectBlock selectBlock;
@end
