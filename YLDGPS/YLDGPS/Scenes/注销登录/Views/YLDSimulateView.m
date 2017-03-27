//
//  YLDSimulateView.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDSimulateView.h"
@interface YLDSimulateView()
@property(nonatomic, strong) UILabel *titleLbl;
@property(nonatomic, strong) UIImageView *imageView;
@end
@implementation YLDSimulateView
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
- (UILabel *)titleLbl{
    if(!_titleLbl){
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
        _titleLbl.font = [UIFont systemFontOfSize:12];
        _titleLbl.text = @"模拟体验";
    }
    return _titleLbl;
}
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 6, 7, 13)];
        _imageView.image = [UIImage imageNamed:@"模拟体验"];
    }
    return _imageView;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if(self.simulateBlock){
        self.simulateBlock();
    }
}
@end
