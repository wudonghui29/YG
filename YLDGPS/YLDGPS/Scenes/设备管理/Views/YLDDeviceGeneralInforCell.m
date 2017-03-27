//
//  YLDDeviceGeneralInforCell.m
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDDeviceGeneralInforCell.h"
#import "YLDCommon.h"
@interface YLDDeviceGeneralInforCell()

@property(nonatomic, strong) UILabel *speedLbl;
@property(nonatomic, strong) UILabel *positionWayLbl;
@property(nonatomic, strong) UILabel *timeLbl;
@property(nonatomic, strong) UILabel *lonlatLbl;
@property(nonatomic, strong) UILabel *addressLbl;
@end
@implementation YLDDeviceGeneralInforCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews{
    [self addSubview:self.speedLbl];
    [self addSubview:self.positionWayLbl];
    [self addSubview:self.timeLbl];
    [self addSubview:self.lonlatLbl];
    [self addSubview:self.addressLbl];
}


- (UILabel *)speedLbl{
    if(!_speedLbl){
        _speedLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth-15, 15)];
        _speedLbl.textColor = COLOR_WITH_HEX(0x333333);
        _speedLbl.font = [UIFont systemFontOfSize:12];
        _speedLbl.text = @"速度:28km/h  电量:86%";
    }
    return _speedLbl;
}
- (UILabel *)positionWayLbl{
    if(!_positionWayLbl){
        _positionWayLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, kScreenWidth-15, 15)];
        _positionWayLbl.textColor = COLOR_WITH_HEX(0x333333);
        _positionWayLbl.font = [UIFont systemFontOfSize:12];
        _positionWayLbl.text = @"定位方式:GPS 状态:在线";
    }
    return _positionWayLbl;
}
- (UILabel *)timeLbl{
    if(!_timeLbl){
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, kScreenWidth-15, 15)];
        _timeLbl.textColor = COLOR_WITH_HEX(0x333333);
        _timeLbl.font = [UIFont systemFontOfSize:12];
        _timeLbl.text = @"时间:2017-03-16 15：30";
    }
    return _timeLbl;
}
- (UILabel *)lonlatLbl{
    if(!_lonlatLbl){
        _lonlatLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, kScreenWidth-15, 15)];
        _lonlatLbl.textColor = COLOR_WITH_HEX(0x333333);
        _lonlatLbl.font = [UIFont systemFontOfSize:12];
        _lonlatLbl.text = @"经纬度:116.069,26.4646";
    }
    return _lonlatLbl;
}

- (UILabel *)addressLbl{
    if(!_addressLbl){
        _addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, kScreenWidth-30, 15)];
        _addressLbl.font = [UIFont systemFontOfSize:12];
        _addressLbl.numberOfLines = 0;
        _addressLbl.text = @"地址:广东省 深圳市 龙岗区 坂田街道";
    }
    return _addressLbl;
}
- (void)setDic:(NSDictionary *)dic{
    self.speedLbl.text = dic[@"speedPower"];
    self.positionWayLbl.text = dic[@"positionStatus"];
    self.timeLbl.text = dic[@"time"];
    self.lonlatLbl.text = dic[@"lanlon"];
    NSString *address = dic[@"address"];
    CGSize s = [address textSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreenWidth - 30, 400) lineBreakMode:NSLineBreakByCharWrapping];
    _addressLbl.height = s.height;
    self.addressLbl.text = address;
}
@end
