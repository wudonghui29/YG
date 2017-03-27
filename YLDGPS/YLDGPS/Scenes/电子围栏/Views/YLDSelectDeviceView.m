//
//  YLDSelectDeviceView.m
//  YLDGPS
//
//  Created by faith on 17/3/13.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDSelectDeviceView.h"
#import "YLDCommon.h"
@interface YLDSelectDeviceView()
@property(nonatomic, strong) UILabel *titleLbl;
@property(nonatomic, strong) UIImageView *imageView;
@end
@implementation YLDSelectDeviceView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubViews];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)addSubViews{
    [self addSubview:self.titleLbl];
    [self addSubview:self.imageView];
}
- (void)setTypeString:(NSString *)typeString{
    [_titleLbl removeFromSuperview];
    _titleLbl = nil;
    _typeString = typeString;
    [self addSubViews];
}
- (UILabel *)titleLbl{
    if(!_titleLbl){
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-110, 1, 100, 20)];
        _titleLbl.font = [UIFont systemFontOfSize:14];
        _titleLbl.textAlignment = NSTextAlignmentRight;
        _titleLbl.textColor = COLOR_WITH_HEX(0x333333);
        if(!_typeString) _typeString = @"车型GPS";
        _titleLbl.text = _typeString;
    }
    return _titleLbl;
}
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-5, 15, 5, 6)];
        _imageView.image = [UIImage imageNamed:@"selectShow"];
    }
    return _imageView;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if(self.selectBlock){
        self.selectBlock();
    }
}


@end
