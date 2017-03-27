//
//  TimePickerView.h
//  YLDGPS
//
//  Created by user on 16/4/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimePickerCompletionBlock)(NSString *hour, NSString *minute, BOOL isCancel);

@interface TimePickerView : UIView
+ (TimePickerView*)showInView:(UIView*)view title:(NSString*)title completed:(TimePickerCompletionBlock)completedBlock;
@end
