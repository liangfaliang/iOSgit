//
//  InsPunchViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "InsPunchViewController.h"
#import "DescriptionTableViewCell.h"
#import "InsPunchViewSubmitController.h"
#import "OperateStuDatailModel.h"
@interface InsPunchViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *footview;
@property(nonatomic, strong)OperateStuDatailModel *model;

@end

@implementation InsPunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"打卡";
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(UIView *)footview{
    if (_footview == nil) {
        _footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 200)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 60, screenW -  30,  50)];
        btn.backgroundColor = JHMaincolor;
        [btn setTitle:@"发表评论" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
        [_footview addSubview:btn];
    }
    return _footview;
}
-(void)UpData{
    [super UpData];
    [self getData];
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DescriptionTableViewCell"];
        
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf getData];
        }];
        
    }
    return _tableView;
}
-(void)submitClick{
    InsPunchViewSubmitController *vc = [[InsPunchViewSubmitController alloc]init];
    vc.OperateID = self.OperateID;
    WEAKSELF;
    vc.successBlock = ^{
        if (weakSelf.successBlock) {
            weakSelf.successBlock();
        }
        [weakSelf UpData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model ? (self.model.comment.length ? 2 : 1) : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DescriptionTableViewCell class]) forIndexPath:indexPath];
    cell.nameLb.text = nil;
    if (indexPath.section == 0) {
        NSString *type = [NSString stringWithFormat:@"%@",(self.model.type.integerValue == 1 ? @"未打卡" : (self.model.type.integerValue == 2) ? @"已完成" :@"未完成")];
        NSString *str = [NSString stringWithFormat:@"作业状态：%@",type];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str] ;
        text.yy_font = SYS_FONTBold(20);
        text.yy_color = JHdeepColor;
        NSRange ran = [str rangeOfString:type];
        [text yy_setColor:JHAssistRedColor range:ran];
        cell.nameLb.attributedText = text;
    }else{
        cell.nameLb.attributedText = nil;
    }
    cell.contentLb.text = indexPath.section == 0 ? self.model.content : self.model.comment;
    [cell setImageArr:indexPath.section == 0 ? self.model.images : nil];
    [cell.contentLb NSParagraphStyleAttributeName:5];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 40;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = JHbgColor;
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 40) font:[UIFont systemFontOfSize:14] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
        lb.text =  @"老师评价";
        [header addSubview:lb];
        return header;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark - 获取数据
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.OperateID) {
        [dt setObject:self.OperateID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationInsStuDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            self.model = [OperateStuDatailModel mj_objectWithKeyValues:response[@"data"]];
            if (self.model.status.integerValue != 3) {
                self.tableView.tableFooterView = self.footview;
            }else{
                self.tableView.tableFooterView = nil;
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
@end
