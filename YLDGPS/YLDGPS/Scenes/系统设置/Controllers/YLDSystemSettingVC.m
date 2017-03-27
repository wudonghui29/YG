//
//  YLDSystemSettingVC.m
//  YLDGPS
//
//  Created by faith on 17/3/10.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDSystemSettingVC.h"
#import "YLDCommon.h"
@interface YLDSystemSettingVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation YLDSystemSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    [self addSubViews];
}

- (void)addSubViews{
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
        

        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [YLDShow fullSperatorLine:_tableView];
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = COLOR_WITH_HEX(0xf2f4f5);
    return headView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *title;
    UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    moreImage.image = [UIImage imageNamed:@"nest"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"1.0";
    if(section ==0){
        switch(row){
            case 0:{
                title = @"地图切换";
                switch ([YLDDataManager manager].userData.userMapSelected) {
                    case userMapBaidu:
                        title = [NSString stringWithFormat:@"%@(%@)",title,localizedString(@"baiduMap")];
                        break;
                        
                    case userMapGoogle:
                        title = [NSString stringWithFormat:@"%@(%@)",title,localizedString(@"googleMap")];
                        
                        break;
                }

            }
                break;
            case 1:{
                title = @"修改密码";
            }
                break;
                
        }
        cell.textLabel.text = title;
        cell.accessoryView = moreImage;
    }else if (section ==1){
        if(row ==0){
            title = @"当前版本";
            cell.accessoryView = label;
        }else if(row ==1){
            title = @"检查新版本";
        }

    }
    cell.textLabel.text = title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(section ==0){
        if(row ==0){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:localizedString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:localizedString(@"baiduMap") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([YLDDataManager manager].userData.userMapSelected != userMapBaidu){
                    [YLDDataManager manager].userData.userMapSelected = userMapBaidu;
                }
                [self.tableView reloadData];
            }];

            UIAlertAction *googleMapAction = [UIAlertAction actionWithTitle:localizedString(@"googleMap") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([YLDDataManager manager].userData.userMapSelected != userMapGoogle){
                    [YLDDataManager manager].userData.userMapSelected = userMapGoogle;
                }
                [self.tableView reloadData];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:baiduMapAction];
            [alertController addAction:googleMapAction];
            [self presentViewController:alertController animated:YES completion:nil]
            ;

        }else if(row ==1){
            YLDChangePasswordVC *changePasswordVC = [[YLDChangePasswordVC alloc] init];
            [self.navigationController pushViewController:changePasswordVC animated:YES];
        }
    
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 补全分割线
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
