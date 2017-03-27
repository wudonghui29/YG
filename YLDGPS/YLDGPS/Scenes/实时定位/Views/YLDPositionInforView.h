//
//  YLDPositionInforView.h
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DetailBlock)();
@interface YLDPositionInforView : UIView
@property(nonatomic, strong) DetailBlock detailBlock;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *speedPower;
@property (nonatomic, copy) NSString *positionStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) BOOL isLoadingAddress;
@property(nonatomic ,strong) UIButton *from;
@property(nonatomic ,strong) UIButton *to;
- (void)dissmiss;
@end
