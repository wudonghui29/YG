//
//  YLDNavigationView.h
//  YLDGPS
//
//  Created by faith on 17/3/11.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NavigateBlock)();
@interface YLDNavigationView : UIView
@property(nonatomic ,strong)NavigateBlock navigateBlock;
@end
