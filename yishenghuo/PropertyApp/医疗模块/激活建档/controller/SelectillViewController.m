//
//  SelectillViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/27.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "SelectillViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "TextFiledModel.h"
@interface SelectillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation SelectillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"慢性病患病情况";
    [self.view addSubview:self.tableView];
    UIButton * footer = [[UIButton alloc]initWithFrame:CGRectMake(0, screenH - 50, screenW, 50)];
    footer.backgroundColor = JHMedicalColor;
    [footer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footer addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [footer setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:footer];
    [self UpData];
}
-(void)UpData{
    [self getData];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITextView *)textview{
    if (_textview == nil) {
        _textview = [[UITextView alloc]initWithFrame:CGRectMake(15, 0, screenW - 30, 120)];
        _textview.backgroundColor = [UIColor clearColor];
        _textview.placeholder = @"其他疾病描述";
        _textview.text = self.illtext;
    }
    return _textview;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = JHbgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW , 120)];
        footer.backgroundColor = JHbgColor;
        [footer addSubview:self.textview];
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}
#pragma mark - 下一步
- (void)nextClick{
    [self.selectNameArr removeAllObjects];
    NSMutableString *mstr = [NSMutableString string];
    for (TextFiledModel *cmo in self.dataArray) {
        if (cmo.isSelect) {
            [self.selectNameArr addObject:cmo.name];
            if (mstr.length) {
                [mstr appendString:@","];
            }
            [mstr appendString:cmo.name];
        }
    }
    self.illtext = self.textview.text;
    if (self.textview.text.length) {
        [mstr appendFormat:@"%@其他:%@",mstr.length ? @"," : @"",self.textview.text];
    }
    if (self.selectBlock) {
        self.selectBlock(mstr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    if (cmo.isSelect) {
        cell.nameLb.textColor = JHMedicalColor;
        [cell setRightim:@"1" rView:[UIImage imageNamed:@"xuanze"]];
    }else{
        [cell setRightim:nil rView:nil];
        cell.nameLb.textColor = JHdeepColor;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = JHbgColor;
    return footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    cmo.isSelect = cmo.isSelect ? 0 :1;
    [self.tableView reloadData];
}
#pragma mark - 数据
- (void)getData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ActivateFileSelectUrl) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@" 数据:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (response[@"data"][@"chronic_disease"] && [response[@"data"][@"chronic_disease"][@"list"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *temdt in response[@"data"][@"chronic_disease"][@"list"]) {
                    TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:temdt];
                    for (NSString *name in self.selectNameArr) {
                        if ([model.name isEqualToString:name]) {
                            model.isSelect = 1;
                        }
                    }
                    [self.dataArray addObject:model];
                }
                
            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
