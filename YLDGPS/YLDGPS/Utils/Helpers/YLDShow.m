//
//  YLDShow.m
//  YLDGPS
//
//  Created by faith on 17/3/11.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDShow.h"

@implementation YLDShow
#pragma mark - 补全分割线
+ (void)fullSperatorLine:(UITableView *)tableView {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
