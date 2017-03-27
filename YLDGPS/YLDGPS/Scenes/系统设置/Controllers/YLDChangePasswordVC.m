//
//  YLDChangePasswordVC.m
//  YLDGPS
//
//  Created by Faith on 2017/3/23.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDChangePasswordVC.h"
#import "YLDCommon.h"
@interface YLDChangePasswordVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *placeholderArray;
@property(nonatomic, strong) NSArray *labelArray;
@property(nonatomic, strong) ChangePasswordViewModel    *viewModel;
@end

@implementation YLDChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self rac];
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [confirmButton setTitleColor:HomeNavigationBar_COLOR forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    self.navigationItem.rightBarButtonItem = confirmButtonItem;
    [self.view addSubview:self.tableView];
}
- (NSArray *)placeholderArray{
    if(!_placeholderArray){
        _placeholderArray = [[NSArray alloc] initWithObjects:@"请输入旧密码",@"请输入新密码",@"请再次输入新密码", nil];
    }
    return _placeholderArray;
}
- (NSArray *)labelArray{
    if(!_labelArray){
        _labelArray = [[NSArray alloc] initWithObjects:@"旧密码",@"新密码",@"确认新密码", nil];
    }
    return _labelArray;
}
#pragma mark - getters and stters
- (ChangePasswordViewModel*)viewModel {
    if(_viewModel == nil) {
        _viewModel = [[ChangePasswordViewModel alloc] init];
    }
    return _viewModel;
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
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YLDChangePasswordCell";
    YLDChangePasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell){
        cell = [[YLDChangePasswordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.label.text = self.labelArray[indexPath.row];
    cell.contentTXF.placeholder = self.placeholderArray[indexPath.row];
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

- (void)confirm{
    NSMutableArray *textFieldArr = [[NSMutableArray alloc] init];
    for(int i = 0 ; i< 3;i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        YLDChangePasswordCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [textFieldArr addObject:cell.contentTXF];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    NSString *alertMessage;
    UITextField *tf0 = textFieldArr[0];
    UITextField *tf1 = textFieldArr[1];
    UITextField *tf2 = textFieldArr[2];
    if(tf0.text.length ==0){
        alertMessage = @"请输入旧密码";
    }else if (tf1.text.length ==0){
        alertMessage = @"请输入新密码";
    }else if (tf2.text.length ==0){
        alertMessage = @"请再次输入新密码";
    }else if (![tf2.text isEqualToString:tf1.text]){
        alertMessage = @"两次密码不一致";
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        [self.viewModel changePasswordWithOldPasswrod:tf0.text newPasswrod:tf1.text];
        return;
    }

    alert.message = alertMessage;
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)rac{
    [RACObserve(self.viewModel, reqChangePasswordFinshed) subscribeNext:^(id x) {
       // @strongify(self);
        
        if(self.viewModel.reqChangePasswordFinshed) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if(self.viewModel.reqChangePasswordmsg.length > 0) {
                [TSMessage showNotificationInViewController:self.navigationController
                                                      title:self.viewModel.reqChangePasswordmsg
                                                   subtitle:nil image:nil
                                                       type:TSMessageNotificationTypeWarning
                                                   duration:2 callback:nil
                                                buttonTitle:nil
                                             buttonCallback:nil
                                                 atPosition:TSMessageNotificationPositionNavBarOverlay
                                       canBeDismissedByUser:YES];
            }
            
            if(self.viewModel.reqChangePasswordSucessed) {
                [TSMessage showNotificationInViewController:self.navigationController
                                                      title:localizedString(@"success")
                                                   subtitle:nil image:nil
                                                       type:TSMessageNotificationTypeSuccess
                                                   duration:2 callback:nil
                                                buttonTitle:nil
                                             buttonCallback:nil
                                                 atPosition:TSMessageNotificationPositionNavBarOverlay
                                       canBeDismissedByUser:YES];
            }
            
        }
        
    }];
}

@end
