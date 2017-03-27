//
//  YLDDeviceListCell.m
//  YLDGPS
//
//  Created by faith on 17/3/11.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDDeviceListCell.h"
#import "YLDCommon.h"
@interface YLDDeviceListCell()
@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, strong) ZWVerticalAlignLabel *nameLbl;
@property(nonatomic, strong) UILabel *speedLbl;
@property(nonatomic, strong) UILabel *positionWayLbl;
@property(nonatomic, strong) UILabel *timeLbl;
@property(nonatomic, strong) UILabel *addressLbl;
@property(nonatomic, strong) UIButton *moreButton;
@end
@implementation YLDDeviceListCell
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
- (UIImageView *)icon{
    if(!_icon){
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 82, 82)];
        _icon.image = [UIImage imageNamed:@"g"];
    }
    return _icon;
}
- (UIButton *)moreButton{
    if(!_moreButton){
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-15-24, 15, 24, 24)];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"nest"] forState:UIControlStateNormal];
    }
    return _moreButton;
}
- (ZWVerticalAlignLabel *)nameLbl{
    if(!_nameLbl){
        _nameLbl = [[ZWVerticalAlignLabel alloc] initWithFrame:CGRectMake(107, 15, kScreenWidth-150, 20)];
        NSString *msg = @"我的爱车(IME:13543737676)";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:msg];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0x333333) range:NSMakeRange(0,4)];
        
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xa1a1a1) range:NSMakeRange(4,msg.length-4)];
        
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4, msg.length-4)];
        _nameLbl.attributedText = str;
        [_nameLbl textAlign:^(ZWMaker *make) {
            make.addAlignType(textAlignType_bottom).addAlignType(textAlignType_left);
        }];

    }
    return _nameLbl;
}
- (UILabel *)speedLbl{
    if(!_speedLbl){
        _speedLbl = [[UILabel alloc] initWithFrame:CGRectMake(107, 35, kScreenWidth-150, 18)];
        _speedLbl.textColor = COLOR_WITH_HEX(0x666666);
        _speedLbl.font = [UIFont systemFontOfSize:14];
        _speedLbl.text = @"速度:28km/h  电量:86%";
    }
    return _speedLbl;
}
- (UILabel *)positionWayLbl{
    if(!_positionWayLbl){
        _positionWayLbl = [[UILabel alloc] initWithFrame:CGRectMake(107, 53, kScreenWidth-150, 18)];
        _positionWayLbl.textColor = COLOR_WITH_HEX(0x666666);
        _positionWayLbl.font = [UIFont systemFontOfSize:14];
        _positionWayLbl.text = @"定位方式:GPS 状态:在线";
    }
    return _positionWayLbl;
}
- (UILabel *)timeLbl{
    if(!_timeLbl){
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(107, 71, kScreenWidth-150, 18)];
        _timeLbl.textColor = COLOR_WITH_HEX(0x666666);
        _timeLbl.font = [UIFont systemFontOfSize:14];
        _timeLbl.text = @"时间:2017-03-16 15：30";
    }
    return _timeLbl;
}
- (UILabel *)addressLbl{
    if(!_addressLbl){
        _addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(107, 89, kScreenWidth-150, 18)];
        _addressLbl.textColor = COLOR_WITH_HEX(0x666666);
        _addressLbl.font = [UIFont systemFontOfSize:14];
        _addressLbl.text = @"地址:广东省 深圳市 龙岗区 坂田街道";
        _addressLbl.numberOfLines = 0;
    }
    return _addressLbl;
}


- (void)addSubViews{
    [self addSubview:self.icon];
    [self addSubview:self.nameLbl];
    [self addSubview:self.speedLbl];
    [self addSubview:self.positionWayLbl];
    [self addSubview:self.timeLbl];
    [self addSubview:self.addressLbl];
    [self addSubview:self.moreButton];
}
- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"head_icon"]] placeholderImage:[UIImage imageNamed:@"g"]];
    NSString *name = [NSString stringWithFormat:@"%@, (IME:%@)",dic[@"nick_name"],dic[@"imei"]];
    NSArray * array = [name componentsSeparatedByString:@","];
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
    NSDictionary *locationDic = dic[@"location"];
    NSDictionary *statusDic = dic[@"status"];
    NSNumber *loc_way = locationDic[@"loc_way"];
    NSNumber *bds = locationDic[@"bds"];
    
    NSString *speed = locationDic[@"speed"];
    NSString *power = statusDic[@"power"];
    BOOL online = [dic[@"online"] boolValue];
    NSString *onlineStr;
    if(online){
        onlineStr = @"在线";
    }else{
        onlineStr = @"离线";
    }
    NSString *locWayString = @"";
    if(bds.integerValue == 1) {
        locWayString = localizedString(@"locBDS");
    }else {
        if(loc_way.integerValue == 1) {
            locWayString = @"GPS";
        }else {
            locWayString = @"LBS";
        }
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([locationDic[@"time"] floatValue]/1000)];
    //date = convertSourceDateToDestDate(date);
    NSString *time = [formatter stringFromDate:date];

    _speedLbl.text = [NSString stringWithFormat:@"速度:%@km/h  电量:%@%%",speed,power];
    
    _positionWayLbl.text = [NSString stringWithFormat:@"定位方式 : %@  状态 : %@",locWayString,onlineStr];
    _timeLbl.text = [NSString stringWithFormat:@"时间 : %@",time];
    NSString *address = [NSString stringWithFormat:@"地址 : %@",locationDic[@"address"]];
    if(!locationDic[@"address"]){
        address = @"地址 : 未知";
    }

    CGSize s = [address textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-150, 400) lineBreakMode:NSLineBreakByCharWrapping];
    _addressLbl.height = s.height;
    _addressLbl.text = address;

    
}
@end
