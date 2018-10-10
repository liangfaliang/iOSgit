//
//  VehicleTypeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "VehicleTypeViewController.h"

@interface VehicleTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;

@property (strong,nonatomic)NSArray *descArray;
@end

@implementation VehicleTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"车辆类型";
    [self createUI];
}

-(void)createUI{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.typeArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
    
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
        label.text = self.typeArray[indexPath.row][@"type_name"];
        CGSize lbsize = [label.text selfadaption:15];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset(lbsize.width + 5);
            
        }];

        UILabel *contentLb = [[UILabel alloc]init];
        contentLb.textColor = JHsimpleColor;
        contentLb.font = [UIFont systemFontOfSize:12];
        contentLb.numberOfLines = 0;
        contentLb.adjustsFontSizeToFitWidth = YES;
        contentLb.text = self.typeArray[indexPath.row][@"type_desc"];
        [cell.contentView addSubview:contentLb];
        [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(-10);
            make.left.equalTo(label.mas_right).offset(10);
            
        }];
        

        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_block) {
        _block(self.typeArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setBlock:(backBlock)block{
    _block = block;
}

@end

