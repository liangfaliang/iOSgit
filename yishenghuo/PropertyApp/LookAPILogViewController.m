//
//  LookAPILogViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/8/31.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "LookAPILogViewController.h"
#import "IndexBtn.h"
#import "LookApiLogTableViewCell.h"
@interface LookAPILogViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *tempArrpost;
@property(nonatomic,strong)NSArray *tempArrget;
@property(nonatomic,strong)NSArray *tempArr;
@end

@implementation LookAPILogViewController

-(instancetype)init{
    if (self = [super init]) {
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitle = @"接口日志";
    

    __weak typeof(self) weakSelf = self;
    self.navigationBarRightItem = @"全部清除";
    [self setRightBarBlock:^(UIBarButtonItem *sender) {
        [[AppFMDBManager sharedAppFMDBManager] deleteDataWithDataType:[NSString stringWithFormat:@"%@_POST",LookAPILogType]];
        [[AppFMDBManager sharedAppFMDBManager] deleteDataWithDataType:[NSString stringWithFormat:@"%@_GET",LookAPILogType]];
        [[AppFMDBManager sharedAppFMDBManager] deleteDataWithDataType:ApiReturnedMessagesType];
        weakSelf.tempArrpost = nil;
        weakSelf.tempArrget = nil;
        weakSelf.tempArr = nil;
        [weakSelf.tableview reloadData];
    }];
     [self.tableview registerNib:[UINib nibWithNibName:@"LookApiLogTableViewCell" bundle:nil] forCellReuseIdentifier:@"LookApiLogTableViewCell"];
    [self presentLoadingTips];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        AppFMDBManager *af =  [AppFMDBManager sharedAppFMDBManager];
        self.tempArrpost = [af cachedDataWithDataType:[NSString stringWithFormat:@"%@_POST",LookAPILogType]];
        self.tempArrget = [af cachedDataWithDataType:[NSString stringWithFormat:@"%@_GET",LookAPILogType]];
        self.tempArr = [af cachedDataWithDataType:ApiReturnedMessagesType];
        LFLog(@"tempArrpost:%@",self.tempArrpost);
        LFLog(@"tempArrget:%@",self.tempArrget);
        LFLog(@"tempArr:%@",self.tempArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
            [self dismissTips];
        });
     });

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.tempArrpost.count;
    }else if (section == 1){
        return self.tempArrget.count;
    }
    return self.tempArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LookApiLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LookApiLogTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numLb.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    cell.numLb.textColor = JHMaincolor;
    NSDictionary *dict = @{};
    if (indexPath.section == 0) {
        dict = self.tempArrpost[indexPath.row];
        NSDictionary *parameter = dict[@"parameter"];
        NSMutableString *mstr = [NSMutableString string];
        [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [mstr appendFormat:@"%@", [NSString stringWithFormat:@"&%@=%@",(NSString *)key,(NSString *)obj]];
        }];
        cell.contentLb.text = mstr;
    }else if (indexPath.section == 1){
        dict = self.tempArrget[indexPath.row];
        cell.contentLb.text = @"";
    }
    else if (indexPath.section == 2){
        dict = self.tempArr[indexPath.row];
        cell.contentLb.text = dict[@"returnInfo"];
    }
    cell.urlLb.text = dict[@"url"];
    cell.urlLbHeight.constant = [cell.urlLb.text selfadap:13 weith:30].height + 20;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat HH = 0;
    NSDictionary *dict = @{};
    if (indexPath.section == 0) {
        dict = self.tempArrpost[indexPath.row];
        NSDictionary *parameter = dict[@"parameter"];
        NSMutableString *mstr = [NSMutableString string];
        [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [mstr appendFormat:@"%@", [NSString stringWithFormat:@"&%@=%@",(NSString *)key,(NSString *)obj]];
        }];
        HH += [mstr selfadap:13 weith:30].height;
    }else if (indexPath.section == 1){
        dict = self.tempArrget[indexPath.row];
    }else if (indexPath.section == 2){
        dict = self.tempArr[indexPath.row];
        HH += [dict[@"returnInfo"] selfadap:13 weith:30].height ;
    }
    HH += [dict[@"url"] selfadap:13 weith:30].height + 40;
    return HH;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *heaBtn = [[UIButton alloc]init];
    [heaBtn  setTitleColor:JHdeepColor forState:UIControlStateNormal];
    NSString *text  = @"post";
    if (section == 1) {
        text  = @"get";
    }else if (section == 2 ){
        text  = @"returnInfo";
    }
    [heaBtn setTitle:text forState:UIControlStateNormal];
    IndexBtn *cleanBtn = [[IndexBtn alloc]init];
    cleanBtn.index = section;
    [cleanBtn setTitle:@"清除" forState:UIControlStateNormal];
    [cleanBtn  setTitleColor:JHMaincolor forState:UIControlStateNormal];
    [heaBtn addSubview:cleanBtn];
    [cleanBtn addTarget:self action:@selector(cleanBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(heaBtn.mas_centerY);
        make.right.offset(-10);
    }];
    return heaBtn;
}

-(void)cleanBtnclick:(IndexBtn *)btn{
    AppFMDBManager *af =  [AppFMDBManager sharedAppFMDBManager];
    switch (btn.index) {
        case 0:
            [af deleteDataWithDataType:[NSString stringWithFormat:@"%@_POST",LookAPILogType]];
            self.tempArrpost = [af cachedDataWithDataType:[NSString stringWithFormat:@"%@_POST",LookAPILogType]];
            break;
        case 1:
            [af deleteDataWithDataType:[NSString stringWithFormat:@"%@_GET",LookAPILogType]];
            self.tempArrget = [af cachedDataWithDataType:[NSString stringWithFormat:@"%@_GET",LookAPILogType]];
            break;
        case 2:
            [af deleteDataWithDataType:ApiReturnedMessagesType];
            self.tempArr = [af cachedDataWithDataType:ApiReturnedMessagesType];
            break;
            
        default:
            break;
    }
    [self.tableview reloadData];
}


@end
