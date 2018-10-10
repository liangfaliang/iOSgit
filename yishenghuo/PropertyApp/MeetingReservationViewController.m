//
//  MeetingReservationViewController.m
//  shop
//
//  Created by 梁法亮 on 16/10/10.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "MeetingReservationViewController.h"
#import "MeetingReservatSubmitViewController.h"
@interface MeetingReservationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UIView *view1;
//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;

@property (strong,nonatomic)NSMutableArray *repairRecordArr;
@property (strong, nonatomic) NSArray *segementArray;

//segment=1的时候cell里面的内容
@property (strong,nonatomic)NSString *str;

//存储bool的值
@property(nonatomic,strong) NSMutableArray *boolArray;
@end

@implementation MeetingReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"会议室预定";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatableveiw];
    [self UploadDataEquipment];

}
- (NSMutableArray *)boolArray
{
    if (_boolArray == nil) {
        _boolArray = [[NSMutableArray alloc]init];
    }
    return _boolArray;
}

- (NSMutableArray *)repairRecordArr
{
    if (_repairRecordArr == nil) {
        _repairRecordArr = [[NSMutableArray alloc]init];
    }
    return _repairRecordArr;
}

- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}

-(void)creatableveiw{
    
    self.tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStyleGrouped];
    self.tableveiw.delegate = self;
    self.tableveiw.dataSource = self;
    [self.tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"employcell"];
    [self.view addSubview:self.tableveiw];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.0000001;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    
    return self.repairRecordArr.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    BOOL ret = [self.boolArray[section] boolValue];
    if (ret) {
        
        return 1;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employcell"];
        [cell.contentView removeAllSubviews];
        CGFloat H = 0;
    
            self.str = [self comStr:(int)indexPath.section dict:self.repairRecordArr[indexPath.section]] ;
            CGSize labesize = [self.str boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            cell.backgroundColor = [UIColor lightGrayColor];
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, H, SCREEN.size.width-20,labesize.height +16)];
            contentLabel.text = self.str;
            contentLabel.font = [UIFont systemFontOfSize:12];
            contentLabel.numberOfLines = 0;
            [cell.contentView addSubview:contentLabel];
            
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
 
}

- (NSString *)comStr:(int)number dict:(NSDictionary *)dt
{
    
    
    self.str  = [NSString stringWithFormat:@"面积：%@\n座位数：：%@\n投影仪：%@\n电话会议：%@\n租金：%@\n服务费：%@\n合计：%@\n备注：%@",dt[@"size"],dt[@"seat"],dt[@"ep_isty"],dt[@"ep_istv"],dt[@"fee"],dt[@"fee_sv"],dt[@"fee_sum"],dt[@"detail"]];
    
    
    return _str;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    CGFloat H = 0;

        self.str = [self comStr:(int)indexPath.section dict:self.repairRecordArr[indexPath.section]] ;
        CGSize labesize = [self.str boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        
        H += labesize.height + 18;

    if (H <44) {
        return 44;
    }
    return H;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    

        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 40)];
        header.backgroundColor = [UIColor whiteColor];
        //cell上左侧的
        if (self.repairRecordArr.count) {
            UIButton *btn1= [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(10, 0, SCREEN.size.width-20, 50);
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:12];
            btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn1.tag = section + 1200;
            //        [btn1 setBackgroundColor:[UIColor whiteColor]];
            [header addSubview:btn1];

#pragma 区头
            
            
            NSString *str1 = [NSString stringWithFormat:@"%@",[self.repairRecordArr[section] objectForKey:@"po_name"]];
            
            [btn1 setTitle:str1 forState:UIControlStateNormal];

                UIButton *btn2= [UIButton buttonWithType:UIButtonTypeCustom];
                btn2.frame = CGRectMake(SCREEN.size.width-60, 30, 60, 20);
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn2.titleLabel.font = [UIFont systemFontOfSize:12];
                btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
                btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                btn2.tag = section + 900;
                
                [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [btn2 setBackgroundColor:[UIColor whiteColor]];
                [header addSubview:btn2];
                [btn2 setTitle:@"预定" forState:UIControlStateNormal];
                [btn2 addTarget:self action:@selector(sectionOpenAndCloseClick111:) forControlEvents:UIControlEventTouchUpInside];
       
            
            [btn1 addTarget:self action:@selector(sectionOpenAndCloseClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
            UILabel *lb = [[UILabel alloc]initWithFrame:header.frame];
            lb.text = @"暂无数据~~";
            lb.font = [UIFont systemFontOfSize:15];
            lb.textColor = JHColor(102, 102, 102);
            lb.textAlignment = NSTextAlignmentCenter;
            [header addSubview:lb];
            
        }
        
        return header;

}

- (void)sectionOpenAndCloseClick:(UIButton *)sender
{
    BOOL ret = [self.boolArray[sender.tag - 1200] boolValue];
    if (ret) {
        [self.boolArray replaceObjectAtIndex:sender.tag-1200 withObject:@NO];
    }else{
        [self.boolArray replaceObjectAtIndex:sender.tag - 1200 withObject:@YES];
        
    }
    
    [ self.tableveiw reloadSections:[[NSIndexSet alloc] initWithIndex:sender.tag - 1200]withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)sectionOpenAndCloseClick111:(UIButton *)sender
{
    
    MeetingReservatSubmitViewController *board = [[MeetingReservatSubmitViewController alloc]init];
    [board.dataArray addObject:self.repairRecordArr[sender.tag - 900]];
    [self.navigationController pushViewController:board animated:YES];
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPathP{
    

    
}
#pragma mark - 保养工单

-(void)UploadDataEquipment{
    
    NSString *usid = [UserDefault objectForKey:@"workerusid"];
    NSString *leid = [UserDefault objectForKey:@"leid"];
    NSString *mobile = [UserDefault objectForKey:@"mobile"];
    NSString *urlid = NSStringWithFormat(ZJERPIDBaseUrl,@"15");
    NSString *urlstr = [NSString stringWithFormat:@"%@&leid=%@&usid=%@&mobile=%@",urlid,leid,usid,mobile];
    LFLog(@"urlstr:%@",urlstr);
    [LFLHttpTool get:urlstr params:nil success:^(id response) {
        [self.tableveiw.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        LFLog(@"会议室预定：%@",response);
        if ([str isEqualToString:@"0"]) {
            [self.repairRecordArr removeAllObjects];
            if (![response[@"note"] isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dt in response[@"note"]) {
                    [self.repairRecordArr addObject:dt];
                    [self.boolArray addObject:@NO];
                }
                
                [self.tableveiw reloadData];
            }
            
            
        }else{
            
            
            
            
        }

    } failure:^(NSError *error) {
        [self.tableveiw.mj_header endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableveiw.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDataEquipment];
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
