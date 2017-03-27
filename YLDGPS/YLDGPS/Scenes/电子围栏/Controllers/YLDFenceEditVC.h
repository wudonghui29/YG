//
//  YLDFenceEditVC.h
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDBaseVC.h"
@class fenceEditViewModel;
@interface YLDFenceEditVC : YLDBaseVC
@property (nonatomic, strong)fenceEditViewModel    *viewModel;
@property (nonatomic, copy) NSString                *deviceID;
@property (nonatomic, assign) BOOL                  isCreate;

@end
