//
//  YLDVDeviceDetailVC.m
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDVDeviceDetailVC.h"
#import "YLDCommon.h"
@interface YLDVDeviceDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray1;
@property(nonatomic, strong) NSArray *dataArray2;
@property (nonatomic, strong) deviceInfoViewModel *viewModel;

@end

@implementation YLDVDeviceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备详情";
//    [self.viewModel getDevicesList];
    [self rac];
    [self initDataArray];
    [self addSubViews];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel getDevicesList];
//    [self.tableView reloadData];
}
- (void)initDataArray{
    _dataArray1 = @[@"设防",@"断油电",@"ACC报警",@"断电报警",@"低电报警",@"宠物灯",@"车门开关",@"车大灯开关"];
    _dataArray2 = @[@"设备上传频率",@"SOS报警模式",@"超速速度",@"电子围栏",@"号码绑定",@"设备信息",@"设备重启",@"恢复出厂设置"];
}
- (void)addSubViews{
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
        _tableView.tableFooterView = [[UIView alloc] init];
        [YLDShow fullSperatorLine:_tableView];
    }
    return _tableView;
}
#pragma mark - getters and setters
- (deviceInfoViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[deviceInfoViewModel alloc] init];
        _viewModel.deviceID = self.deviceID;
    }
    return _viewModel;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0 || section == 1){
        return 1;
    }else if (section ==2){
        return _dataArray1.count;
    }
    return _dataArray2.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if(section ==0){
        return 65;
    }else if (section ==1){
        return 100;
    }
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    if(section ==0 || section ==3){
        return headView;
    }
    [view addSubview:headView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 34)];
    v.backgroundColor = COLOR_WITH_HEX(0x999999);

    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, kScreenWidth-15, 20)];
    [v addSubview:titleLbl];
    titleLbl.font = [UIFont systemFontOfSize:13];
    titleLbl.textColor = [UIColor whiteColor];
    NSString *headTitle = @"设备操作";
    if(section ==1){
        headTitle = @"设备概括";
    }
    titleLbl.text = headTitle;
    [view addSubview:v];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
//    line.backgroundColor = SeparatorLine_COLOR;
//    [view addSubview:line];
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section ==0 || section ==3){
        return 10;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = nil;
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section ==0){
        cellIdentifier = @"cell1";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSInteger imageTag = 111;
        UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:imageTag];
        if(imageView == nil){
            imageView = [[UIImageView alloc] init];
            imageView.tag = imageTag;
            imageView.frame = CGRectMake(15, 9, 46, 46);
            [cell.contentView addSubview:imageView];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.headIconUrl] placeholderImage:[UIImage imageNamed:@"g"]];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.headIconUrl] placeholderImage:[UIImage imageNamed:@"defalut"]];
        
        NSInteger labelTag = 112;
        UILabel *label = (UILabel*)[cell.contentView viewWithTag:labelTag];
        if(label == nil){
            label = [[UILabel alloc] init];
            CGFloat x = CGRectGetMaxX(imageView.frame) + 5;
            label.frame = CGRectMake(x, imageView.frame.origin.y, (tableView.frame.size.width - 10 - x), 20);
            label.tag = labelTag;
            label.textColor = COLOR_WITH_HEX(0x333333);
            label.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:label];
        }
        label.text = self.viewModel.deviceName;
        
        NSInteger labelTag2 = 113;
        UILabel *label2 = (UILabel*)[cell.contentView viewWithTag:labelTag2];
        if(label2 == nil){
            label2 = [[UILabel alloc] init];
            CGFloat x = CGRectGetMaxX(imageView.frame) + 5;
            label2.frame = CGRectMake(x, label.frame.origin.y+26, (tableView.frame.size.width - 10 - x), 20);
            label2.tag = labelTag2;
            label2.textColor = COLOR_WITH_HEX(0x666666);
            label2.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label2];
        }
        label2.text = [NSString stringWithFormat:@"IMEI: %@",self.viewModel.deviceIMEI];

    }else if (section ==1){
        cellIdentifier = @"YLDDeviceGeneralInforCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[YLDDeviceGeneralInforCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString *speedPower = [NSString stringWithFormat:@"速度 : %@km/h  电量 : %@%%",self.viewModel.deviceSpeed,self.viewModel.power];
        [dic setObject:speedPower forKey:@"speedPower"];
        NSString *positionStatus = [NSString stringWithFormat:@"定位方式 : %@  状态 : %@",self.viewModel.locWay,self.viewModel.deviceStauts];
        [dic setObject:positionStatus forKey:@"positionStatus"];
        NSString *time = [NSString stringWithFormat:@"时间 : %@",self.viewModel.time];
        [dic setObject:time forKey:@"time"];
        NSString *lanlon = [NSString stringWithFormat:@"经纬度 : %@",self.viewModel.deviceLocation];
        [dic setObject:lanlon forKey:@"lanlon"];
        NSString *address = [NSString stringWithFormat:@"地址 : %@",self.viewModel.address];
        if(!self.viewModel.address){
            address = @"地址 : 未知";
        }
        [dic setObject:address forKey:@"address"];
        YLDDeviceGeneralInforCell *cells = (YLDDeviceGeneralInforCell *)cell;
        [cells setDic:dic];

    }else if (section ==2){
        cellIdentifier = @"cell2";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        switch (row) {
            case 0:{
                cell.textLabel.text = self.viewModel.isDefend?localizedString(@"defendOff"):localizedString(@"defendOn");
                
                UISwitch *switchView = [[UISwitch alloc] init];
                switchView.onTintColor = HomeNavigationBar_COLOR;
                switchView.frame = CGRectMake(0, 0, 60, 40);
                switchView.on = self.viewModel.isDefend;
                
                @weakify(self);
                [[switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setDefendonoff:!self.viewModel.isDefend];
                }];
                
                cell.accessoryView = switchView;

            }
                
                break;
                
            case 1:{
                cell.textLabel.text = self.viewModel.isACC?localizedString(@"oilPowerResume"):localizedString(@"oilPowerOff");
                
                UISwitch *switchView = [[UISwitch alloc] init];
                switchView.onTintColor = HomeNavigationBar_COLOR;
                switchView.frame = CGRectMake(0, 0, 60, 40);
                switchView.on = self.viewModel.isACC;
                
                @weakify(self);
                [[switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setOilPoweronoff:!self.viewModel.isACC];
                }];
                
                cell.accessoryView = switchView;
            }
                
                break;
                
            case 2:{
                cell.textLabel.text = localizedString(@"ACCAlarm");
                
                UISwitch *switchView = [[UISwitch alloc] init];
                switchView.onTintColor = HomeNavigationBar_COLOR;
                switchView.frame = CGRectMake(0, 0, 60, 40);
                switchView.on = self.viewModel.isACCAlarmOn;
                
                @weakify(self);
                [[switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setACCAlarmonoff:!self.viewModel.isACCAlarmOn];
                }];
                
                cell.accessoryView = switchView;

            }
                
                break;
                
            case 3:{
                cell.textLabel.text = localizedString(@"powerOffAlarm");
                
                UISwitch *switchView = [[UISwitch alloc] init];
                switchView.onTintColor = HomeNavigationBar_COLOR;
                switchView.frame = CGRectMake(0, 0, 60, 40);
                switchView.on = self.viewModel.isPowerOffAlarmOn;
                
                @weakify(self);
                [[switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setPowerOffonoff:!self.viewModel.isPowerOffAlarmOn];
                }];
                
                cell.accessoryView = switchView;
            }
                
                break;
            case 4:{
                cell.textLabel.text = localizedString(@"lowPowerAlarm");
                
                UISwitch *switchView = [[UISwitch alloc] init];
                switchView.onTintColor = HomeNavigationBar_COLOR;
                switchView.frame = CGRectMake(0, 0, 60, 40);
                switchView.on = self.viewModel.isLowPowerAlarmOn;
                
                @weakify(self);
                [[switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setLowPowerWarningonoff:!self.viewModel.isLowPowerAlarmOn];
                }];
                
                cell.accessoryView = switchView;
            }
                
                break;
                
            case 5:{
                cell.textLabel.text = localizedString(@"petLights");
                
                UISwitch *switchView = [[UISwitch alloc] init];
                switchView.onTintColor = HomeNavigationBar_COLOR;
                switchView.frame = CGRectMake(0, 0, 60, 40);
                switchView.on = self.viewModel.isPetLightOn;
                
                @weakify(self);
                [[switchView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setPetLightOnoff:!self.viewModel.isPetLightOn];
                }];
                
                cell.accessoryView = switchView;
            }
                
                break;
            case 6:{
                cell.textLabel.text = localizedString(@"doorSwitch");
                UISwitch *switchView = [[UISwitch alloc] init];
                switchView.onTintColor = HomeNavigationBar_COLOR;
                switchView.frame = CGRectMake(0, 0, 60, 40);
//                switchView.on = self.viewModel.isPetLightOn;
                cell.accessoryView = switchView;


            }
                
                break;
                
            case 7:
            {
                cell.textLabel.text = localizedString(@"headlightSwitch");
                UISwitch *switchView = [[UISwitch alloc] init];
                switchView.onTintColor = HomeNavigationBar_COLOR;
                switchView.frame = CGRectMake(0, 0, 60, 40);
                //                switchView.on = self.viewModel.isPetLightOn;
                cell.accessoryView = switchView;
                
                
            }

                break;
                
                
            default:
                break;
        }
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.textLabel.text = _dataArray1[row];
//        UISwitch *switchView = [[UISwitch alloc] init];
//        switchView.on = YES;
//        switchView.onTintColor = HomeNavigationBar_COLOR;
//        switchView.frame = CGRectMake(0, 0, 60, 40);
//        cell.accessoryView = switchView;

    }else if (section ==3){
        cellIdentifier = @"cell3";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];

        
        cell.textLabel.text = _dataArray2[row];
        UIView *parameterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
        UILabel *parameterLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 175, 24)];
        parameterLbl.textColor = COLOR_WITH_HEX(0x666666);
        parameterLbl.textAlignment = NSTextAlignmentRight;
        parameterLbl.font = [UIFont systemFontOfSize:13];
        [parameterView addSubview:parameterLbl];
        UIImageView *nest = [[UIImageView alloc] init];
        nest.frame = CGRectMake(176, 0, 24, 24);
        [parameterView addSubview:nest];
        cell.accessoryView = parameterView;
        NSString *p = @"";
        UIImage *image = [UIImage imageNamed:@"nest"];
        
    
        if(row ==0){
            p = [NSString stringWithFormat:@"%d %@", (int)self.viewModel.deviceUploadRate ,localizedString(@"second")];
        }else if (row ==1){
            
            NSString *sosAlarmModel = @"";
            if(self.viewModel.SOSAlarmModel == 1) {
                sosAlarmModel = [sosAlarmModel stringByAppendingString:[NSString stringWithFormat:@"%@", localizedString(@"SOSAlarmModelSMS")]];
            }else if(self.viewModel.SOSAlarmModel == 2) {
                sosAlarmModel = [sosAlarmModel stringByAppendingString:[NSString stringWithFormat:@"%@", localizedString(@"SOSAlarmModelMobile")]];
            }

            p = sosAlarmModel;
        }else if (row ==2){
            NSString *overspeedSpeed = localizedString(@"overspeedSpeed");
            overspeedSpeed = [NSString stringWithFormat:@"%d km/h",(int)self.viewModel.overspeed];
            p = overspeedSpeed;
        }
        parameterLbl.text = p;
        if(row ==6 || row ==7){
            image = [[UIImage alloc] init];
        }
        nest.image = image;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 3){
        switch (row) {
            case 0:{
                UIAlertView *alertView = [[UIAlertView alloc] init];
                alertView.title = localizedString(@"deviceUploadRate");
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alertView addButtonWithTitle:localizedString(@"confirm")];
                [alertView addButtonWithTitle:localizedString(@"cancel")];
                alertView.delegate = self;
                alertView.tag = 100;
                [alertView show];
                
                UITextField *textField = [alertView textFieldAtIndex:0];
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.placeholder = localizedString(@"second");
            }
                
                break;
            case 1:{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:localizedString(@"SOSAlarmModel") preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:localizedString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSLog(@"取消执行");
                }];
                UIAlertAction *alarmModelSMS = [UIAlertAction actionWithTitle:localizedString(@"SOSAlarmModelSMS") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSLog(@"短信报警");
                        if(self.viewModel.SOSAlarmModel != 1) {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                        [self.viewModel setSOSAlarmMode:1];
                    }

                }];
                UIAlertAction *alarmModelMobile = [UIAlertAction actionWithTitle:localizedString(@"SOSAlarmModelMobile") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"电话报警");
                    if(self.viewModel.SOSAlarmModel != 2) {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                        [self.viewModel setSOSAlarmMode:2];
                    }
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:alarmModelSMS];
                [alertController addAction:alarmModelMobile];
                [self presentViewController:alertController animated:YES completion:nil]
                ;

                

            }
                
                break;
            case 2:{
            
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:localizedString(@"overspeedSpeed") preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:localizedString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSLog(@"取消执行");
                }];
                UIAlertAction *speedModel1 = [UIAlertAction actionWithTitle:@"80 km/h" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                    NSInteger value = [[action.title componentsSeparatedByString:@" "].firstObject integerValue];
                    if(value == self.viewModel.overspeed){
                        return;
                    }
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setOverspeedWithValue:value];
                    
                }];
                UIAlertAction *speedModel2 = [UIAlertAction actionWithTitle:@"90 km/h" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    NSInteger value = [[action.title componentsSeparatedByString:@" "].firstObject integerValue];
                    if(value == self.viewModel.overspeed){
                        return;
                    }
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setOverspeedWithValue:value];
                    
                }];
                UIAlertAction *speedModel3 = [UIAlertAction actionWithTitle:@"100 km/h" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSInteger value = [[action.title componentsSeparatedByString:@" "].firstObject integerValue];
                    if(value == self.viewModel.overspeed){
                        return;
                    }
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setOverspeedWithValue:value];
                    
                }];
                UIAlertAction *speedModel4 = [UIAlertAction actionWithTitle:@"110 km/h" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSInteger value = [[action.title componentsSeparatedByString:@" "].firstObject integerValue];
                    if(value == self.viewModel.overspeed){
                        return;
                    }
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setOverspeedWithValue:value];
                    
                }];
                UIAlertAction *speedModel5 = [UIAlertAction actionWithTitle:@"120 km/h" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                   
                    NSInteger value = [[action.title componentsSeparatedByString:@" "].firstObject integerValue];
                    if(value == self.viewModel.overspeed){
                        return;
                    }
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setOverspeedWithValue:value];
                    
                }];
                UIAlertAction *speedModel6 = [UIAlertAction actionWithTitle:@"130 km/h" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
                    NSInteger value = [[action.title componentsSeparatedByString:@" "].firstObject integerValue];
                    if(value == self.viewModel.overspeed){
                        return;
                    }
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                    [self.viewModel setOverspeedWithValue:value];
                    
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:speedModel1];
                [alertController addAction:speedModel2];
                [alertController addAction:speedModel3];
                [alertController addAction:speedModel4];
                [alertController addAction:speedModel5];
                [alertController addAction:speedModel6];
                
                [self presentViewController:alertController animated:YES completion:nil]
                ;

            }
                
                break;
            case 3:{
                YLDFenceVC *fenceVC = [[YLDFenceVC alloc] init];
                [self.navigationController pushViewController:fenceVC animated:YES];

            }
                
                break;
            case 4:{
                YLDNumberBindingVC *numberBindingVC = [[YLDNumberBindingVC alloc] init];
                numberBindingVC.deviceID = self.deviceID;
                [self.navigationController pushViewController:numberBindingVC animated:YES];
            }
                
                break;
            case 5:
                
                break;
            case 6:{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"重启" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSLog(@"取消执行");
                }];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if([action.title isEqualToString:localizedString(@"confirm")]) {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
                        [self.viewModel restart];
                    }

                }];
                [alertController addAction:cancelAction];
                [alertController addAction:otherAction];
                [self presentViewController:alertController animated:YES completion:nil]
                ;

            }
                
                break;
            case 7:{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"恢复出厂设置" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSLog(@"取消执行");
                }];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    if([action.title isEqualToString:localizedString(@"confirm")]) {
//                        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
//                        [self.viewModel factoryReset];
//
//                    }
                    
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:otherAction];
                [self presentViewController:alertController animated:YES completion:nil]
                ;

            }
                
                break;

                
            default:
                break;
        }
    }

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
#pragma mark - private methods
- (void)rac{
    @weakify(self);
    [[RACObserve(self.viewModel, r) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(self.viewModel.r){
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
        }
        if(self.viewModel.msg.length > 0){
            [TSMessage dismissActiveNotification];
            [TSMessage showNotificationWithTitle:self.viewModel.msg type:self.viewModel.r?TSMessageNotificationTypeSuccess:TSMessageNotificationTypeError];
        }
    }];
    
    [RACObserve(self.viewModel, getAddressReqFinshed) subscribeNext:^(id x) {
        @strongify(self);
        if(self.viewModel.getAddressReqFinshed) {
            [self reloadTable];
        }
    }];
    
}
- (void)reloadTable{
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:localizedString(@"confirm")]) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSInteger DeviceUploadRate = [textField.text integerValue];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        [self.viewModel setDeviceUploadRateWithMinute:DeviceUploadRate];
    }

}
@end
