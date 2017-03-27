//
//  TimePickerView.m
//  YLDGPS
//
//  Created by user on 16/4/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import "TimePickerView.h"
#import "YLDCommon.h"
#import <ReactiveCocoa.h>

@interface TimePickerView ()
@property (nonatomic, copy) TimePickerCompletionBlock   completedBlock;
@property (nonatomic, strong) UIView                    *alphaView;
@property (nonatomic, strong) UIView                    *contentView;
@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UIDatePicker              *datePicker;
@property (nonatomic, strong) UIButton                  *confirmBtn;
@property (nonatomic, strong) UIButton                  *cancelBtn;
@end

@implementation TimePickerView
#pragma mark - static methods 
+ (TimePickerView*)showInView:(UIView*)view title:(NSString*)title completed:(TimePickerCompletionBlock)completedBlock {
    TimePickerView *timePickerView = [[TimePickerView alloc] init];
    if(timePickerView != nil) {
        [view addSubview:timePickerView];
        timePickerView.completedBlock = completedBlock;
        timePickerView.titleLabel.text = title;
        [timePickerView setup];
        [timePickerView show];
        [timePickerView textLanguage];
        [timePickerView rac];
    }
    return timePickerView;
}

#pragma mark - life cyle
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self addSubview:self.alphaView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.datePicker];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.cancelBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    self.alphaView.frame = frame;
    
    frame.size.height = self.bounds.size.height/10*5;
    frame.origin.y = self.bounds.size.height - frame.size.height;
    self.contentView.frame = frame;
    
    frame.origin.x = 10;
    frame.origin.y = 6;
    frame.size.width = self.contentView.frame.size.width - frame.origin.x*2;
    frame.size.height = self.titleLabel.font.lineHeight;
    self.titleLabel.frame = frame;
    
    CGFloat btnAndPickerGap = 10;
    CGFloat btnAndBottomGap = 12;
    CGFloat btnHeight = 40;
    CGFloat btnAndBtnGap = 20;
    
    frame.origin.x = 10;
    frame.origin.y = CGRectGetMaxY(self.titleLabel.frame) + 6;
    frame.size.width = self.contentView.frame.size.width - frame.origin.x*2;
    frame.size.height = self.contentView.frame.size.height - frame.origin.y - btnAndBottomGap - btnHeight - btnAndPickerGap;
    self.datePicker.frame = frame;
    
    frame.origin.x = 15;
    frame.origin.y = CGRectGetMaxY(self.datePicker.frame) + btnAndPickerGap;
    frame.size.width = (self.contentView.frame.size.width - frame.origin.x*2 - btnAndBtnGap)/2;
    frame.size.height = btnHeight;
    self.confirmBtn.frame = frame;
    
    frame.origin.x = CGRectGetMaxX(self.confirmBtn.frame) + btnAndBtnGap;
    self.cancelBtn.frame = frame;

}

#pragma mark - private methods
- (void)rac {
    @weakify(self);
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        if(self.completedBlock != nil) {
            
            NSDate *date = self.datePicker.date;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSString *str = [dateFormatter stringFromDate:date];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            
            NSString *str1 = [dateFormatter stringFromDate:date];
            
            str = [str stringByAppendingString:@" 00:00"];
            NSDate *date1 = [dateFormatter dateFromString:str];
            NSDate *date2 = [dateFormatter dateFromString:str1];
            
            NSTimeInterval timeInterval = date2.timeIntervalSinceNow - date1.timeIntervalSinceNow;
            NSInteger hourInt = timeInterval/60/60;
            
            NSArray *dateArr = [str1 componentsSeparatedByString:@":"];
            NSString *hour = [NSString stringWithFormat:@"%d", (int)hourInt];
            NSString *minute = dateArr.lastObject;
            
            self.completedBlock(hour, minute, NO);
            
        }
        
        [self hiden];
    }];
    
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if(self.completedBlock != nil) {
            self.completedBlock(nil, nil, YES);
        }
        [self hiden];
    }];
}

- (void)textLanguage {
    [self.confirmBtn setTitle:localizedString(@"confirm") forState:UIControlStateNormal];
    [self.cancelBtn setTitle:localizedString(@"cancel") forState:UIControlStateNormal];
}

- (void)setup {
    self.frame = self.superview.bounds;
}

- (void)show {
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height;
    self.contentView.frame = frame;
    self.alphaView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame1 = self.contentView.frame;
        frame1.origin.y = self.frame.size.height - frame1.size.height;
        self.contentView.frame = frame1;
        self.alphaView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hiden {
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height - frame.size.height;
    self.contentView.frame = frame;
    self.alphaView.alpha = 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame1 = self.contentView.frame;
        frame1.origin.y = self.frame.size.height;
        self.contentView.frame = frame1;
        self.alphaView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - getters and setters
- (UIView*)alphaView {
    if(_alphaView == nil) {
        _alphaView = [[UIView alloc] init];
        _alphaView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return _alphaView;
}

- (UIView*)contentView {
    if(_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel*)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIDatePicker*)datePicker {
    if(_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
    return _datePicker;
}

- (UIButton*)confirmBtn {
    if(_confirmBtn == nil){
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.backgroundColor = COLOR_WITH_HEX(0x3C9ED2);
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _confirmBtn.layer.cornerRadius = 4;
        _confirmBtn.layer.masksToBounds = YES;
        
    }
    return _confirmBtn;
}

- (UIButton*)cancelBtn {
    if(_cancelBtn == nil){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = COLOR_WITH_HEX(0x3C9ED2);
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _cancelBtn.layer.cornerRadius = 4;
        _cancelBtn.layer.masksToBounds = YES;
        
    }
    return _cancelBtn;
}

@end
