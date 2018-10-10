//
//  AnswerDetailViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AnswerDetailViewController.h"
#import "DescriptionTableViewCell.h"
#import "PlayVoiceTableViewCell.h"
#import "AnswerListTableViewCell.h"
#import "AnswerDetailModel.h"
#import "AskQuestionViewController.h"
#import "RecordManage.h"
@interface AnswerDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)AnswerDetailModel *model;
@end

@implementation AnswerDetailViewController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[RecordManage sharedRecordManage] stopPlay];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"一对一答疑";
    [self.view addSubview:self.tableView];
    [self UpData];
    
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getData];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DescriptionTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PlayVoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"PlayVoiceTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AnswerListTableViewCell" bundle:nil] forCellReuseIdentifier:@"AnswerListTableViewCell"];
        
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];

    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model ? 1+self.model.answers.count : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    ReplyModel *rmo = self.model.answers[section-1];
    return rmo ? rmo.children.count + 1 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DescriptionTableViewCell class]) forIndexPath:indexPath];
            cell.Amodel = self.model;
            return cell;
        }
        PlayVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PlayVoiceTableViewCell class]) forIndexPath:indexPath];
        if (self.model.url.length) {
            cell.timeLb.text = [NSString stringWithFormat:@"%@\"",[self.model.url getSecondFormUrl]];
            cell.playBtnBlock = ^(BOOL isDown) {
                if (!isDown) {
                    [[RecordManage sharedRecordManage] p_musicPlayerWithURL:[NSURL URLWithString:self.model.url]];
                }
            };
        }else{
            cell.timeLb.text = nil;
            cell.playBtnHeight.constant = 0;
            cell.playBtn.hidden = YES;
            cell.playIm.hidden = YES;
            cell.timeLb.hidden = YES;
        }
        NSString *temstr = @"";
        for (NSDictionary *temdt in self.model.teachers) {
            temstr = [NSString stringWithFormat:@"%@@%@",temstr,temdt[@"name"]];
        }
        cell.nameLb.text = temstr;
        if ([UserUtils getUserRole] == UserStyleTeacher) {
            cell.replyBtn.hidden = NO;
            WEAKSELF;
            cell.replyBlock = ^{
                AskQuestionViewController *vc = [[AskQuestionViewController alloc]init];
                vc.successBlock = ^{
                    [weakSelf UpData];
                };
                vc.ID = weakSelf.ID;
                vc.answer_type = @"1";
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        return cell;
    }
    AnswerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerListTableViewCell class]) forIndexPath:indexPath];
    ReplyModel *rmo = self.model.answers[indexPath.section -1];
    if (indexPath.row == 0) {
        cell.rmodel = rmo;
    }else{
        cell.rmodel = rmo.children[indexPath.row - 1];
    }

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = JHbgColor;
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 40) font:[UIFont systemFontOfSize:14] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
        lb.text =  @"回答";
        [header addSubview:lb];
        return header;
    }
    return nil;
}


#pragma mark - 获取数据
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AnswerMyDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            self.model = [AnswerDetailModel mj_objectWithKeyValues:response[@"data"]];
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
//- (void)getDataList:(NSInteger )pageNum{
//    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNum];
//    NSDictionary *pagination = @{@"count":@"8",@"page":page};
//    [dt setObject:pagination forKey:@"pagination"];
//    if (pageNum == 1) {
//        [self.dataArray removeAllObjects];
//        [_tableView reloadData];
//    }
//    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,@"") params:dt viewcontrllerEmpty:self success:^(id response) {
//        LFLog(@"获取列表:%@",response);
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        NSInteger code = [response[@"code"] integerValue];
//        if (code == 1) {
//            if (pageNum == 1) {
//                [self.dataArray removeAllObjects];
//            }
//            for (NSDictionary *temDt in response[@"data"]) {
//            }
//
//        }else{
//
//        }
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//    }];
//
//}
@end
