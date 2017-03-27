//
//  YLDSwitchView.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDSwitchView.h"
#import "YLDCommon.h"

@interface YLDSwitchView()
@property(nonatomic, strong)UIButton *normal;
@property(nonatomic, strong)UIButton *satellite;

@end
@implementation YLDSwitchView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.cornerRadius = 5;
        [self.layer setMasksToBounds:YES];
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews{
    _normal = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
    _normal.tag = 0;
    _normal.titleLabel.font = [UIFont systemFontOfSize:11];
    [_normal setBackgroundColor:HomeNavigationBar_COLOR];
    [_normal setTitle:@"标准" forState:UIControlStateNormal];
    [_normal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_normal addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_normal];
    
    _satellite = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 32)];
    _satellite.tag = 1;
    _satellite.titleLabel.font = [UIFont systemFontOfSize:11];
    [_satellite setBackgroundColor:[UIColor whiteColor]];
    [_satellite setTitle:@"卫星" forState:UIControlStateNormal];
    [_satellite setTitleColor:HomeNavigationBar_COLOR forState:UIControlStateNormal];
    [_satellite addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_satellite];
}
- (void)switchAction:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if(self.switchBlock){
        self.switchBlock(tag);
    }
    if(tag ==0){
        [_normal setBackgroundColor:HomeNavigationBar_COLOR];
        [_normal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_satellite setBackgroundColor:[UIColor whiteColor]];
        [_satellite setTitleColor:HomeNavigationBar_COLOR forState:UIControlStateNormal];
    }else{
        [_normal setBackgroundColor:[UIColor whiteColor]];
        [_normal setTitleColor:HomeNavigationBar_COLOR forState:UIControlStateNormal];
        [_satellite setBackgroundColor:HomeNavigationBar_COLOR];
        [_satellite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
@end
