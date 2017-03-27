//
//  YLDFenceVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDFenceVC.h"
#import "YLDCommon.h"
@interface YLDFenceVC ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL isEdit;
}
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic, strong) fenceViewModel *viewModel;

@end

@implementation YLDFenceVC
@synthesize items = _items;
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子围栏";
    self.view.backgroundColor = [UIColor whiteColor];
    YLDSelectDeviceView *selectDeviceView = [[YLDSelectDeviceView alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 0, 110, 20)];
    __block YLDSelectDeviceView *weakSelectDeviceView = selectDeviceView;
    NSDictionary *deviceDic = [YLDDataManager manager].currentDevice;
    weakSelectDeviceView.typeString = deviceDic[@"nick_name"];
    selectDeviceView.selectBlock = ^{
        [YCXMenu setTintColor:COLOR_WITH_HEX(0x666666)];
        if ([YCXMenu isShow]){
            [YCXMenu dismissMenu];
        } else {
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 90, 0, 80, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
                weakSelectDeviceView.typeString = item.title;
                NSMutableArray *array = [YLDDataManager manager].devices;
                for(NSDictionary *dic in array){
                    if([dic[@"nick_name"] isEqualToString:item.title]){
                        [[YLDDataManager manager] setCurrentDevice:dic];
                        self.viewModel = nil;
                        [self.viewModel getFences];
                        
                        break;
                    }
                }

            }];
        }

    };

    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectDeviceView];
    self.navigationItem.rightBarButtonItem = selectItem;
    [self addSubViews];
    [self rac];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel getFences];
    
}
- (void)rac{
    @weakify(self);
    [RACObserve(self.viewModel, r) subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(self.viewModel.r){
            [self.tableView reloadData];
        }
        if(self.viewModel.msg.length > 0){
            TSMessageNotificationType type = self.viewModel.r?TSMessageNotificationTypeSuccess:TSMessageNotificationTypeWarning;
            [TSMessage showNotificationInViewController:self.navigationController title:self.viewModel.msg subtitle:nil image:nil type:type duration:2 callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionNavBarOverlay canBeDismissedByUser:YES];
        }
    }];
}

#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        NSMutableArray *deviceNames = [YLDDataManager manager].deviceNames;
        //set item
        _items = [[NSMutableArray alloc] init];
        for(int i = 0 ; i < deviceNames.count ; i++){
            YCXMenuItem *item =[YCXMenuItem menuItem:deviceNames[i] image:nil tag:100
                                            userInfo:@{@"title":@"Menu"}];
            [_items addObject:item];
        }
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}

- (void)addSubViews{
    [self.view addSubview:self.tableView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-44-20 - 44, kScreenWidth, 108)];
    view.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    UIButton *addFence = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth - 30, 44)];
    addFence.layer.cornerRadius = 20;
    [addFence.layer setMasksToBounds:YES];
    [addFence setBackgroundColor:HomeNavigationBar_COLOR];
    [addFence setTitle:@"添加围栏" forState:UIControlStateNormal];
    [addFence setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addFence addTarget:self action:@selector(addFenceAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addFence];
    [self.view addSubview:view];


}
#pragma mark - getters and setters
- (fenceViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[fenceViewModel alloc] init];
        _viewModel.deviceID = [[YLDDataManager manager].currentDevice[@"device_id"] stringValue];
    }
    return _viewModel;
}

- (void)setViewModel:(fenceViewModel *)viewModel{
    _viewModel = viewModel;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44-20 - 44) style:UITableViewStylePlain] ;
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
    return self.viewModel.fences.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"YLDFenlistCell";
    YLDFenlistCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[YLDFenlistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBK"]];
        cell.backgroundView = backgroundView;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    NSInteger row = indexPath.row;
    NSDictionary *dic = self.viewModel.fences[row];
    NSString *name = dic[@"name"];
    BOOL fenceEnable = [dic[@"status"] boolValue];
    cell.nameLbl.text = name;
    
    NSString *detialText = @"";
    NSDictionary *alarmDic = dic[@"alarm"];
    NSInteger alarmType = [alarmDic[@"alarm_type"] integerValue];
    switch (alarmType) {
        case 1:
            detialText = localizedString(@"inRemind");
            break;
            
        case 2:
            detialText = localizedString(@"outRemind");
            break;
    }
    NSString *smsNum = alarmDic[@"by_sms"];
    NSString *emailAddress = alarmDic[@"by_email"];
    NSString *callNum = alarmDic[@"by_call"];
    if(smsNum.length > 0){
        detialText = [NSString stringWithFormat:@"%@,%@", detialText, localizedString(@"receiveWay1")];
    }else if(emailAddress.length > 0){
        detialText = [NSString stringWithFormat:@"%@,%@", detialText, localizedString(@"receiveWay2")];
    }else if(callNum.length > 0){
        detialText = [NSString stringWithFormat:@"%@,%@", detialText, localizedString(@"receiveWay3")];
    }
    NSInteger rate = [alarmDic[@"rate"] integerValue];
    detialText = [NSString stringWithFormat:@"%@,%ld%@", detialText, (long)rate, localizedString(@"minute")];
    NSInteger limit = [alarmDic[@"limit"] integerValue];
    detialText = [NSString stringWithFormat:@"%@,%ld%@", detialText, (long)limit, localizedString(@"times")];
    
    cell.describeLbl.text = detialText;
    
    UIView *accessoryView = nil;
    if(isEdit){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:localizedString(@"delete") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius =  13;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        accessoryView = button;
    }else{
        UISwitch *switchView = [[UISwitch alloc] init];
        switchView.onTintColor = HomeNavigationBar_COLOR;
        switchView.frame = CGRectMake(0, 0, 60, 40);
        cell.accessoryView = switchView;
        switchView.on = fenceEnable;
        [switchView addTarget:self action:@selector(switchChaged:) forControlEvents:UIControlEventValueChanged];
        accessoryView = switchView;
    }
    accessoryView.tag = row;
    cell.accessoryView = accessoryView;
    
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    fenceEditViewController *ctrl = [[fenceEditViewController alloc] init];
//    ctrl.title = localizedString(@"fenceEdit");
//    ctrl.deviceID = self.deviceID;
//    fenceEditViewModel *viewModel =[[fenceEditViewModel alloc] init];
//    viewModel.fenceDic = self.viewModel.fences[indexPath.row];
//    ctrl.viewModel = viewModel;
//    ctrl.isCreate = NO;
//    [self.navigationController pushViewController:ctrl animated:YES];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDFenceEditVC *fenceEditVC = [[YLDFenceEditVC alloc] init];
    fenceEditVC.title = localizedString(@"fenceEdit");
    fenceEditVC.deviceID = [[YLDDataManager manager].currentDevice[@"device_id"] stringValue];
    fenceEditViewModel *viewModel = [[fenceEditViewModel alloc] init];
    viewModel.fenceDic = self.viewModel.fences[indexPath.row];
    fenceEditVC.viewModel = viewModel;
    fenceEditVC.isCreate = NO;

    [self.navigationController pushViewController:fenceEditVC animated:YES];
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
- (void)switchChaged:(UISwitch*)aSwitch{
    NSDictionary *dic = self.viewModel.fences[aSwitch.tag];
    NSString *fenceID = dic[@"fence_id"];
    BOOL enable = ![dic[@"status"] boolValue];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
    self.viewModel.fenceID = fenceID;
    [self.viewModel enableFence:enable];
}
- (void)addFenceAction{
    YLDFenceEditVC *ctrl = [[YLDFenceEditVC alloc] init];
    ctrl.title = localizedString(@"createFence");
    ctrl.deviceID = [[YLDDataManager manager].currentDevice[@"device_id"] stringValue];
    ctrl.isCreate = YES;
    [self.navigationController pushViewController:ctrl animated:YES];

}

@end
