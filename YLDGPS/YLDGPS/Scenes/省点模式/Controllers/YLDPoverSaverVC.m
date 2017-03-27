//
//  YLDPoverSaverVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDPoverSaverVC.h"
#import "YLDCommon.h"
#define alertWorkModeTag 1239

@interface YLDPoverSaverVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *starTimeStr;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) deviceInfoViewModel *viewModel;
@property(nonatomic, strong) NSString *selectedModel;
@end

@implementation YLDPoverSaverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"省电模式";
    self.view.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    _modelArray = @[localizedString(@"workModeNomal"),localizedString(@"workModePowerSaving"),localizedString(@"workModeSuperPowerSaving")];
    [self addSubViews];
    [self rac];
}
- (void)addSubViews{
    [self.view addSubview:self.tableView];

}
#pragma mark - getters and setters
- (deviceInfoViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[deviceInfoViewModel alloc] init];
        _viewModel.deviceID = [[YLDDataManager manager].currentDevice[@"device_id"] stringValue];
    }
    return _viewModel;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
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
    return 44;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.textColor = COLOR_WITH_HEX(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = _modelArray[indexPath.row];    
    UIImage *image = [[UIImage alloc] init];
    NSString *workMode = self.modelArray[indexPath.row];
    if(self.viewModel.workMode == 1) {
    if(indexPath.row ==0){
            image = [UIImage imageNamed:@"on"];
        }else{
            image = [UIImage imageNamed:@"off"];
        }
    }else if(self.viewModel.workMode == 2) {
        if(indexPath.row ==1){
            image = [UIImage imageNamed:@"on"];
        }else{
            image = [UIImage imageNamed:@"off"];
        }

    }else if(self.viewModel.workMode == 3) {
        if(indexPath.row ==2){
            NSString *starTime = @"0";
            if(self.viewModel.starTime.length == 4) {
                starTime = [NSString stringWithFormat:@"%@:%@", [self.viewModel.starTime substringToIndex:2], [self.viewModel.starTime substringFromIndex:2]];
            }
            cell.textLabel.numberOfLines = 0;
            image = [UIImage imageNamed:@"on"];
            workMode = [workMode stringByAppendingString:[NSString stringWithFormat:@"\n%@:%@  %@:%@%@", localizedString(@"starTime"), starTime, localizedString(@"workTime"), self.viewModel.workTime, localizedString(@"minute")]];
        }else{
            image = [UIImage imageNamed:@"off"];
        }
    }
    cell.textLabel.text = workMode;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    cell.accessoryView = btn;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedModel = self.modelArray[indexPath.row];
    if(indexPath.row ==0 || indexPath.row ==1){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        [self.viewModel setWorkMode:indexPath.row+1 starTime:@"" workTime:@""];
        
    }
    if(indexPath.row ==2){
        NSString *title1 = [NSString stringWithFormat:@"%@(%@)", self.modelArray[2], localizedString(@"starTime")];
        [TimePickerView showInView:self.view title:title1 completed:^(NSString *hour, NSString *minute, BOOL isCancel) {
            
            if(!isCancel) {
                
                starTimeStr = [NSString stringWithFormat:@"%02d%02d", (int)hour.integerValue, (int)minute.integerValue];
                UIAlertView *alertView = [[UIAlertView alloc] init];
                alertView.title = localizedString(@"workModeSuperPowerSaving");
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alertView addButtonWithTitle:localizedString(@"confirm")];
                [alertView addButtonWithTitle:localizedString(@"cancel")];
                alertView.delegate = self;
                alertView.tag = alertWorkModeTag;
                [alertView show];
                
                UITextField *textField = [alertView textFieldAtIndex:0];
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.placeholder = [NSString stringWithFormat:@"%@ %@", localizedString(@"workTime"), localizedString(@"minute")];
                
            }
            
        }];

    }
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:localizedString(@"cancel")]) {
        return;
    }
    if([title isEqualToString:localizedString(@"confirm")]) {
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *workTime = textField.text;
        
        if(workTime <= 0) return;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        [self.viewModel setWorkMode:3 starTime:starTimeStr workTime:workTime];
        
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
- (void)reloadTable{
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
#pragma mark - private methods
- (void)rac{
    @weakify(self);
    [[RACObserve(self.viewModel, r) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(self.viewModel.r){
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
            NSString *tip = [NSString stringWithFormat:@"已成功切换至%@",_selectedModel];
            [SVProgressHUD showSuccessWithStatus:tip];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];

            });

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


@end
