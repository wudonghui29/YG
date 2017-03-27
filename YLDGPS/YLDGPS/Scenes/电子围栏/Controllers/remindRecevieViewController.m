//
//  remindRecevieViewController.m
//  YLDGPS
//
//  Created by user on 15/7/18.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "remindRecevieViewController.h"
#import "YLDCommon.h"

//const
const static CGFloat cellHeight = 40;
const static CGFloat cellHeadHeight = 35;

@interface remindRecevieViewController ()
@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) NSArray                   *tableList;
@property (nonatomic, assign) NSInteger                 receiveInterval;
@property (nonatomic, assign) NSInteger                 receiveTimes;
@end

@implementation remindRecevieViewController

#pragma mark - life cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    self.title = localizedString(@"remindReceive");
//    [self initNavbar];
    [self rac];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGRect frame = self.view.bounds;
    
    self.tableView.frame = frame;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = self.tableList[section];
    NSArray *titles = dic[@"title"];
    return titles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = self.tableList[section];
    NSString *head = dic[@"head"];
    head = localizedString(head);
    return head;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"fenceEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSDictionary *dic = self.tableList[section];
    NSArray *titles = dic[@"title"];
    cell.textLabel.text = localizedString(titles[row]);
    
    BOOL needTick = NO;
    switch (section) {
        case 0:{
            needTick = (row == self.receiveInterval);
        }
            break;
            
        case 1:{
            needTick = (row == self.receiveTimes);
        }
            break;
            
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"tickIocn"];
    CGFloat viewWidth = 24;
    CGFloat viewHeight = 24;
    CGFloat rightGap = 10;
    imageView.frame = CGRectMake((tableView.frame.size.width - rightGap - viewWidth), (cellHeight - viewHeight)/2, viewWidth, viewHeight);

    if(needTick){
        imageView.image = [UIImage imageNamed:@"on"];
    }else{
        imageView.image = [UIImage imageNamed:@"off"];
    }
    cell.accessoryView = imageView;

    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return cellHeadHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:{
            self.receiveInterval = row;
        }
            break;
            
        case 1:{
            self.receiveTimes = row;
        }
            break;
            
    }
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark - event response
- (void)navLeftButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private methods
- (void)rac{
    @weakify(self);
    RAC(self.viewModel, receiveInterval) = [RACSignal combineLatest:@[RACObserve(self, receiveInterval)] reduce:^id{
        @strongify(self);
        return [NSNumber numberWithInteger:self.receiveInterval];
    }];
    RAC(self.viewModel, receiveTimes) = [RACSignal combineLatest:@[RACObserve(self, receiveTimes)] reduce:^id{
        @strongify(self);
        return [NSNumber numberWithInteger:self.receiveTimes];
    }];
}

#pragma mark - getters and setters
- (UITableView*)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray*)tableList{
    if(_tableList == nil){
        _tableList = @[@{@"head":@"receiveInterval", @"title":@[@"receiveInterval1", @"receiveInterval2", @"receiveInterval3", @"receiveInterval4"]},
                       @{@"head":@"receiveTimes", @"title":@[@"receiveTimes1", @"receiveTimes2", @"receiveTimes3"]}];
    }
    return _tableList;
}

- (void)setViewModel:(remindRecevieViewModel *)viewModel{
    _viewModel = viewModel;
    self.receiveInterval = _viewModel.receiveInterval;
    self.receiveTimes = _viewModel.receiveTimes;
}

@end
