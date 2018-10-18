//
//  LeaveResultViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LeaveResultViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "TextFiledModel.h"
#import "DescriptionTableViewCell.h"
#import "AnswerListTableViewCell.h"
#import "PunchSubmitViewController.h"
#import "IQKeyboardManager.h"
@interface LeaveResultViewController ()
<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *replyArray;
@property(nonatomic, strong)UIView *inputView;
@property(nonatomic, strong)UITextField *tfinput;
@property(nonatomic, strong)NSString *parent_id;
@property(nonatomic, strong)LeaveSubModel *model;
@end

@implementation LeaveResultViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //TODO: 页面appear 禁用
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //TODO: 页面Disappear 启用
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    

    [self.view addSubview:self.tableView];
    [self UpData];
    [self.view addSubview:self.inputView];
    [Notification addObserver:self selector:@selector(keyboardHandle:) name:UIKeyboardWillShowNotification object:nil];
    [Notification addObserver:self selector:@selector(keyboardHandle:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)UpData{
    [super UpData];
    [self getData];
    self.page = 1;
    self.more = 0;
    [self getDataList:self.page];
}
-(NSMutableArray *)replyArray{
    if (!_replyArray) {
        _replyArray = [NSMutableArray array];
    }
    return _replyArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UIView *)inputView{
    if (_inputView == nil) {
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(0, screenH, screenW, 50)];
        _inputView.backgroundColor = [UIColor whiteColor];
        [_inputView addSubview:self.tfinput];
        
    }
    return _inputView;
}
-(UITextField *)tfinput{
    if (_tfinput == nil) {
        _tfinput = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, screenW - 70, 50)];
        _tfinput.placeholder = @"请输入回复的内容";
        _tfinput.font = SYS_FONT(15);
        _tfinput.delegate = self;
        _tfinput.returnKeyType = UIReturnKeySend;
    }
    return _tfinput;
}
-(void)createFootview{
    self.tableView.height_i = screenH - 60;
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(15, screenH -  60, screenW -  30,  50)];
    footview.backgroundColor = JHMaincolor;
    [footview setTitle:@"审核" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStylePlain];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"DescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DescriptionTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AnswerListTableViewCell" bundle:nil] forCellReuseIdentifier:@"AnswerListTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf  UpData];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerWithRefresh];
            
        }];
        
    }
    return _tableView;
}
-(void)footerWithRefresh{
    if (self.more == 1) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.page ++;
        [self getDataList:self.page];
    }
}
#pragma mark - 审核
-(void)submitClick{
    PunchSubmitViewController *vc = [[PunchSubmitViewController alloc]init];
    vc.ID = self.model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 键盘通知
- (void)keyboardHandle:(NSNotification *)notify
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (![firstResponder isKindOfClass:[UIView class]]) {
        return;
    }
    if( [firstResponder isKindOfClass:[UITextField class] ])
    {
        //取出键盘的尺寸值
        NSValue *rectValue = notify.userInfo[UIKeyboardFrameEndUserInfoKey];
        CGRect rectKbord = rectValue.CGRectValue;
        //获取通知的名字
        NSString *nameStr = notify.name;
        if ([nameStr isEqualToString:UIKeyboardWillShowNotification])
        {
            self.inputView.frame = CGRectMake(0,screenH - rectKbord.size.height - 50, SCREEN.size.width, 50);
        }
        else
        {//键盘退出
//            self.parent_id
            self.inputView.frame = CGRectMake(0, screenH, screenW, 50);
        }
    }
    
}
#pragma mark - textfileddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self UpdateLoad];
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model ? 4 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)    return self.dataArray.count;
    if (section == 1)    return self.model.content.length ? 1 : 0;
    if (section == 2)    return self.model.check_content.length ? 1 : 0;
    return self.replyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
        TextFiledModel *cmo = self.dataArray[indexPath.row];
        cell.model = cmo;
        cell.textfiled.textAlignment = NSTextAlignmentRight;
        return cell;
    }
    if (indexPath.section == 1 || indexPath.section == 2) {
        DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DescriptionTableViewCell class]) forIndexPath:indexPath];
        cell.nameLb.hidden = YES;
        cell.namelbBottom.constant = 0;
        if (indexPath.section == 1) {
            cell.replyBtn.hidden = YES;
            cell.replyBtnHeight.constant = 0;
            cell.contentLb.text = self.model.content;
            [cell setImageArr:self.model.imagesArr];
        }else{
            
            cell.contentLb.text = self.model.check_content;
            [cell setImageArr:self.model.check_imagesArr];
            if ([UserUtils getUserRole] == UserStyleStudent) {
                cell.replyBtn.hidden = NO;
                cell.replyBtnHeight.constant =30;
                WEAKSELF;
                cell.replyBtnBlock = ^{
                    weakSelf.parent_id = @"0";
                    [weakSelf.tfinput becomeFirstResponder];
                };
            }

        }
        [cell.contentLb NSParagraphStyleAttributeName:5];
        return cell;
    }
    AnswerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerListTableViewCell class]) forIndexPath:indexPath];
    cell.timeLb.userInteractionEnabled = NO;
    cell.rmodel = self.replyArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        if (section == 1)    return self.model.content.length ? 40 : 0.001;
        if (section == 2)    return self.model.check_content.length ? 40 : 0.001;
        return 10;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0 ) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = JHbgColor;
        if (section == 1 && !self.model.content.length)    return header;
        if (section == 2 && !self.model.check_content.length)    return header;
        if (section == 3)    return header;
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 40) font:[UIFont systemFontOfSize:14] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
        lb.text = section == 1 ? @"事由":@"审核意见";
        [header addSubview:lb];
        if ([UserUtils getUserRole] == UserStyleInstructor && section == 2) {
            UILabel *stutas = [UILabel initialization:CGRectMake(screenW - (self.model.status == 2 ? 155 : 65), 0, 50, 40) font:[UIFont systemFontOfSize:14] textcolor:JHAssistRedColor numberOfLines:0 textAlignment:NSTextAlignmentRight];
            stutas.text = self.model.status == 2 ? @"拒绝":@"同意";
            [header addSubview:stutas];
            if (self.model.status == 2) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(screenW - 90, 5, 75, 30)];
                btn.backgroundColor = JHMaincolor;
                btn.layer.cornerRadius = 2;
                btn.layer.masksToBounds = YES;
                [btn setTitle:@"改为同意" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.titleLabel.font = SYS_FONT(14);
                [btn addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];
                [header addSubview:btn];
            }

        }
        return header;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        ReplyModel * mo = self.replyArray[indexPath.row];
        if (mo.can_answer.integerValue == 1) {
            self.parent_id = mo.ID;
            self.tfinput.placeholder = [NSString stringWithFormat:@"回复%@",mo.name];
            [self.tfinput becomeFirstResponder];
        }
    }
}
#pragma mark - 改为同意
-(void)agreeClick{
    [self presentLoadingTips];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,LeaveInsChangeUrl) params:@{@"id":self.model.ID ? self.model.ID : @""} viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            [self UpData];
        }
        [self presentLoadingTips:response[@"msg"]];

    } failure:^(NSError *error) {
        [self dismissTips];
    }];
}
#pragma mark - 获取数据
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,LeaveDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            [LeaveSubModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"imagesArr" : @"images",@"check_imagesArr" : @"check_images",@"category" : @"category_name"};
            }];
            self.model = [LeaveSubModel mj_objectWithKeyValues:response[@"data"]];
            [LeaveSubModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            if (self.model) {
                [self.dataArray removeAllObjects];
                NSArray *array = @[@{@"name":@"请假人",@"key":@"name"},
                                   @{@"name":@"类型",@"key":@"category"},
                                   @{@"name":@"请假开始时间",@"key":@"start_time"},
                                   @{@"name":@"请假结束时间",@"key":@"end_time"}];
                int i = 0;
                for (NSDictionary *dt in array) {
                    TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
                    if (i > 0) {
                        if (i < 2) {
                            model.text = [self.model valueForKey:model.key];
                        }else{
                            model.text = [UserUtils getShowDateWithTime:[self.model valueForKey:model.key] dateFormat:@"yyyy-MM-dd HH:mm"];
                        }
                    }
                    [self.dataArray addObject:model];
                    i ++;
                }
            }
            if ([UserUtils getUserRole] == UserStyleStudent) {
                self.navigationBarTitle  = self.model.is_old ? @"已过期" : (self.model.status == 1 ? @"审核中" : (self.model.status == 2 ? @"审核拒绝" :@"审核通过"));
            }else if ([UserUtils getUserRole] == UserStyleInstructor){
                self.navigationBarTitle = [NSString stringWithFormat:@"%@的请假申请",self.model.name];
                if (!self.model.is_old && self.model.status == 1) {
                    [self createFootview];
                }
            }
            TextFiledModel *cmo =  self.dataArray[0];
            cmo.text = self.model.name;
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"page"];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,LeaveReplyListUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            if (pageNum == 1) {
                [self.replyArray removeAllObjects];
            }
            self.more = [response[@"data"][@"isEnd"] integerValue];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                ReplyModel *model = [ReplyModel mj_objectWithKeyValues:temDt];
                [self.replyArray addObject:model];
            }
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 回复
-(void)UpdateLoad{
    [self presentLoadingTips];
    NSMutableDictionary *mdt = [self.model mj_keyValues];
    if (self.tfinput.text.length) {
        [mdt setObject:self.tfinput.text forKey:@"content"];
    }
    if (self.ID) {
        [mdt setObject:self.ID forKey:@"id"];
    }
    if (self.parent_id) {
        [mdt setObject:self.parent_id forKey:@"parent_id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,LeaveInsReplySubmitUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"tijaio:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSLog(@"注册成功");
            self.tfinput.text = nil;
            _tfinput.placeholder = @"请输入回复的内容";
            [self UpData];
        }
        [AlertView showMsg:response[@"msg"]];
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}
@end
