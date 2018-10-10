//
//  AddStudentsViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AddStudentsViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "AddStuSubjectTableViewCell.h"

@interface AddStudentsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation AddStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.isEdit ? @"编辑学员" : @"新增学员";
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)UpData{
    [super UpData];
}
-(AddStuModel *)model{
    if (_model == nil) {
        _model = [[AddStuModel alloc]init];
    }
    return _model;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{@"child":@[@{@"name":@"姓名",@"key":@"name",Tplaceholder:@"请输入",Tprompt:@"请输入姓名"},
                                        @{@"name":@"学号",@"key":@"number",Tplaceholder:@"请输入",Tprompt:@"请输入学号"}]
                             },
                           @{@"child":@[@{@"name":@"",@"key":@""}]
                             },
                           @{@"child":self.isEdit ? @[@{@"name":@"登录账号",@"key":@"username"}]: @[@{@"name":@"登录账号",@"key":@"username",Tplaceholder:@"请输入",Tprompt:@"请输入登录账号"},
                                        @{@"name":@"登录密码",@"key":@"password",Tplaceholder:@"请输入",Tprompt:@"请输入登录密码"}]
                             }];
        for (NSDictionary *dt in array) {
            TextSectionModel *smo = [TextSectionModel mj_objectWithKeyValues:dt];
            for (TextFiledModel *cmo in smo.child) {
                if (!(self.isEdit && [cmo.key isEqualToString:@"username"])) {
                    cmo.enable = @"1";
                }
                
                if (self.isEdit && cmo.key.length) {
                    cmo.text = [self.model valueForKey:cmo.key];
                    cmo.value = [self.model valueForKey:cmo.key];
                }
            }
            [_dataArray addObject:smo];
        }
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AddStuSubjectTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddStuSubjectTableViewCell"];
        _tableView.tableHeaderView  = nil;
        _tableView.tableFooterView = [self createFootview];
//        WEAKSELF;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//            [weakSelf UpData];
//        }];

    }
    return _tableView;
}
-(UIView *)createFootview{
    UIView *footview = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenW ,  200)];
    UIButton *footBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 60, screenW -  30,  50)];
    footBtn.backgroundColor = JHMaincolor;
    [footBtn setTitle:@"确定" forState:UIControlStateNormal];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [footBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:footBtn];
    return footview;
}
-(void)submitClick{
    for (TextSectionModel *smo in self.dataArray) {
        for (TextFiledModel *cmo in smo.child) {
            if ( !cmo.value.length && cmo.prompt ) {
                [self presentLoadingTips:cmo.prompt];
                return;
            }else{
                if (cmo.value.length) {
                    [self.model setValue:cmo.value forKey:cmo.key];
                }
            }
        }
    }
    [self upDateLoad];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TextSectionModel *smo = self.dataArray[section];
    return smo.child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        AddStuSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddStuSubjectTableViewCell" forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
#pragma mark - 提交
- (void)upDateLoad{
    NSMutableDictionary * dt = [self.model mj_keyValues];
    if (self.model.ID) {
        [dt setObject:self.model.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,self.isEdit ? InsClassEditStuUrl : InsClassSubmitUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            if (self.successBlock) {
                self.successBlock();
            }
            [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
        }
        [self presentLoadingTips:response[@"msg"]];
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
