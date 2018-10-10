//
//  LookStudentsViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LookStudentsViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "YBPopupMenu.h"
#import "AddStudentsViewController.h"
@interface LookStudentsViewController ()<UITableViewDataSource, UITableViewDelegate,YBPopupMenuDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation LookStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)UpData{
    [self getData];
}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}
-(void)rightClick:(UIBarButtonItem *)sender{
    [YBPopupMenu showAtPoint:CGPointMake(screenW - 30, SAFE_NAV_HEIGHT) titles:@[@"编辑", @"删除"] icons:nil menuWidth:80 otherSettings:^(YBPopupMenu *popupMenu) {
        //        popupMenu.dismissOnSelected = NO;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 5;
        popupMenu.textColor = JHMaincolor;
        
        //        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }];
    
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    if (index == 1) {//解散
        [self alertController:@"确定删除该学生" prompt:nil sure:@"确定" cancel:@"取消" success:^{
            [self DisbandData];
        } failure:^{
            
        }];
    }else{//编辑
        AddStudentsViewController *vc = [[AddStudentsViewController alloc]init];
        vc.model = [AddStuModel mj_objectWithKeyValues:self.stuDt];
        vc.model.class_id = self.class_id;
        vc.isEdit = YES;
        WEAKSELF;
        vc.successBlock = ^{
            [weakSelf UpData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{@"name":@"学号",@"text":@"",@"key":@"number"},
                           @{@"name":@"登录账号",@"text":@"",@"key":@"username"},
                           @{@"name":@"科目",@"text":@"",@"key":@"subject"}];
        for (NSDictionary *dt in array) {
            TextFiledModel *cmo = [TextFiledModel mj_objectWithKeyValues:dt];
            cmo.label = @"1";
            [_dataArray addObject:cmo];
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
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];

    }
    return _tableView;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.nameBtn.titleLabel.numberOfLines = 1;
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled = NO;
    cell.contentLb.userInteractionEnabled = NO;
    return cell;
}


#pragma mark - 解散
- (void)DisbandData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.stuDt && self.stuDt[@"id"]) {
        [dt setObject:self.stuDt[@"id"]forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,InsClassDeleteUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1 ) {
            if (self.successBlock) {
                self.successBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [AlertView showMsg:response[@"msg"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.stuDt && self.stuDt[@"id"]) {
        [dt setObject:self.stuDt[@"id"]forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,InsClassStuInfoUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1 ) {
            self.stuDt = response[@"data"];
            self.navigationBarTitle = self.stuDt ? self.stuDt[@"name"] : @"";
            for (TextFiledModel *cmo in self.dataArray) {
                if (self.stuDt) {
                    cmo.text = lStringFor(self.stuDt[cmo.key]);
                }
            }
            [self createBaritem];
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
