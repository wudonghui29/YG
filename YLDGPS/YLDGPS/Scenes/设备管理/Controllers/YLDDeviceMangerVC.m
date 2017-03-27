//
//  YLDDeviceMangerVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDDeviceMangerVC.h"
#import "YLDCommon.h"
@interface YLDDeviceMangerVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) deviceViewModel   *viewModel;
@property(nonatomic, strong) NSMutableArray *otherDevices;


@end

@implementation YLDDeviceMangerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备管理";
    self.view.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
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
- (NSMutableArray *)otherDevices{
    if(!_otherDevices){
        _otherDevices = [[NSMutableArray alloc] init];
        NSMutableArray *devices = self.viewModel.devices;
        for(int i =0; i < devices.count; i++){
            NSDictionary *dic = devices[i];
            NSString *d = [dic[@"device_id"] stringValue];
            NSString *d2 = [[YLDDataManager manager].currentDevice[@"device_id"] stringValue];
            if(![d isEqualToString:d2]){
                [_otherDevices addObject:dic];
            }
        }
    }
    return _otherDevices;
}
- (deviceViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[deviceViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section ==0){
        return 1;
    }
    return self.otherDevices.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [[NSDictionary alloc] init];
    if(indexPath.section ==0){
        dic = [YLDDataManager manager].currentDevice;
    }else{
        dic = self.otherDevices[indexPath.row];
    }
    NSDictionary *locationDic = dic[@"location"];
    NSString *address = [NSString stringWithFormat:@"地址 : %@",locationDic[@"address"]];
    CGSize s = [address textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-150, 400) lineBreakMode:NSLineBreakByCharWrapping];
    return 90+s.height+10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    [view addSubview:headView];
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 34)];
    v.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, kScreenWidth-15, 20)];
    [v addSubview:titleLbl];
    titleLbl.font = [UIFont systemFontOfSize:13];
//    titleLbl.textColor = [UIColor whiteColor];
    NSString *headTitle = @"当前设备";
    if(section ==1){
        headTitle = @"其他设备";
    }
    titleLbl.text = headTitle;
    [view addSubview:v];

    
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, kScreenWidth-15, 20)];
//    titleLbl.font = [UIFont systemFontOfSize:13];
//    NSString *headTitle = @"当前设备";
//    if(section ==1){
//        headTitle = @"其他设备";
//    }
//    titleLbl.text = headTitle;
//    [view addSubview:titleLbl];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
    line.backgroundColor = SeparatorLine_COLOR;
    [view addSubview:line];
    return view;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YLDDeviceListCell";
    YLDDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell){
        cell = [[YLDDeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSDictionary *dic = [[NSDictionary alloc] init];
    if(indexPath.section ==0){
        dic= [YLDDataManager manager].currentDevice;
    }else{
        dic = self.otherDevices[indexPath.row];
    }
    [cell setDic:dic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDVDeviceDetailVC *deviceDetailVC = [[YLDVDeviceDetailVC alloc] init];
    NSDictionary *dic = [[NSDictionary alloc] init];
    if(indexPath.section ==0){
        dic= [YLDDataManager manager].currentDevice;
    }else{
        dic = self.otherDevices[indexPath.row];
    }
    deviceDetailVC.deviceID = [dic[@"device_id"] stringValue];
    [self.navigationController pushViewController:deviceDetailVC animated:YES];
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

@end
