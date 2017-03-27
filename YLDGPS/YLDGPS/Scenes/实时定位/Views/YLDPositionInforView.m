//
//  YLDPositionInforView.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDPositionInforView.h"
#import "YLDCommon.h"
@interface YLDPositionInforView()
@property(nonatomic ,strong) ZWVerticalAlignLabel *nameLbl;
@property(nonatomic ,strong) UILabel *speedLbl;
@property(nonatomic ,strong) UILabel *positionWayLbl;
@property(nonatomic ,strong) UILabel *timeLbl;
@property(nonatomic ,strong) UILabel *addressLbl;

@property (nonatomic, strong) UIActivityIndicatorView   *activityIndicatorView;
@end
@implementation YLDPositionInforView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];

        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
    }
    return self;
}
- (ZWVerticalAlignLabel *)nameLbl{
    if(!_nameLbl){
        _nameLbl = [[ZWVerticalAlignLabel alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth-15, 20)];
    }
    return _nameLbl;
}
- (UILabel *)speedLbl{
    if(!_speedLbl){
        _speedLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, kScreenWidth-15, 20)];
        _speedLbl.font = [UIFont systemFontOfSize:12];
        _speedLbl.textColor = COLOR_WITH_HEX(0x666666);
        _speedLbl.text = @"速度:28km/h  电量:86%";
    }
    return _speedLbl;
}
- (UILabel *)positionWayLbl{
    if(!_positionWayLbl){
        _positionWayLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, kScreenWidth-15, 15)];
        _positionWayLbl.font = [UIFont systemFontOfSize:12];
        _positionWayLbl.textColor = COLOR_WITH_HEX(0x666666);
        _positionWayLbl.text = @"定位方式:GPS  状态:在线";
    }
    return _positionWayLbl;
}
- (UILabel *)timeLbl{
    if(!_timeLbl){
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 105, kScreenWidth-15, 15)];
        _timeLbl.font = [UIFont systemFontOfSize:12];
        _timeLbl.textColor = COLOR_WITH_HEX(0x666666);
        _timeLbl.text = @"时间:2017-03-16 15:30";
    }
    return _timeLbl;
}
- (UILabel *)addressLbl{
    if(!_addressLbl){
        _addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, kScreenWidth-30, 15)];
        _addressLbl.font = [UIFont systemFontOfSize:12];
        _addressLbl.numberOfLines = 0;
        _addressLbl.textColor = COLOR_WITH_HEX(0x666666);
        _addressLbl.text = @"地址: 广东省 深圳市 龙岗市 坂田街道";
    }
    return _addressLbl;
}

- (void)addSubViews{
    _from = [[UIButton alloc] initWithFrame:CGRectMake(80, 6, 24, 24)];
    [_from setImage:[UIImage imageNamed:@"from"] forState:UIControlStateNormal];
    [self addSubview:_from];
    _to = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80-24, 6, 24, 24)];
    [_to setImage:[UIImage imageNamed:@"to"] forState:UIControlStateNormal];
    [self addSubview:_to];
    
    UILabel *deviceLbl = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2, 6, 120, 24)];
    deviceLbl.textAlignment = NSTextAlignmentCenter;
    deviceLbl.textColor = HomeNavigationBar_COLOR;
    deviceLbl.font = [UIFont systemFontOfSize:15];
    deviceLbl.text = @"设备切换";
    [self addSubview:deviceLbl];
    
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 24, 50, 24, 24)];
    [more setBackgroundImage:[UIImage imageNamed:@"nest"] forState:UIControlStateNormal];
    [self addSubview:more];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = SeparatorLine_COLOR;
    [self addSubview:lineView];
    [self addSubview:self.nameLbl];
    [self addSubview:self.speedLbl];
    [self addSubview:self.positionWayLbl];
    [self addSubview:self.timeLbl];
    [self addSubview:self.addressLbl];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if(self.detailBlock){
        self.detailBlock();
    }
}
#pragma mark - getters and setters
- (void)setNickName:(NSString *)nickName{
    _nickName = nickName;
    NSArray * array = [_nickName componentsSeparatedByString:@","];
    NSString *first = [array firstObject];
    NSString *string = [NSString stringWithFormat:@"%@%@",array[0],array[1]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0x333333) range:NSMakeRange(0,first.length)];
    
    [str addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xa1a1a1) range:NSMakeRange(first.length,string.length-first.length)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, first.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(first.length, string.length-first.length)];
    _nameLbl.attributedText = str;
    [_nameLbl textAlign:^(ZWMaker *make) {
        make.addAlignType(textAlignType_bottom).addAlignType(textAlignType_left);
    }];

}
- (void)setSpeedPower:(NSString *)speedPower{
    _speedPower = speedPower;
    self.speedLbl.text = _speedPower;
}
- (void)setPositionStatus:(NSString *)positionStatus{
    _positionStatus = positionStatus;
    self.positionWayLbl.text = _positionStatus;
}
- (void)setTime:(NSString *)time{
    _time = time;
    self.timeLbl.text = _time;
    
}
- (void)setAddress:(NSString *)address{
    
    _address = address;
    CGSize s = [_address textSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreenWidth - 30, 400) lineBreakMode:NSLineBreakByCharWrapping];
    _addressLbl.height = s.height;
    self.addressLbl.text = _address;
}
- (void)setIsLoadingAddress:(BOOL)isLoadingAddress {
    _isLoadingAddress = isLoadingAddress;
    if(_isLoadingAddress) {
        [self.activityIndicatorView startAnimating];
        self.addressLbl.text = nil;
    }else {
        [self.activityIndicatorView stopAnimating];
    }
}
- (void)dissmiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = kScreenHeight;
    }];
}


@end
