//
//  YLDFenceNameSelectView.h
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonBlock)(NSString *textStr);
@interface YLDFenceNameSelectView : UIView
@property(nonatomic, strong) ButtonBlock buttonBlock;
@end
