//
//  YLDAlarmReminderVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDAlarmReminderVC.h"
#import "YLDCommon.h"
@interface YLDAlarmReminderVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger  catID;
}
@property (nonatomic, strong) messageViewModel      *viewModel;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *items;

@end

@implementation YLDAlarmReminderVC
@synthesize items = _items;
#pragma mark - life cyle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel getWarningMsgWithCatID:catID];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警提醒";
    [self rac];
    YLDSelectDeviceView *selectDeviceView = [[YLDSelectDeviceView alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 0, 110, 20)];
    __block YLDSelectDeviceView *weakSelectDeviceView = selectDeviceView;
    selectDeviceView.selectBlock = ^{
        [YCXMenu setTintColor:COLOR_WITH_HEX(0x666666)];
        if ([YCXMenu isShow]){
            [YCXMenu dismissMenu];
        } else {
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 90, 0, 80, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
                NSString *title = item.title;
                weakSelectDeviceView.typeString = title;
                catID = 0;
                
                if([title isEqualToString:localizedString(@"all")]){
                    catID = 0;
                }else if([title isEqualToString:localizedString(@"fence")]){
                    catID = 1;
                }else if([title isEqualToString:localizedString(@"lowPower")]){
                    catID = 2;
                }else if([title isEqualToString:localizedString(@"overspeed")]){
                    catID = 3;
                }else if([title isEqualToString:localizedString(@"sos")]){
                    catID = 4;
                }else if([title isEqualToString:localizedString(@"ACC")]){
                    catID = 5;
                }else if([title isEqualToString:localizedString(@"vibration")]){
                    catID = 6;
                }else if([title isEqualToString:localizedString(@"powerDown")]){
                    catID = 7;
                }
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                [self.viewModel getWarningMsgWithCatID:catID];

            }];
        }
        
    };
    selectDeviceView.typeString = @"掉电";
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectDeviceView];
    self.navigationItem.rightBarButtonItem = selectItem;
    [self addSubViews];
    
}
- (void)rac{
    @weakify(self);
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [[defaultCenter rac_addObserverForName:kJPFNetworkDidReceiveMessageNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel getWarningMsgWithCatID:catID];
    }];
    
    [[RACObserve(self.viewModel, r) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(self.viewModel.r){
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        if(self.viewModel.msg.length > 0){
            [TSMessage showNotificationWithTitle:self.viewModel.msg type:self.viewModel.r?TSMessageNotificationTypeSuccess:TSMessageNotificationTypeError];
        }
        
    }];
}

- (void)addSubViews{
    [self.view addSubview:self.tableView];
}
#pragma mark - getters and setters
- (messageViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[messageViewModel alloc] init];
    }
    return _viewModel;
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
    return self.viewModel.warningMsgs.count;
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
    
    NSDictionary *dic = self.viewModel.warningMsgs[indexPath.row];
    NSString *headIcon = dic[@"head_icon"];
    NSString *name = dic[@"nick_name"];
    NSString *type = dic[@"c"];
    
    if(type.integerValue == 1) {
        type = localizedString(@"outFenceWarning");
    }else if(type.integerValue == 2) {
        type = localizedString(@"lowPowerWarning");
    }else if(type.integerValue == 3) {
        type = localizedString(@"overspeedWarning");
    }else if(type.integerValue == 4) {
        type = localizedString(@"sosWarning");
    }else if(type.integerValue == 5) {
        type = localizedString(@"ACCWarning");
    }else if(type.integerValue == 6) {
        type = localizedString(@"vibrationWarning");
    }else if(type.integerValue == 7){
        type = localizedString(@"powerDownWarning");
    }else {
        type = localizedString(@"unkonwType");
    }
    
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:headIcon] placeholderImage:[UIImage imageNamed:@"g"]];
    cell.nameLbl.text = [[localizedString(@"deviceName") stringByAppendingString:@": "] stringByAppendingString:name];
    cell.alarmTypeLbl.text = [[localizedString(@"type") stringByAppendingString:@": "] stringByAppendingString:type];

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
        _items = [@[[YCXMenuItem menuItem:localizedString(@"all")
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:localizedString(@"fence")
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:localizedString(@"lowPower")
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:localizedString(@"overspeed")
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}]
                                    ,
                    [YCXMenuItem menuItem:localizedString(@"sos")
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:localizedString(@"ACC")
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:localizedString(@"vibration")
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}]
                                    ,
                    [YCXMenuItem menuItem:localizedString(@"powerDown")
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
