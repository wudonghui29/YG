//
//  YLDNavigationView.m
//  YLDGPS
//
//  Created by faith on 17/3/11.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDNavigationView.h"
#import "YLDCommon.h"
@interface YLDNavigationView()
@property(nonatomic, strong) UILabel *titleLbl;
@property(nonatomic, strong) UIImageView *imageView;
@end
@implementation YLDNavigationView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = HomeNavigationBar_COLOR;
        self.layer.cornerRadius = 20;
        [self.layer setMasksToBounds:YES];
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
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, 10, 40, 24)];
        _titleLbl.font = [UIFont systemFontOfSize:17];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.text = @"导航";
    }
    return _titleLbl;
}
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2+20, 14, 16, 16)];
        _imageView.image = [UIImage imageNamed:@"导航"];
    }
    return _imageView;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if(self.navigateBlock){
        self.navigateBlock();
    }
}


@end
