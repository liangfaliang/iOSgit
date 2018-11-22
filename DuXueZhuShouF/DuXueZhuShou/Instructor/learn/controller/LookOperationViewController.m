//
//  LookOperationViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LookOperationViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "OperationFooterView.h"
#import "DescriptionTableViewCell.h"
#import "PostOperationViewController.h"
@interface LookOperationViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)OperationFooterView *footerView;
@end

@implementation LookOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataArray];
    [self.view addSubview:self.tableView];
    if (!self.model) {
        self.navigationBarTitle = @"查看作业";
        [self UpData];
    }else{
        self.navigationBarTitle = @"预览作业";
    }
}
-(void)UpData{
    [super UpData];
    [self getData];
}
-(OperationFooterView *)footerView{
    if (_footerView == nil) {
        _footerView = [[NSBundle mainBundle]loadNibNamed:@"OperationFooterView" owner:nil options:nil].firstObject;
        _footerView.frame = CGRectMake(0, screenH - 60, screenW, 60);
        if (self.model.status.integerValue == 2) {//已发布
            _footerView.deleteBtn.hidden = NO;
        }else{
            _footerView.deleteBtn.hidden = YES;
        }
        [_footerView.btn1 setTitle:@"编辑" forState:UIControlStateNormal];
//
        WEAKSELF;
        _footerView.btnClickBlcok = ^(NSInteger tag) {
            if (tag == 2) {//预览
                LookOperationViewController *vc = [[LookOperationViewController alloc]init];
                vc.model = weakSelf.model;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (tag == 4){//删除
                [weakSelf DeleteData];
            }else if (tag == 1){//编辑
                PostOperationViewController *vc = [[PostOperationViewController alloc]init];
                vc.model = weakSelf.model;
                vc.successBlock = ^{
                    [weakSelf UpData];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                [weakSelf UpdateLoad:tag == 1 ? @"2" :@"1"];
            }
        };
    }
    return _footerView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = nil;
        if (!self.model) {
            array = @[@{@"name":@"接受学生组",@"text":@"",@"key":@""},
                      @{@"name":@"作业下发时间",@"text":@"",@"key":@"start_time"},
                      @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"end_time"},
                      @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"clock_time"}];
        }else{
            array = @[@{@"name":@"最晚打卡时间",@"text":[UserUtils getShowDateWithTime:self.model.end_time dateFormat:@"yyyy-MM-dd HH:mm"]}];
        }
        for (NSDictionary *dt in array) {
            TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"DescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DescriptionTableViewCell"];
    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model ? 2 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DescriptionTableViewCell class]) forIndexPath:indexPath];
//        [cell setNamelbText:[UserUtils getShowDateWithTime:self.model.start_time dateFormat:@"yyyy-MM-dd HH:mm"]];
        NSString *str  = [NSString stringWithFormat:@"%@\n%@",self.model.subject.name,[UserUtils getShowDateWithTime:self.model.start_time dateFormat:@"yyyy.MM.dd HH:mm"]];
        [cell setNamelbattributedText:[cell getAttribute:str title:self.model.subject.name]];
        cell.contentLb.text = self.model.content;
        [cell setImageArr:self.model.imageArr];
        [cell.contentLb NSParagraphStyleAttributeName:5];
        return cell;
    }
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
#pragma mark - 获取数据
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.OperateID) {
        [dt setObject:self.OperateID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationInsDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            [OperateSubmitModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"imageArr" : @"images"};
            }];
            self.model = [OperateSubmitModel mj_objectWithKeyValues:response[@"data"]];
            [OperateSubmitModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            if (self.model.imageArr.count) {
                for (NSString *image in self.model.imageArr) {
                    self.model.images = [image SeparatorStr:self.model.images];
                }
            }
            self.model.subject_id = self.model.subject.ID;
            self.model.group_id = self.model.group.ID;
            if ([UserUtils getUserRole] == UserStyleInstructor){
                for (TextFiledModel *cmo in self.dataArray) {
                    if (cmo.key.length) {
                        cmo.text = [UserUtils getShowDateWithTime:[self.model valueForKey:cmo.key] dateFormat:@"yyyy-MM-dd HH:mm"];
                    }else{
                        cmo.text = self.model.group.name;
                    }
                }
            }
            if (self.model.status.integerValue != 3) {
                self.tableView.height_i = screenH - 60;
                [self.view addSubview:self.footerView];
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
#pragma mark - 删除
- (void)DeleteData{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.OperateID) {
        [dt setObject:self.OperateID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationInsDeleteUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"删除:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            if (self.successBlock) {
                self.successBlock(YES);
            }
            [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
        }
        [self presentLoadingTips:response[@"msg"]];

    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark 提交
-(void)UpdateLoad:(NSString *)type{//1发布，2保存
    NSMutableDictionary *mdt = [self.model mj_keyValues];
    [mdt removeObjectForKey:@"imageArr"];
    [mdt removeObjectForKey:@"group"];
    [mdt removeObjectForKey:@"subject"];
    [mdt setObject:type forKey:@"type"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, OperationEditSubmitUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"tijaio:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSLog(@"注册成功");
            if (self.successBlock) {
                self.successBlock(NO);
            }
            [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
        }
        [AlertView showMsg:response[@"msg"]];
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}
-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
