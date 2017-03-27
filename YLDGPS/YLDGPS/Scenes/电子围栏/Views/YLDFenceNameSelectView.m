//
//  YLDFenceNameSelectView.m
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDFenceNameSelectView.h"
#import "YLDCommon.h"
@interface YLDFenceNameSelectView()
@property(nonatomic, strong)UITextView *textView;
@end
@implementation YLDFenceNameSelectView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubViews];
    }
    return self;
}
- (UITextView *)textView{
    if(!_textView){
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 60, kScreenWidth-80 -30, 60)];
    }
    return _textView;
}
- (void)addSubViews{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, kScreenWidth-40*2, 190)];
    bView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    bView.backgroundColor = [UIColor whiteColor];
    UILabel *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-80, 52)];
    headView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    headView.textColor = HomeNavigationBar_COLOR;
    headView.textAlignment = NSTextAlignmentCenter;
    headView.text = @"围栏名称";
    [bView addSubview:headView];
    [self addSubview:bView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, kScreenWidth-80, 1)];
    lineView.backgroundColor = SeparatorLine_COLOR;
    [bView addSubview:lineView];
    [bView addSubview:self.textView];
    
    NSArray *itemArray = @[@"学校",@"公司",@"家里"];
    for(int i = 0; i <3 ;i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+65*i, 104, 50, 25)];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitle:itemArray[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = SeparatorLine_COLOR.CGColor;
        [btn setTitleColor:COLOR_WITH_HEX(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [bView addSubview:btn];
    }
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 144, kScreenWidth-80, 1)];
    lineView2.backgroundColor = SeparatorLine_COLOR;
    [bView addSubview:lineView2];

    
    
    
    UIButton *cancle = [[UIButton alloc] initWithFrame:CGRectMake(0, 145, (kScreenWidth-80)/2, 44)];
    cancle.tag = 0;
    [cancle setTitleColor:COLOR_WITH_HEX(0x333333) forState:UIControlStateNormal];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:cancle];
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, 145, (kScreenWidth-80)/2, 44)];
    confirm.tag = 1;
    [bView addSubview:confirm];
    [confirm setTitleColor:COLOR_WITH_HEX(0x333333) forState:UIControlStateNormal];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, 144, 1, 44)];
    lineView3.backgroundColor = SeparatorLine_COLOR;
    [bView addSubview:lineView3];

    [UIView animateWithDuration:0.5 animations:^{
        self.top = 0;
    }];

}
- (void)selectAction:(UIButton *)button{
    self.textView.text = button.titleLabel.text;
}
- (void)btnAction:(UIButton *)button{
    [self dissmiss];
    if(button.tag ==1){
        if(self.buttonBlock){
            self.buttonBlock(self.textView.text);
        }
    }
}
- (void)dissmiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.top = kScreenHeight;
    }];
}

@end
