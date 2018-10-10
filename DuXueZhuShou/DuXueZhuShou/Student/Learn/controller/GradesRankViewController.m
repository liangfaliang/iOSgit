//
//  GradesRankViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "GradesRankViewController.h"
#import "GradesRankTableViewCell.h"
#import "ExamExplainViewController.h"
#import "YBPopupMenu.h"
@interface GradesRankViewController ()<UITableViewDataSource, UITableViewDelegate,YBPopupMenuDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)GradesRankTableViewCell *footcell;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong) RankModel *Mymodel;
@property (nonatomic, strong) NSString *explain;
@property(nonatomic, strong)ImTopBtn *rightBtn;
@end

@implementation GradesRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"成绩单";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footcell];
    [self createBaritem];
    [self UpData];
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getData];
}
-(void)createBaritem{
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    rightBar.tintColor = JHMaincolor;
    self.navigationItem.rightBarButtonItem = rightBar;
    
}
-(UIButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [[ImTopBtn alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        _rightBtn.space = 10;
        _rightBtn.edgeInsetsStyle =  MKButtonEdgeInsetsStyleRight;
        [_rightBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        _rightBtn.section = 3;
        [_rightBtn setTitle:@"班级排名" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:JHMaincolor forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = SYS_FONTBold(15);
        [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
#pragma mark  公开问答
-(void)rightClick{
    [YBPopupMenu showAtPoint:CGPointMake(screenW - 30, SAFE_NAV_HEIGHT) titles:@[@"班级排名", @"校区排名",@"全校排名"] icons:nil menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        //        popupMenu.dismissOnSelected = NO;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 5;
        popupMenu.textColor = JHMaincolor;
        
        //        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = -1;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"GradesRankTableViewCell" bundle:nil] forCellReuseIdentifier:@"GradesRankTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
    }
    return _tableView;
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    [self.rightBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
    self.rightBtn.section = 3- index;
    [self UpData];
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArray.count;
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GradesRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GradesRankTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.explain.length) {
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:self.explain];
        text.yy_font = SYS_FONT(15);
        text.yy_lineSpacing = 5;
        CGFloat hh = [text selfadaption:50].height;
        return hh > 45 ? 95 : hh + 50;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.explain.length) {
        return nil;
    }
    UIView *header =[[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    UIView *grayview =[[UIView alloc]init];
    grayview.backgroundColor = JHBorderColor;
    //添加点击手势
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
    [grayview addGestureRecognizer:click];
    [header addSubview:grayview];
    UILabel *lb = [UILabel initialization:CGRectZero font:[UIFont systemFontOfSize:15] textcolor:JHdeepColor numberOfLines:2 textAlignment:0];
    lb.text = self.explain;
    [lb NSParagraphStyleAttributeName:5];
    [grayview addSubview:lb];
    [grayview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(15);
        make.right.bottom.mas_offset(-15);
    }];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(10);
        make.right.bottom.mas_offset(-10);
    }];
    return header;
}
- (void)clickAction{
    ExamExplainViewController *vc = [[ExamExplainViewController alloc]init];
    vc.explain = self.explain;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取列表
- (void)getData{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:lStringFormart(@"%ld",(long)self.rightBtn.section) forKey:@"ranking_type"];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,GradeStuDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if ([str isEqualToString:@"1"]) {
            [RankModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"campusName" : @"campus",@"className" : @"class",@"rankName" : @"number",@"rank" : @"ranking"};
            }];
            self.explain = response[@"data"][@"explain"];
            self.Mymodel = [RankModel mj_objectWithKeyValues:response[@"data"][@"ranking"][@"self"]];
            self.Mymodel.isMy = YES;
            self.footcell.model = self.Mymodel;
            [self.dataArray removeAllObjects];

            for (NSDictionary *temDt in response[@"data"][@"ranking"][@"list"]) {
                RankModel *mo = [RankModel mj_objectWithKeyValues:temDt];
                [self.dataArray addObject:mo];
            }
            [RankModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
        }else{
            [AlertView showMsg:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
