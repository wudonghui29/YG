//
//  YLDAlarmReminderVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDAlarmReminderVC.h"
#import "YLDCommon.h"
@interface YLDAlarmReminderVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *items;

@end

@implementation YLDAlarmReminderVC
@synthesize items = _items;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警提醒";
    YLDSelectDeviceView *selectDeviceView = [[YLDSelectDeviceView alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 0, 110, 20)];
    __block YLDSelectDeviceView *weakSelectDeviceView = selectDeviceView;
    selectDeviceView.selectBlock = ^{
        [YCXMenu setTintColor:COLOR_WITH_HEX(0x666666)];
        if ([YCXMenu isShow]){
            [YCXMenu dismissMenu];
        } else {
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 90, 0, 80, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
                weakSelectDeviceView.typeString = item.title;
            }];
        }
        
    };
    selectDeviceView.typeString = @"掉电";
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectDeviceView];
    self.navigationItem.rightBarButtonItem = selectItem;
    [self addSubViews];
}
- (void)addSubViews{
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [YLDShow fullSperatorLine:_tableView];
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YLDAlarmReminderCell";
    YLDAlarmReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell){
        cell = [[YLDAlarmReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    UIImageView *nest = [[UIImageView alloc] init];
    nest.frame = CGRectMake(0, 0, 24, 24);
    nest.image = [UIImage imageNamed:@"nest"];
    cell.accessoryView = nest;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 补全分割线
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)showPanoramaWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title{
    panoramaView  *panorama = [[panoramaView alloc] initWithFrame:self.view.bounds];
    [panorama setCoordinate:coordinate title:title];
    [self.view addSubview:panorama];
}
#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        //set item
        _items = [@[[YCXMenuItem menuItem:@"全部"
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"围栏"
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"低电"
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"超速"
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}]
                                    ,
                    [YCXMenuItem menuItem:@"SOS"
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"ACC"
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"震动"
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}]
                                    ,
                    [YCXMenuItem menuItem:@"掉电"
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}]

                    ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}


@end
