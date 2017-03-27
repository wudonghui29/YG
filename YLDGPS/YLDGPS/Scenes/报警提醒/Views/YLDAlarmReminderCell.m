//
//  YLDAlarmReminderCell.m
//  YLDGPS
//
//  Created by faith on 17/3/11.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDAlarmReminderCell.h"
#import "YLDCommon.h"

@interface YLDAlarmReminderCell()
@property(nonatomic , strong) UIImageView *icon;
@property(nonatomic, strong) UILabel *nameLbl;
@property(nonatomic, strong) UILabel *alarmTypeLbl;

@end
@implementation YLDAlarmReminderCell

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
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 45, 45)];
        _icon.image = [UIImage imageNamed:@"g"];
    }
    return _icon;
}
- (UILabel *)nameLbl{
    if(!_nameLbl){
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, kScreenWidth-100, 15)];
        _nameLbl.textColor = COLOR_WITH_HEX(0x333333);
        _nameLbl.font = [UIFont systemFontOfSize:15];
        _nameLbl.text = @"车载GPS";
    }
    return _nameLbl;
}
- (UILabel *)alarmTypeLbl{
    if(!_alarmTypeLbl){
        _alarmTypeLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, kScreenWidth-100, 15)];
        _alarmTypeLbl.textColor = COLOR_WITH_HEX(0x666666);
        _alarmTypeLbl.font = [UIFont systemFontOfSize:15];
        _alarmTypeLbl.text = @"围栏预警";
        
    }
    return _alarmTypeLbl;
}

- (void)addSubViews{
    [self addSubview:self.icon];
    [self addSubview:self.nameLbl];
    [self addSubview:self.alarmTypeLbl];
}

@end
