//
//  YLDRemindReceiveVC.m
//  YLDGPS
//
//  Created by faith on 17/3/14.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDRemindReceiveVC.h"
#import "YLDCommon.h"
//const
const static CGFloat cellHeight = 44;
const static CGFloat cellHeadHeight = 44;
@interface YLDRemindReceiveVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableList;
@property (nonatomic, assign) NSInteger receiveInterval;
@property (nonatomic, assign) NSInteger receiveTimes;

@end

@implementation YLDRemindReceiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"接收提醒";
    [self.view addSubview:self.tableView];

}
- (UITableView*)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (NSArray*)tableList{
    if(_tableList == nil){
        _tableList = @[@{@"head":@"请选择接收间隔时间", @"title":@[@"5分钟", @"10分钟", @"15分钟", @"30分钟"]},
                       @{@"head":@"请选择一天内接收次数的上限", @"title":@[@"1次/24小时", @"2次/24小时", @"3次/24小时"]}];
    }
    return _tableList;
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
    cell.textLabel.text = titles[row];
    
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
    imageView.image = [UIImage imageNamed:@"on"];
    CGFloat viewWidth = 20;
    CGFloat viewHeight = 20;
    CGFloat rightGap = 10;
    imageView.frame = CGRectMake((tableView.frame.size.width - rightGap - viewWidth), (cellHeight - viewHeight)/2, viewWidth, viewHeight);
    if(needTick){
        imageView.image = [UIImage imageNamed:@"on"];
    }else{
        imageView.image = [UIImage imageNamed:@"off"];
    }
    cell.accessoryView = imageView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
- (void)back{
    [super back];
    NSString *receiveIntervalStr = @"5分钟";
    if(self.receiveInterval ==0){
        receiveIntervalStr = @"5分钟";
    }else if (self.receiveInterval ==1){
        receiveIntervalStr = @"10分钟";
    }else if (self.receiveInterval ==2){
        receiveIntervalStr = @"15分钟";
    }else if (self.receiveInterval ==3){
        receiveIntervalStr = @"30分钟";
    }
    NSString *receiveTimesStr = @"1次/24小时";
    if(self.receiveTimes ==0){
        receiveTimesStr = @"1次/24小时";
    }else if (self.receiveTimes ==1){
        receiveTimesStr = @"2次/24小时";

    }else if (self.receiveTimes ==2){
        receiveTimesStr = @"3次/24小时";
        
    }
    
    if(self.selectIntervalTimeBlock){
        self.selectIntervalTimeBlock(receiveIntervalStr,receiveTimesStr);
    }
    
    
}

@end
