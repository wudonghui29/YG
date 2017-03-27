//
//  YLDServiceCenterVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDServiceCenterVC.h"
#import "YLDCommon.h"
@interface YLDServiceCenterVC ()
@property(nonatomic, strong)UIWebView *webView;
@end

@implementation YLDServiceCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"客服中心";
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64)];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://yun.gps112.net/service_center.html"]];
    [self.webView loadRequest:request];

    [self.view addSubview:self.webView];

}


@end
