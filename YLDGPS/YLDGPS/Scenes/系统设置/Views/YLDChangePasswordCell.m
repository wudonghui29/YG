//
//  YLDChangePasswordCell.m
//  YLDGPS
//
//  Created by Faith on 2017/3/23.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDChangePasswordCell.h"
#import "YLDCommon.h"
@interface YLDChangePasswordCell()
@end
@implementation YLDChangePasswordCell

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
- (UILabel *)label{
    if(!_label){
        _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 20)];
        _label.font = [UIFont systemFontOfSize:14];
    }
    return _label;
}
- (UITextField *)contentTXF{
    if(!_contentTXF){
        _contentTXF = [[UITextField alloc] initWithFrame:CGRectMake(120, 12, kScreenWidth-120, 20)];
        _contentTXF.font = [UIFont systemFontOfSize:14];
        _contentTXF.secureTextEntry = YES;
    }
    return _contentTXF;
}
- (void)addSubViews{
    [self addSubview:self.label];
    [self addSubview:self.contentTXF];
}

@end
