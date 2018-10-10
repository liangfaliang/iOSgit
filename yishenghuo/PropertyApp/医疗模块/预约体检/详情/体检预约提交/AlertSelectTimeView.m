//
//  AlertSelectTimeView.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "AlertSelectTimeView.h"
#import "ShopOtherTableViewCell.h"
@implementation AlertSelectTimeView
-(baseTableview *)alertTableView{
    if (_alertTableView == nil) {
        _alertTableView = [[baseTableview alloc]initWithFrame:CGRectMake(0, self.height - (200 + self.phy_timeArr.count * 50), SCREEN.size.width, (200 + self.phy_timeArr.count * 50)) style:UITableViewStyleGrouped];
        _alertTableView.delegate = self;
        _alertTableView.dataSource = self;
        _alertTableView.separatorColor = JHColor(222, 222, 222);
        [_alertTableView registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"alertcell"];
        _alertTableView.backgroundColor = [UIColor whiteColor];
        UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 40)];
        headerview.backgroundColor = [UIColor whiteColor];
        IndexBtn *btn = [[IndexBtn alloc]init];
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(alertTableViewAction) forControlEvents:UIControlEventTouchUpInside];
        [headerview addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(60);
            make.right.offset(-10);
            make.top.offset(0);
            make.bottom.offset(0);
            
        }];
        _alertTableView.tableHeaderView = headerview;
        [self addSubview:_alertTableView];
    }
    return _alertTableView;
}
-(UIView *)backview{
    if (_backview == nil) {
        _backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, self.height - (200 + self.phy_timeArr.count * 50))];
        //        backview.backgroundColor = [UIColor redColor];
        _backview.backgroundColor = JHColoralpha(0, 0, 0, 0.5);
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(alertTableViewAction)];
        //讲手势添加到指定的视图上
        [_backview addGestureRecognizer:tap];
        [self addSubview:_backview];
    }
    return _backview;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}
-(void)initialization{
    self.backgroundColor = [UIColor clearColor];
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, self.height - (200 + self.phy_timeArr.count * 50))];
    //        backview.backgroundColor = [UIColor redColor];
    backview.backgroundColor = JHColoralpha(0, 0, 0, 0.5);
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(alertTableViewAction)];
    //讲手势添加到指定的视图上
    [backview addGestureRecognizer:tap];
    [self addSubview:backview];
    [self addSubview:self.alertTableView];
}
-(void)showAlertview:(NSArray *)phy_timeArr{
    self.phy_timeArr = phy_timeArr;
    self.alertTableView.frame = CGRectMake(0, self.height - (200 + self.phy_timeArr.count * 50), SCREEN.size.width, (200 + self.phy_timeArr.count * 50));
    self.backview.frame = CGRectMake(0, 0, SCREEN.size.width, self.height - (200 + self.phy_timeArr.count * 50));
    [self addSubview:self.backview];
    [self addSubview:self.alertTableView];
    [self.alertTableView reloadData];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)alertTableViewAction{
    [self removeFromSuperview];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.phy_timeArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = JHColor(236, 239, 235);
    UILabel *label = [[UILabel alloc]init];
    label.textColor = JHdeepColor;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"请选择预约时间";
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(header.mas_centerY);
        
    }];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alertcell"];
    cell.rigthtIm.hidden = YES;
    cell.contentLbLeft.constant = 0;
    cell.contentRight.constant= 10;
    cell.nameLabel.text = self.phy_timeArr[indexPath.row];
    cell.nameHeight.constant = screenW - 20;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(AlertSelectTimeViewDidSelectCell:phy_timeArr:Indexpath:)]) {
        [_delegate AlertSelectTimeViewDidSelectCell:self phy_timeArr:self.phy_timeArr Indexpath:indexPath];
    }
    [self alertTableViewAction];
}
@end
