//
//  YLDBaseVC.m
//  YLDGPS
//
//  Created by faith on 17/3/9.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDBaseVC.h"
#import "YLDCommon.h"
@interface YLDBaseVC ()

@end

@implementation YLDBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [UINavigationBar appearance].translucent = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self customBack];
//    [self configNavigationBar];

}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
////    NSString * tmpStr1 = NSStringFromClass([self class]);
////    if([tmpStr1 isEqualToString:@"YLDFenceVC"]){
////        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
////        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
////
////    }
//    [self configNavigationBar];
//}
//视图将要显示时隐藏
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self configNavigationBar];
}

//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)configNavigationBar{
    UIColor *navigationBarColor = NavigationBar_COLOR;
    UIColor *navigationBarTitleColor = HomeNavigationBar_COLOR;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:navigationBarTitleColor,NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kScreenWidth, 0.5)];
//    view.backgroundColor = SeparatorLine_COLOR;
//    [self.view addSubview:view];
}
- (void)customBack{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(-20, 0, 24, 24)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
