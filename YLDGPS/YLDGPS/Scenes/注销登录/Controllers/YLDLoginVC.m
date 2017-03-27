//
//  YLDLoginVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDLoginVC.h"
#import "YLDCommon.h"
@interface YLDLoginVC ()
@property (nonatomic, strong) YLDLoginViewModel *viewModel;

@property(nonatomic, strong)UITextField *userTextField;
@property(nonatomic, strong)UITextField *passwordField;
@property (nonatomic, strong) UIButton  *loginButton;

@end

@implementation YLDLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    [self addSubView];
    [self rac];
}
- (void)addSubView{
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 90)/2, 69, 90, 90)];
    logo.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logo];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 199, kScreenWidth, 80)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    _userTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth, 40)];
    _userTextField.placeholder = @"用户名/IME号";
    [bgView addSubview:_userTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 1)];
    lineView.backgroundColor = SeparatorLine_COLOR;
    [bgView addSubview:lineView];
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(15, 40, kScreenWidth, 40)];
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @"密 码";
    [bgView addSubview:_passwordField];
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 320, kScreenWidth - 30, 44)];
    self.loginButton.layer.cornerRadius = 20;
    [self.loginButton.layer setMasksToBounds:YES];
    [self.loginButton setBackgroundColor:HomeNavigationBar_COLOR];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    YLDScanButton *scan = [[YLDScanButton alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2, 384, 120, 20)];
    [scan setTitle:@"扫描设备二维码登录" forState:UIControlStateNormal];
    
    scan.titleLabel.font = [UIFont systemFontOfSize:13];
    [scan setTitleColor:HomeNavigationBar_COLOR forState:UIControlStateNormal];
    [scan setColor:HomeNavigationBar_COLOR];
    [self.view addSubview:scan];
    YLDSimulateView *simulate = [[YLDSimulateView alloc] initWithFrame:CGRectMake((kScreenWidth-67)/2, kScreenHeight-50, 67, 24)];
    simulate.simulateBlock = ^{
        [self textFieldResignFistResponder];
        [self.viewModel loginWithName:kExperienceAccount password:kExperiencePassword];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
    };
    [self.view addSubview:simulate];
}
- (void)loginAction{
    NSString *name = self.userTextField.text;
    NSString *passwrod = self.passwordField.text;
    NSString *warrningString = nil;
    
    if(name.length <= 0){
        warrningString = localizedString(@"userName_WaringMSG");
    }else if(passwrod.length <= 0){
        warrningString = localizedString(@"passWord_WaringMSG");
    }
    
    if(warrningString.length > 0){
        [TSMessage dismissActiveNotification];
        [TSMessage showNotificationWithTitle:warrningString type:TSMessageNotificationTypeWarning];
    }else{
        [self.viewModel loginWithName:name password:passwrod];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
    }

}
- (YLDLoginViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[YLDLoginViewModel alloc] init];
    }
    return _viewModel;
}
- (void)rac{
    
    @weakify(self);
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [[defaultCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification *notification) {
//        @strongify(self);
//        CGRect keyBoardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        UIScrollView *sv = self.scrollView;
//        sv.contentSize = CGSizeMake(sv.frame.size.width, (CGRectGetMaxY(self.experienceButton.frame) + keyBoardRect.size.height));
//    }];
    
//    [[defaultCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
//        @strongify(self);
//        UIScrollView *sv = self.scrollView;
//        sv.contentSize = CGSizeMake(sv.frame.size.width, CGRectGetMaxY(self.experienceButton.frame));
//    }];
    
    [[RACObserve(self.viewModel, loginFailMsg) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *msg = x;
        if(msg.length > 0){
            [TSMessage dismissActiveNotification];
            [TSMessage showNotificationWithTitle:x type:TSMessageNotificationTypeWarning];
        }
    }];
    
//    [[self.barcodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        [self textFieldResignFistResponder];
//        
//        BarcodeSancViewController *ctrl = [[BarcodeSancViewController alloc] init];
//        ctrl.delegate = self;
//        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
//        [self presentViewController:navCtrl animated:YES completion:nil];
//    }];
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [self textFieldResignFistResponder];
        
        NSString *name = self.userTextField.text;
        NSString *passwrod = self.passwordField.text;
        NSString *warrningString = nil;
        
        if(name.length <= 0){
            warrningString = localizedString(@"userName_WaringMSG");
        }else if(passwrod.length <= 0){
            warrningString = localizedString(@"passWord_WaringMSG");
        }
        
        if(warrningString.length > 0){
            [TSMessage dismissActiveNotification];
            [TSMessage showNotificationWithTitle:warrningString type:TSMessageNotificationTypeWarning];
        }else{
            [self.viewModel loginWithName:name password:passwrod];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        }
    }];
    
//    [[self.experienceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        [self textFieldResignFistResponder];
//        [self.viewModel loginWithName:kExperienceAccount password:kExperiencePassword];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
//    }];
    
}
- (void)textFieldResignFistResponder{
    [self.userTextField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

@end
