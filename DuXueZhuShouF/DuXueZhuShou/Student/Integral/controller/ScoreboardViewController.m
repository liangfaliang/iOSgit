//
//  ScoreboardViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ScoreboardViewController.h"
#import "GradesRankTableViewCell.h"
#import "ExamExplainViewController.h"
#import "SPPageMenu.h"
#import "LbRightImLeftView.h"
#import "OptionModel.h"
@interface ScoreboardViewController ()<SPPageMenuDelegate,UITableViewDataSource, UITableViewDelegate,TFPickerDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *header;
@property(nonatomic, strong)LbRightImLeftView *selctview;
@property(nonatomic, strong)GradesRankTableViewCell *footcell;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *optionArray;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) RankModel *Mymodel;
@end

@implementation ScoreboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"积分排行榜";
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.header;
    if ([UserUtils getUserRole] == UserStyleStudent) {
        [self.view addSubview:self.footcell];
        self.footcell.model = self.Mymodel;
    }
    
    [self UpData];
}
-(void)UpData{
    [super UpData];
    [self getDataOption:nil];
    self.page = 1;
    [self getDataList:self.page isMy:NO];
    [self getDataList:0 isMy:YES];
}
-(UIView *)header{
    if (_header == nil) {
        _header = [[UIView alloc]initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, 100)];
        _header.backgroundColor = [UIColor whiteColor];
        [_header addSubview:self.selctview];
        [_header addSubview:self.pageMenu];
    }
    return _header;
}
-(LbRightImLeftView *)selctview{
    if (_selctview == nil) {
        _selctview = [[LbRightImLeftView alloc]initWithFrame:CGRectMake(15, 15, screenW - 30, 35)];
        _selctview.backgroundColor = JHbgColor;
        [_selctview ddy_AddTapTarget:self action:@selector(selectviewTap)];
    }
    return _selctview;
}
-(void)selectviewTap{
    if (self.optionArray.count) {
        [self showPickerview];
    }else{
        [self presentLoadingTips];
        [self getDataOption:^(NSArray *arr) {
            [self showPickerview];
        }];
    }
    

}
-(void)showPickerview{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.titlestr = @"";
    picker.inter =2;
    picker.delegate = self;
    picker.arrayType = HeightArray;
    for (OptionModel *mo in self.optionArray) {
        [picker.typearr addObject:mo.name];
    }
    [self.view addSubview:picker];
}
-(NSMutableArray *)optionArray{
    if (!_optionArray) {
        _optionArray = [NSMutableArray array];
    }
    return _optionArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        CGFloat width = 250;
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake((screenW - width)/2, 60, width, 40) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.itemPadding = 30;
        _pageMenu.tracker.backgroundColor = JHMaincolor;
        _pageMenu.SPPageMenuLineColor = [UIColor clearColor];
        _pageMenu.backgroundColor = [UIColor clearColor];
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        // 设置代理
        _pageMenu.selectedItemTitleColor = JHMaincolor;
        _pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        _pageMenu.delegate = self;
        [_pageMenu setItems:@[@"本周",@"本月",@"总"] selectedItemIndex:0];
        
    }
    return _pageMenu;
}

-(GradesRankTableViewCell *)footcell{
    if (_footcell == nil) {
        _footcell = [[NSBundle mainBundle]loadNibNamed:@"GradesRankTableViewCell" owner:nil options:nil].firstObject;
        _footcell.backgroundColor = [UIColor whiteColor];
        _footcell.frame = CGRectMake(0, screenH - 50, screenW, 50);
    }
    return _footcell;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - (([UserUtils getUserRole] == UserStyleStudent) ? 50 : 0)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = -1;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"GradesRankTableViewCell" bundle:nil] forCellReuseIdentifier:@"GradesRankTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            weakSelf.more = 1;
            [weakSelf getDataList:0 isMy:YES];
            [weakSelf getDataList:1 isMy:NO];
        }];

    }
    return _tableView;
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    _selctview.titleLb.text = str;
    for (OptionModel *mo in self.optionArray) {
        mo.isSelect =0;
        if ([mo.name isEqualToString:str]) {
            mo.isSelect = 1;
        }
    }
    self.page = 1;
    [self getDataList:0 isMy:YES];
    [self getDataList:1 isMy:NO];
    LFLog(@"%@",str);
}
#pragma mark -------- SPPageMenuDelegate
-(void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index{
    self.page = 1;
    [self getDataList:0 isMy:YES];
    [self getDataList:1 isMy:NO];
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArray.count;
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GradesRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GradesRankTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
//    [cell setlabels:@[@"上官上官",@"A校区",@"1881班",@"15701174905",@"100"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (void)clickAction{
    ExamExplainViewController *vc = [[ExamExplainViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取选项
- (void)getDataOption:(void (^)(NSArray *arr))result{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,IntegralOptionUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取选项:%@",response);
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
            [self.optionArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"]) {
                OptionModel *model  = [OptionModel mj_objectWithKeyValues:temDt];
                if (!self.optionArray.count && !self.selctview.titleLb.text.length) {
                    _selctview.titleLb.text = model.name;
                    model.isSelect = 1;
                    [self.optionArray addObject:model];
                    self.page = 1;
                    [self getDataList:1 isMy:NO];
                    [self getDataList:0 isMy:YES];
                }else{
                   [self.optionArray addObject:model];
                }
                
            }
            if (result) {
                result(self.optionArray);
            }
        }else{
            [AlertView showMsg:response[@"msg"]];
        }

    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum isMy:(BOOL)isMy{
    if (isMy && [UserUtils getUserRole] != UserStyleStudent) {
        return;
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    for (OptionModel *mo in self.optionArray) {
        if (mo.isSelect) {
            [dt setObject:mo.class_id forKey:@"class_id"];
            [dt setObject:mo.campus_id forKey:@"campus_id"];
            [dt setObject:mo.school_id forKey:@"school_id"];
        }
    }
    if (!dt.count) {
        self.isLoadEnd = @1;
        return;
    }
    [dt setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.pageMenu.selectedItemIndex + 1] forKey:@"type"];
//    if (pageNum == 1) {
//        [self.dataArray removeAllObjects];
//        [_tableView reloadData];
//    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,isMy ? IntegralMyRankUrl : IntegralRankUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if ([str isEqualToString:@"1"]) {
            if (isMy) {
                self.Mymodel = [RankModel mj_objectWithKeyValues:response[@"data"]];
                self.Mymodel.isMy = YES;
                self.footcell.model = self.Mymodel;
                self.footcell.height_i = [self.footcell getHeight];
                self.footcell.y_i = screenH - self.footcell.height_i;
                self.tableView.height_i = screenH - self.footcell.height_i;
            }else{
                if (pageNum == 1) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *temDt in response[@"data"]) {
                    RankModel *mo = [RankModel mj_objectWithKeyValues:temDt];
                    [self.dataArray addObject:mo];
                }
            }
        }else{
            [AlertView showMsg:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
