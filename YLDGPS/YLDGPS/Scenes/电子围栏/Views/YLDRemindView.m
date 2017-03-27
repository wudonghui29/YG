//
//  YLDRemindView.m
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDRemindView.h"
#import "YLDCommon.h"
@interface YLDRemindView()
@property(nonatomic, strong) UIButton *b1;
@property(nonatomic, strong) UIButton *b2;
@end
@implementation YLDRemindView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, kScreenWidth-40*2, 190)];
    bView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    bView.backgroundColor = [UIColor whiteColor];
    UILabel *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-80, 52)];
    headView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    headView.textColor = HomeNavigationBar_COLOR;
    headView.textAlignment = NSTextAlignmentCenter;
    headView.text = @"提醒类型";
    [bView addSubview:headView];
    [self addSubview:bView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, kScreenWidth-80, 1)];
    lineView.backgroundColor = SeparatorLine_COLOR;
    [bView addSubview:lineView];

    
    UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 53, kScreenWidth-40*2, 44)];
    enterBtn.tag = 0;
    enterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [enterBtn setTitleColor:COLOR_WITH_HEX(0x333333) forState:UIControlStateNormal];
    enterBtn.contentEdgeInsets = UIEdgeInsetsMake(0,-180, 0, 0);
//    [enterBtn setBackgroundColor:[UIColor redColor]];
    [enterBtn setTitle:localizedString(@"inRemind") forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(bAction:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *enterLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 100, 20)];
//    enterLbl.textColor = COLOR_WITH_HEX(0x333333);
//    enterLbl.font = [UIFont systemFontOfSize:14];
//    enterLbl.text = @"进入提醒";
    [bView addSubview:enterBtn];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 97, kScreenWidth-80, 1)];
    lineView2.backgroundColor = SeparatorLine_COLOR;
    [bView addSubview:lineView2];
    
    
    UIButton *leaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth-40*2, 44)];
    leaveBtn.tag = 1;
    leaveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leaveBtn setTitleColor:COLOR_WITH_HEX(0x333333) forState:UIControlStateNormal];
    leaveBtn.contentEdgeInsets = UIEdgeInsetsMake(0,-180, 0, 0);
    //    [enterBtn setBackgroundColor:[UIColor redColor]];
    [leaveBtn setTitle:localizedString(@"outRemind") forState:UIControlStateNormal];
    [leaveBtn addTarget:self action:@selector(bAction:) forControlEvents:UIControlEventTouchUpInside];

//    UILabel *liveLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 112, 100, 20)];
//    liveLbl.textColor = COLOR_WITH_HEX(0x333333);
//    liveLbl.font = [UIFont systemFontOfSize:14];
//    liveLbl.text = @"离开提醒";
//    [bView addSubview:liveLbl];
    [bView addSubview:leaveBtn];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 143, kScreenWidth-80, 1)];
    lineView3.backgroundColor = SeparatorLine_COLOR;
    [bView addSubview:lineView3];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 145, kScreenWidth-80, 44)];
    [btn setTitleColor:COLOR_WITH_HEX(0x333333) forState:UIControlStateNormal];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:btn];

    _b1 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80-24-20, 63, 24, 24)];
    _b1.tag = 0;
    _b1.userInteractionEnabled = NO;
    [_b1 setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    [bView addSubview:_b1];
    _b2 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80-20-24, 110, 24, 24)];
    _b2.userInteractionEnabled = NO;
    _b2.tag = 1;
    [_b2 setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [bView addSubview:_b2];

    [UIView animateWithDuration:0.5 animations:^{
        self.top = 0;
    }];
    
}
- (void)confirmAction{
    if(self.confirmBlock){
        self.confirmBlock(self.isSelected);
    }
    [self dissmiss];
}
- (void)bAction:(UIButton *)button{
    self.isSelected = YES;
    if(button.tag ==0){
        [_b1 setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        [_b2 setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        if(self.selectFenceRemindType){
            self.selectFenceRemindType(@"进入提醒");
        }
        
    }else if (button.tag ==1){
        [_b2 setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        [_b1 setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        if(self.selectFenceRemindType){
            self.selectFenceRemindType(@"离开提醒");
        }

    }
}
- (void)dissmiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.top = kScreenHeight;
    }];
}
- (void)setFirstStatusWithType:(NSInteger)type{
    if(type ==0){
        [_b1 setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        [_b2 setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    }else{
        [_b1 setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [_b2 setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];

    }
}

@end
