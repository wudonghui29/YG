//
//  YLDNumberBindingVC.m
//  YLDGPS
//
//  Created by faith on 17/3/15.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YLDNumberBindingVC.h"
#import "YLDCommon.h"
@interface YLDNumberBindingVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NumbersBindingVIewModel *viewModel;
@property(nonatomic, strong) NSMutableArray *parents;
@property(nonatomic, strong) NSArray *soss;
@property (nonatomic, strong) UITextField *parentTextField1;
@property (nonatomic, strong) UITextField *parentTextField2;
@property (nonatomic, strong) UITextField *parentTextField3;
@property (nonatomic, strong) UITextField *parentTextField4;
@property (nonatomic, strong) UITextField *sosTextField1;

@end

@implementation YLDNumberBindingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"号码绑定";
    [self initTextField];
    [self rac];
    [self addSubViews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
    [self.viewModel getParentNumbersAndSosNumbers];
    
}
- (void)initTextField{
    self.sosTextField1 = [[UITextField alloc] init];
    self.parentTextField1 = [[UITextField alloc] init];
    self.parentTextField2 = [[UITextField alloc] init];
    self.parentTextField3 = [[UITextField alloc] init];
    self.parentTextField4 = [[UITextField alloc] init];
}
- (NSArray *)nameArray{
    if(!_nameArray){
        _nameArray = @[@"按键1号码",@"按键2号码",@"按键3号码",@"按键4号码"];
    }
    return _nameArray;
}
- (NSMutableArray *)parents{
    if(!_parents){
        _parents = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"", nil];
    }
    return _parents;
}
- (NSArray *)soss{
    if(!_soss){
        _soss = [[NSArray alloc] init];
    }
    return _soss;
}

#pragma mark - getters and setters
- (NumbersBindingVIewModel*)viewModel{
    if(_viewModel == nil){
        _viewModel = [[NumbersBindingVIewModel alloc] init];
        _viewModel.deviceID = self.deviceID;
    }
    return _viewModel;
}

- (void)addSubViews{
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [saveButton setTitleColor:HomeNavigationBar_COLOR forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
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
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section ==0){
        return 1;
    }
    return 4;
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
    NSInteger section = indexPath.section;
    UITableViewCell *cell;
    if(section ==0){
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        NSInteger labelTag = 110;
        UILabel *label = (UILabel*)[cell.contentView viewWithTag:labelTag];
        if(label == nil){
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 135, 20)];
            label.tag = labelTag;
            label.textColor = COLOR_WITH_HEX(0x333333);
            label.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:label];
        }
        label.text = @"SOS号码(主号码)";
        NSInteger textFieldTag = 111;
        UITextField *textField = (UITextField*)[cell.contentView viewWithTag:textFieldTag];
        if(textField == nil){
            textField = [[UITextField alloc] initWithFrame:CGRectMake(150, 12, kScreenWidth-150, 20)];
            textField.tag = labelTag;
            textField.textColor = COLOR_WITH_HEX(0x333333);
            textField.font = [UIFont systemFontOfSize:16];
            textField.placeholder = @"请输入号码";
            textField.text = [self.soss firstObject];
            [cell.contentView addSubview:textField];
        }
        self.sosTextField1 = textField;
        label.text = @"SOS号码 (主号码) ";


    }else if(section ==1){
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        NSInteger labelTag = indexPath.row+1000;
        UILabel *label = (UILabel*)[cell.contentView viewWithTag:labelTag];
        if(label == nil){
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 20)];
            label.tag = labelTag;
            label.textColor = COLOR_WITH_HEX(0x333333);
            label.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:label];
        }
        label.text = self.nameArray[indexPath.row];
        NSInteger textFieldTag = indexPath.row+2000;
        UITextField *textField = (UITextField*)[cell.contentView viewWithTag:textFieldTag];
        if(textField == nil){
            textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 12, kScreenWidth-150, 20)];
            textField.tag = labelTag;
            textField.textColor = COLOR_WITH_HEX(0x333333);
            textField.font = [UIFont systemFontOfSize:16];
            textField.placeholder = @"请输入号码";
            textField.text = self.parents[indexPath.row];
            
            [cell.contentView addSubview:textField];
            if(indexPath.row ==0){
                self.parentTextField1 = textField;
            }else if (indexPath.row ==1){
                self.parentTextField2 = textField;

            }else if (indexPath.row ==2){
                self.parentTextField3 = textField;
                
            }else if (indexPath.row ==3){
                self.parentTextField4 = textField;
                
            }


        }
    }
    return cell;
}
- (void)rac{
    
    @weakify(self);
    
    RAC(self.viewModel, parentNumbers) = [RACSignal combineLatest:@[RACObserve(self.parentTextField1, text),
                                                                    RACObserve(self.parentTextField2, text),                                                                    RACObserve(self.parentTextField3, text),
                                                                   RACObserve(self.parentTextField4, text)]
                                                          reduce:^id{
                                                               return [NSString stringWithFormat:@"%@|%@|%@|%@", self.parentTextField1.text, self.parentTextField2.text, self.parentTextField3.text, self.parentTextField4.text];                                                           }                                          ];
    RAC(self.viewModel, sosNumbers) = [RACSignal combineLatest:@[RACObserve(self.sosTextField1, text)]                                                       reduce:^id{
                                                           return [NSString stringWithFormat:@"%@", self.sosTextField1.text];
                                                       }
                                     ];
   
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
//    [[defaultCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification *notification) {
//        @strongify(self);
//        CGRect keyBoardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        UIScrollView *sv = self.scrollView;
//        sv.contentSize = CGSizeMake(sv.frame.size.width, (CGRectGetMaxY(self.parentTextField4.frame) + keyBoardRect.size.height + 30));
//    }];
//    
//    [[defaultCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
//        @strongify(self);
//        UIScrollView *sv = self.scrollView;
//        sv.contentSize = CGSizeMake(sv.frame.size.width, CGRectGetMaxY(self.parentTextField4.frame));
//    }];
    
    [[RACObserve(self.viewModel, r) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(self.viewModel.r){
            NSArray *parents = [self.viewModel.parentNumbers componentsSeparatedByString:@"|"];
            for(int i =0; i <parents.count; i++){
                self.parents[i] = parents[i];
            }
            NSArray *soss = [self.viewModel.sosNumbers componentsSeparatedByString:@"|"];
            self.soss = soss;
            [self.tableView reloadData];
//            if(parents.count > 0){
//                self.parentTextField1.text = parents.firstObject;
//            }
//            if(parents.count > 1){
//                self.parentTextField2.text = parents[1];
//            }
//            if(parents.count > 2){
//                self.parentTextField3.text = parents[2];
//            }
//            if(parents.count > 3){
//                self.parentTextField4.text = parents.lastObject;
//            }
//            if(soss.count > 0){
//                self.sosTextField1.text = soss.firstObject;
//            }
        }
        if(self.viewModel.msg.length > 0){
            TSMessageNotificationType type = self.viewModel.r?TSMessageNotificationTypeSuccess:TSMessageNotificationTypeError;
            [TSMessage showNotificationWithTitle:self.viewModel.msg type:type];
        }
    }];
    
    [[RACObserve(self.viewModel, r1) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(self.viewModel.r1){
            
        }
        if(self.viewModel.msg.length > 0){
            TSMessageNotificationType type = self.viewModel.r1?TSMessageNotificationTypeSuccess:TSMessageNotificationTypeError;
            [TSMessage showNotificationWithTitle:self.viewModel.msg type:type];
        }
    }];
    
}

- (void)save{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
    [self.viewModel modifParentNumbersAndSosNUmbers];
//    [self resignSomething];
}

@end
