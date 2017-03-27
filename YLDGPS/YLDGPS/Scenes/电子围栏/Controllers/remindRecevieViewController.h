//
//  remindRecevieViewController.h
//  YLDGPS
//
//  Created by user on 15/7/18.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "remindRecevieViewModel.h"
#import "YLDBaseVC.h"
@interface remindRecevieViewController : YLDBaseVC <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) remindRecevieViewModel    *viewModel;
@end
