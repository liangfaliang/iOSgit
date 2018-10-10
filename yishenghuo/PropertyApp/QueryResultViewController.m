//
//  QueryResultViewController.m
//  shop
//
//  Created by 梁法亮 on 16/6/27.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "QueryResultViewController.h"
#import "QueryResultTableViewCell.h"
#import "queryresultmodel.h"
#import "NSString+selfSize.h"
@interface QueryResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)queryresultmodel *model;


@property(nonatomic)NSMutableArray *modelArray;
@end

@implementation QueryResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"查询结果";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableview];
    [self refrichdata];
    
}

-(void)refrichdata{

    for (NSDictionary *dt in self.dataArray) {
        for (NSDictionary *dict in dt[@"lists"]) {
            self.model = [[queryresultmodel alloc]initWithDictionary:dict error:nil];
            [self.modelArray addObject:self.model];
        }
    }
    if (self.modelArray.count == 0) {
        [self presentLoadingTips:@"您暂无违章记录"];
    }
    [self.tableView reloadData];

}

-(NSMutableArray *)dataArray{
    
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

-(NSMutableArray *)modelArray{
    
    
    if (_modelArray == nil) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    
    return _modelArray;
}
-(void)createTableview{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QueryResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"QueryResultTableViewCell"];
    //    _tableView.separatorStyle = NO;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cuscell"];
    [self.view addSubview:self.tableView];
    
    UIView *baveiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 100)];
    baveiw.backgroundColor = [UIColor whiteColor];
    UIButton *submitButton = [[UIButton alloc]init];
    [submitButton setImage:[UIImage imageNamed:@"cheliangtu"] forState:UIControlStateNormal];
    [baveiw addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(submitButton.imageView.image.size.width);
        make.left.offset(15);
        make.centerY.equalTo(baveiw.mas_centerY);
        
        
    }];
    
    UIButton *numstrBtn = [[UIButton alloc]init];
    [numstrBtn setBackgroundImage:[UIImage imageNamed:@"chepaiditu"] forState:UIControlStateNormal];
    [numstrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numstrBtn setTitle:self.dataArray[0][@"hphm"] forState:UIControlStateNormal];
    [baveiw addSubview:numstrBtn];
    [numstrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset([self.dataArray[0][@"hphm"] selfadap:16 weith:30].width + 20);
        make.left.equalTo(submitButton.mas_right).offset(15);
        make.bottom.offset(-50);
        
        
    }];
    
    UILabel * desclb = [[UILabel alloc]init];
    desclb.font = [UIFont systemFontOfSize:15];
    desclb.numberOfLines = 0;
    desclb.textColor = JHdeepColor;
    desclb.text = self.numengine;
    [baveiw addSubview:desclb];
    [desclb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.right.offset(-15);
        make.left.equalTo(submitButton.mas_right).offset(15);
        make.top.offset(50);
        
    }];
    UIView *basebaveiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 110)];
    basebaveiw.backgroundColor = JHbgColor;
    [basebaveiw addSubview:baveiw];
    self.tableView.tableHeaderView = basebaveiw;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.modelArray.count) {
        return self.modelArray.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.modelArray.count) {
        QueryResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryResultTableViewCell"];
        
        cell.model = self.modelArray[indexPath.section];
        return  cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cuscell"];
    cell.textLabel.text = @"您暂无违章记录";
    cell.textLabel.textColor = JHmiddleColor;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return  cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.modelArray.count) {
        queryresultmodel *model = self.modelArray[indexPath.section];
        CGFloat HH = 70;
        HH += (([model.date selfadap:15 weith:30].height + 10) > 30) ? ([model.date selfadap:15 weith:30].height + 10):30;
        HH += (([model.act selfadap:15 weith:30].height + 10) > 30) ?([model.act selfadap:15 weith:30].height + 10):30;
        HH += (([model.area selfadap:18 weith:30].height + 10) > 40) ? ([model.area selfadap:18 weith:30].height + 10):40;
        
        return HH;
    }
    return 50;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *backview = [[UIView alloc]init];
        backview.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"weifaxinxitu"] forState:UIControlStateNormal];
        [button setTitle:@" 违法信息" forState:UIControlStateNormal];
        [button setTitleColor:JHdeepColor forState:UIControlStateNormal];
        [backview addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(15);
            make.centerY.equalTo(backview.mas_centerY);
            
        }];
        UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN.size.width, 1)];
        vline.backgroundColor = JHbgColor;
        [backview addSubview:vline];
        return backview;

    }else{
        UIImageView *view = [[UIImageView alloc]init];
        view.image = [UIImage imageNamed:@"fengexiantongyong"];
        return view;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 50;
    }
    return 10;

}


@end
