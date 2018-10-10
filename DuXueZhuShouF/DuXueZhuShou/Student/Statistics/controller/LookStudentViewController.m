
//
//  LookStudentViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LookStudentViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "GradeAnalysisViewController.h"
@interface LookStudentViewController ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation LookStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"查看学员" ;
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)UpData{
    [super UpData];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"herader"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
    }
    return _tableView;
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TextSectionModel *smo = self.dataArray[section];
    return smo.isSelect ? smo.child.count :0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.NameTfSpace.constant = 50;
    cell.nameBtn.titleLabel.numberOfLines = 1;
    __block   TextSectionModel *smo = self.dataArray[indexPath.section];
    __block  TextFiledModel *cmo = smo.child[indexPath.row];
    if (!cmo.isSelect) {
        cmo.text = @"设为榜样";
        cmo.textcolor = @"3995FF";
    }else{
        cmo.textcolor = @"333333";
        cmo.text = @"取消榜样";
    }
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;
    WEAKSELF;
    cell.contentLbBlock = ^{
        [weakSelf SetRoleData:cmo];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return -1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TextFiledLableTableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"herader"];
    header.nameBtn.userInteractionEnabled = NO;
    header.nameBtn.titleLabel.numberOfLines = 1;
    header.backgroundColor = [UIColor whiteColor];
    header.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
    tap.cancelsTouchesInView = NO;
    [header addGestureRecognizer:tap];
    __block TextSectionModel *smo = self.dataArray[section];
    smo.tfmodel.leftim = smo.isSelect ? @"xlh" :@"enter" ;
    TextFiledModel *cmo = smo.tfmodel;
    header.model = cmo;
    header.NameTfSpace.constant = screenW - [cmo.name selfadapUifont:header.nameBtn.titleLabel.font weith:30].width - 40 - header.nameBtn.imageView.image.size.width - 40;
    
    return header;
}
-(void)headerClick:(UITapGestureRecognizer *)tap{
    TextFiledLableTableViewCell *header = (TextFiledLableTableViewCell *)tap.view;
    TextSectionModel *smo = self.dataArray[header.tag];
    smo.isSelect = smo.isSelect ? 0 : 1;
    [self.tableView reloadData];
    //    header.model = cmo;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    GradeAnalysisViewController *vc = [[GradeAnalysisViewController alloc]init];
    vc.student_id = cmo.idStr;
    vc.TitleName = lStringFormart(@"%@成绩分析",cmo.name);
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.dataArray.count) {
        return  [super buttonTitleForEmptyDataSet:scrollView forState:state];
    }
    return nil;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (!self.dataArray.count) {
        [super emptyDataSet:scrollView didTapButton:button];
    }
}
#pragma mark - 是否设为榜样
- (void)SetRoleData:(TextFiledModel *)cmo{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (cmo && cmo.idStr.length) {
        [dt setObject:cmo.idStr forKey:@"student_id"];
        [dt setObject:cmo.isSelect ? @"0" :@"100" forKey:@"honor"];
    }
    if (self.subject_id) [dt setObject:self.subject_id forKey:@"subject_id"];
    if (self.type_id) [dt setObject:self.type_id forKey:@"type_id"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,GradeInsSetRoleSetRoleUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"删除:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            cmo.isSelect = [dt[@"honor"] integerValue];
        }
        [self presentLoadingTips:response[@"msg"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 获取列表
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.subject_id) [dt setObject:self.subject_id forKey:@"subject_id"];
    if (self.type_id) [dt setObject:self.type_id forKey:@"type_id"];
    //NSStringWithFormat(SERVER_IP,IntegralTeaListUrl)
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,GradeInsLookStuUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] ) {
            [self.dataArray removeAllObjects];
            //            self.more = [response[@"data"][@"isEnd"] integerValue];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",TisSelect : @"honor"};
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",@"child" : @"student"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:temDt];
                model.tfmodel = [TextFiledModel mj_objectWithKeyValues:@{@"name":temDt[@"name"],@"idStr":temDt[@"id"],@"leftim":@"enter"}];
                model.tfmodel.isSelect = 1;
                for (TextFiledModel *cmo in model.child) {
                    cmo.label = @"1";
                    
                    if (!cmo.isSelect) model.tfmodel.isSelect = 0;
                }
                model.isSelect = 1;//默认展开
                [self.dataArray addObject:model];
            }
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
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
