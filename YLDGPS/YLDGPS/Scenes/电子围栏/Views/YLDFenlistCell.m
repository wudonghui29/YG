//
//  YLDFenlistCell.m
//  YLDGPS
//
//  Created by faith on 17/3/11.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDFenlistCell.h"
#import "YLDCommon.h"

@interface YLDFenlistCell()
@end
@implementation YLDFenlistCell
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
    [self addSubview:self.nameLbl];
    [self addSubview:self.describeLbl];
}
- (UILabel *)nameLbl{
    if(!_nameLbl){
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth-80, 20)];
        _nameLbl.textColor = COLOR_WITH_HEX(0x333333);
        _nameLbl.text = @"围栏名称";
    }
    return _nameLbl;
}
- (UILabel *)describeLbl{
    if(!_describeLbl){
        _describeLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, kScreenWidth-80, 15)];
        _describeLbl.textColor = COLOR_WITH_HEX(0x666666);
        _describeLbl.font = [UIFont systemFontOfSize:15];
        _describeLbl.text = @"离开预警 5份 6/24小时";
    }
    return _describeLbl;
}
@end

