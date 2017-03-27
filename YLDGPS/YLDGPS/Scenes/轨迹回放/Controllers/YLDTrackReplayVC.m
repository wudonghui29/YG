//
//  YLDTrackReplayVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDTrackReplayVC.h"
#import "YLDCommon.h"
@interface YLDTrackReplayVC ()<FSCalendarDelegate, HourPickerDlegate>{
    BOOL isStartTimePicker;
    BOOL isSelected;
}
@property (nonatomic, strong) deviceTrackViewModel          *viewModel;
@property (nonatomic, strong) UIScrollView                  *scrollView;
@property (nonatomic, strong) FSCalendar                    *calendar;
@property (nonatomic, strong) UIButton                      *startTimeBtn;
@property (nonatomic, strong) UIButton                      *endTimeBtn;
@property (nonatomic, strong) UIButton                      *switchBtn;
@property (nonatomic, strong) UIButton                      *queryButton;
@property (nonatomic, strong) HourPickerView                *hourPickerView;

@property (nonatomic, strong) UILabel                       *lbsLabel;
@property (nonatomic, copy)   NSString                      *startTime;
@property (nonatomic, copy)   NSString                      *endTime;
@property (nonatomic , strong) NSMutableArray *items;


@end

@implementation YLDTrackReplayVC
@synthesize items = _items;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轨迹回放";
    isSelected = YES;
    self.view .backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    
    YLDSelectDeviceView *selectDeviceView = [[YLDSelectDeviceView alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 0, 110, 20)];
    
    __block YLDSelectDeviceView *weakSelectDeviceView = selectDeviceView;
    NSDictionary *deviceDic = [YLDDataManager manager].currentDevice;
    weakSelectDeviceView.typeString = deviceDic[@"nick_name"];
    selectDeviceView.selectBlock = ^{
        [YCXMenu setTintColor:COLOR_WITH_HEX(0x666666)];
        if ([YCXMenu isShow]){
            [YCXMenu dismissMenu];
        } else {
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 90, 0, 80, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
                weakSelectDeviceView.typeString = item.title;
                NSMutableArray *array = [YLDDataManager manager].devices;
                for(NSDictionary *dic in array){
                    if([dic[@"nick_name"] isEqualToString:item.title]){
                        [[YLDDataManager manager] setCurrentDevice:dic];
                        break;
                    }
                }
            }];
        }
        
    };
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectDeviceView];
    self.navigationItem.rightBarButtonItem = selectItem;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = COLOR(200, 200, 200, 1);
    [self.view addSubview:lineView];
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:b];
    [b addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.calendar];
    [self.scrollView addSubview:self.startTimeBtn];
    [self.scrollView addSubview:self.endTimeBtn];
    [self.scrollView addSubview:self.lbsLabel];
    [self.scrollView addSubview:self.queryButton];
    [self.scrollView addSubview:self.switchBtn];
    [self.view addSubview:self.hourPickerView];
    [self rac];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UIScrollView  *sv = self.scrollView;
    
    CGRect frame = self.view.bounds;
    
    sv.frame = frame;
    
    frame.size.width = sv.frame.size.width - frame.origin.x*2;
    frame.size.height = 300;
    self.calendar.frame = frame;
    
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(frame);
    frame.size.width = sv.frame.size.width;
    frame.size.height = 38;
    self.startTimeBtn.frame = frame;
    
    frame.origin.x = self.startTimeBtn.frame.origin.x;
    frame.origin.y = CGRectGetMaxY(frame)+1;
    frame.size = self.startTimeBtn.frame.size;
    self.endTimeBtn.frame = frame;
    
//    CGFloat lbsLableWidth = 70;
//    CGFloat lbsLabeAndSwitchGap = 5;
//    
//    frame.size.height = 35;
//    frame.size.width = 60;
//    frame.origin.x = (sv.frame.size.width - frame.size.width - lbsLableWidth - lbsLabeAndSwitchGap)/2;
//    frame.origin.y = CGRectGetMaxY(frame) + 7;
//    self.lbsSwitch.frame = frame;
//    
//    frame.origin.x = CGRectGetMaxX(frame) + lbsLabeAndSwitchGap;
//    frame.size.width = lbsLableWidth;
//    self.lbsLabel.frame = frame;
    
    frame.origin.x = 20;
    frame.origin.y = CGRectGetMaxY(frame) + 30;
    frame.size.width = sv.frame.size.width - frame.origin.x*2;
    frame.size.height = 44;
    self.queryButton.frame = frame;
    
    frame.origin.x = kScreenWidth/2 - 48;
    frame.origin.y = CGRectGetMaxY(frame) + 15;
    frame.size.width = 24;
    frame.size.height = 24;
    self.switchBtn.frame = frame;
    
    frame.origin.x = kScreenWidth/2 - 20;
    frame.size.width = 120;
    self.lbsLabel.frame = frame;

    
    sv.contentSize = CGSizeMake(0, CGRectGetMaxY(frame) + 15);
    
}

#pragma mark - FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    [self setQueryTime];
}

#pragma mark HourPickerDlegate
- (void)hourPickerConfirm:(HourPickerView*)hourPicker{
    if(isStartTimePicker){
        self.startTime = [NSString stringWithFormat:@"%.0f000", (self.calendar.selectedDate.timeIntervalSince1970 + hourPicker.hour*60*60 + hourPicker.minute*60)];
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *comps = [calendar1 components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:self.viewModel.startTime.doubleValue/1000]];
        [self.startTimeBtn setTitle:[NSString stringWithFormat:@"%@: %02ld:%02ld", @"开始时间", (long)comps.hour, (long)comps.minute] forState:UIControlStateNormal];
    }else{
        self.endTime = [NSString stringWithFormat:@"%.0f000", (self.calendar.selectedDate.timeIntervalSince1970 + hourPicker.hour*60*60 + hourPicker.minute*60)];
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *comps = [calendar1 components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:self.viewModel.endTime.doubleValue/1000]];
        [self.endTimeBtn setTitle:[NSString stringWithFormat:@"%@: %02ld:%02ld", @"结束时间", (long)comps.hour, (long)comps.minute] forState:UIControlStateNormal];
    }
    
    [self setQueryTime];
}

#pragma mark - event response
- (void)navLeftButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private methods
- (void)initNavbar{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    UIButton *navLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [navLeftButton addTarget:self action:@selector(navLeftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    navLeftButton.frame = CGRectMake(0, 0, 20, 20);
    navLeftButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [navLeftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navLeftButton setTitle:@"<" forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navLeftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)textLanguage{
    self.lbsLabel.text = @"过滤LBS";
    [self.queryButton setTitle:@"查询" forState:UIControlStateNormal];
}

- (void)rac{
    @weakify(self);
    [[RACObserve(self.viewModel, r) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(self.viewModel.r){
            //            trackViewController *ctrl = [[trackViewController alloc] init];
            //            ctrl.tracks = self.viewModel.locations;
            //            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            //            [self presentViewController:navCtrl animated:YES completion:nil];
        }
        
        if(self.viewModel.msg.length > 0){
            //            [TSMessage showNotificationWithTitle:self.viewModel.msg type:self.viewModel.r?TSMessageNotificationTypeSuccess:TSMessageNotificationTypeError];
        }
    }];
    //
    
    RAC(self.viewModel, startTime) = [RACSignal combineLatest:@[[RACObserve(self, startTime) skip:1]] reduce:^id{
        return self.startTime;
    }];
    RAC(self.viewModel, endTime) = [RACSignal combineLatest:@[[RACObserve(self, endTime) skip:1]] reduce:^id{
        return self.endTime;
    }];
    [[self.startTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *comps = [calendar1 components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:self.viewModel.startTime.doubleValue/1000]];
        self.hourPickerView.hour = comps.hour;
        self.hourPickerView.minute = comps.minute;
        [self.hourPickerView show];
        isStartTimePicker = YES;
    }];
    [[self.endTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *comps = [calendar1 components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:self.viewModel.endTime.doubleValue/1000]];
        self.hourPickerView.hour = comps.hour;
        self.hourPickerView.minute = comps.minute;
        [self.hourPickerView show];
        isStartTimePicker = NO;
    }];
    [[self.queryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        [self.viewModel getDeviceTrack];
    }];
}

- (void)setQueryTime{
    NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar1 components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:self.startTime.doubleValue/1000]];
    self.startTime = [NSString stringWithFormat:@"%.0f000", (self.calendar.selectedDate.timeIntervalSince1970 + comps.hour*60*60 + comps.minute*60)];
    comps = [calendar1 components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:self.endTime.doubleValue/1000]];
    self.endTime = [NSString stringWithFormat:@"%.0f000", (self.calendar.selectedDate.timeIntervalSince1970 + comps.hour*60*60 + comps.minute*60)];
}

#pragma mark - getters and setters
- (deviceTrackViewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[deviceTrackViewModel alloc] init];
        _viewModel.deviceID = self.deviceID;
    }
    return _viewModel;
}

- (UIScrollView*)scrollView{
    if(_scrollView == nil){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (FSCalendar*)calendar{
    if(_calendar == nil){
        _calendar = [[FSCalendar alloc] init];
        _calendar.delegate = self;
    }
    return _calendar;
}

- (UIButton*)startTimeBtn{
    if(_startTimeBtn == nil){
        _startTimeBtn = [[UIButton alloc] init];
        _startTimeBtn.backgroundColor = [UIColor clearColor];
        _startTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_startTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startTimeBtn setTitleColor:COLOR_WITH_HEX(0x333333) forState:UIControlStateHighlighted];
        [_startTimeBtn setBackgroundColor:[UIColor whiteColor]];
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *comps = [calendar1 components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:self.viewModel.startTime.doubleValue/1000]];
        [_startTimeBtn setTitle:[NSString stringWithFormat:@"%@: %02ld:%02ld", @"开始时间", (long)comps.hour, (long)comps.minute] forState:UIControlStateNormal];
    }
    return _startTimeBtn;
}

- (UIButton*)endTimeBtn{
    if(_endTimeBtn == nil){
        _endTimeBtn = [[UIButton alloc] init];
        _endTimeBtn.backgroundColor = [UIColor clearColor];
        _endTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_endTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_endTimeBtn setTitleColor:COLOR_WITH_HEX(0x333333) forState:UIControlStateHighlighted];
        [_endTimeBtn setBackgroundColor:[UIColor whiteColor]];
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *comps = [calendar1 components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:self.viewModel.endTime.doubleValue/1000]];
        [_endTimeBtn setTitle:[NSString stringWithFormat:@"%@: %02ld:%02ld", @"结束时间", (long)comps.hour, (long)comps.minute] forState:UIControlStateNormal];
    }
    return _endTimeBtn;
}


- (UILabel*)lbsLabel {
    if(_lbsLabel == nil) {
        _lbsLabel = [[UILabel alloc] init];
        _lbsLabel.textColor = COLOR_WITH_HEX(0x333333);
        _lbsLabel.font = [UIFont systemFontOfSize:12];
        _lbsLabel.text = @"过滤LBS轨迹";
    }
    return _lbsLabel;
}

- (UIButton*)queryButton{
    if(_queryButton == nil){
        _queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _queryButton.backgroundColor = HomeNavigationBar_COLOR;
        _queryButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_queryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_queryButton setTitle:@"确定" forState:UIControlStateNormal];
        [_queryButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _queryButton.layer.cornerRadius = 20;
        _queryButton.layer.masksToBounds = YES;
        
    }
    return _queryButton;
}
- (UIButton *)switchBtn{
    if(_switchBtn == nil){
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
//        [_switchBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }
    return _switchBtn;

}
- (void)switchAction{
    isSelected = !isSelected;
    if(isSelected){
        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    }
    
}
- (HourPickerView*)hourPickerView{
    if(_hourPickerView == nil){
        _hourPickerView = [[HourPickerView alloc] init];
        _hourPickerView.delegate = self;
    }
    return _hourPickerView;
}

- (NSString*)startTime{
    if(_startTime == nil){
        _startTime = self.viewModel.startTime;
    }
    return _startTime;
}

- (NSString*)endTime{
    if(_endTime == nil){
        _endTime = self.viewModel.endTime;
    }
    return _endTime;
}
#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        NSMutableArray *deviceNames = [YLDDataManager manager].deviceNames;
        //set item
        _items = [[NSMutableArray alloc] init];
        for(int i = 0 ; i < deviceNames.count ; i++){
            YCXMenuItem *item =[YCXMenuItem menuItem:deviceNames[i] image:nil tag:100
                            userInfo:@{@"title":@"Menu"}];
            [_items addObject:item];
        }
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}

@end
