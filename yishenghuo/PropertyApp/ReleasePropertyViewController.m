//
//  ReleasePropertyViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/5/13.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "ReleasePropertyViewController.h"
#import "ReleaseRentingViewController.h"
@interface ReleasePropertyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray *pomaArray;
@end

@implementation ReleasePropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"租售信息发布";
    NSInteger count = [[UserDefault objectForKey:@"PropertyCount"] integerValue];
    NSMutableString *roomstr = [NSMutableString string];
    for (int i = 0; i < count; i ++) {
        [roomstr appendFormat:@"%@",[UserDefault objectForKey:[NSString stringWithFormat:@"po_name_%d",i]]];
        [self.pomaArray addObject:roomstr];
    }
    [self createUI];
}
-(NSMutableArray *)pomaArray{
    
    if (_pomaArray == nil) {
        _pomaArray  = [[NSMutableArray alloc]init];
    }
    
    
    return _pomaArray;
}
-(void)createUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    //    UIView *foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 200)];
    //
    //    UIButton *submitBtn = [[UIButton alloc]init];
    //    [submitBtn setImage:[UIImage imageNamed:@"querenbingtijiao_xinyongdai"] forState:UIControlStateNormal];
    //    [submitBtn addTarget:self action:@selector(employsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [foootview addSubview:submitBtn];
    //    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(foootview.mas_centerY);
    //        make.centerX.equalTo(foootview.mas_centerX);
    //    }];
    //    self.tableView.tableFooterView = foootview;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.pomaArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        NSString *CellIdentifier = @"iscell";
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"creditcell%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc]init];
        label.textColor = JHColor(53, 53, 53);
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 0;
        label.text = self.pomaArray[indexPath.row];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(-40);
            
        }];
        UIImageView *rightimage = [[UIImageView alloc]init];
        rightimage.image = [UIImage imageNamed:@"gerenzhongxinjiantou"];
        [cell.contentView addSubview:rightimage];
        [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.offset(-10);
            make.centerY.equalTo(cell.mas_centerY);
            
        }];
    }
    
    return cell;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIImageView *imagevw = [[UIImageView alloc]init];
    imagevw.userInteractionEnabled = YES;
    
    imagevw.image = [UIImage imageNamed:@"biaotikuang_xinyongdai"];
    UILabel *lb = [[UILabel alloc]init];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = JHsimpleColor;
    lb.text = @"选择房产";
    
    [imagevw addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.offset(-10);
    }];
    
    return imagevw;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *text = self.pomaArray[indexPath.row];
    CGFloat HH = [text selfadap:15 weith:50].height + 10;
    return HH > 50 ? HH :50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReleaseRentingViewController * relese = [[ReleaseRentingViewController alloc]init];
    relese.poname = self.pomaArray[indexPath.row];
    [self.navigationController pushViewController:relese animated:YES];
}

@end
