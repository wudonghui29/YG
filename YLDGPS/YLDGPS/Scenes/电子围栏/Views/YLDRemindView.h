//
//  YLDRemindView.h
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectFenceRemindType)(NSString *remindType);
typedef void(^ConfirmBlock)(BOOL);

@interface YLDRemindView : UIView
@property(nonatomic, strong)SelectFenceRemindType selectFenceRemindType;
@property(nonatomic, strong)ConfirmBlock confirmBlock;
@property(nonatomic, assign)BOOL isSelected;
- (void)setFirstStatusWithType:(NSInteger)type;

@end
