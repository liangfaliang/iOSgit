//
//  CreditLoanRecordDetailsController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/12.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CreditLoanRecordDetailsController.h"
#import "UIButton+WebCache.h"
#import "UIView+i7Rotate360.h"
@interface CreditLoanRecordDetailsController ()<UITableViewDelegate,UITableViewDataSource>{
    UITextField *tf;
    CGFloat angle;//图片旋转
    UIView *foootview;
}
@property (nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *nameArr1;
@property(nonatomic,strong)NSArray *nameArr2;
@property(nonatomic,strong)NSArray *nameArr3;
@property(nonatomic,strong)NSArray *keyArr1;
@property(nonatomic,strong)NSArray *keyArr2;
@property(nonatomic,strong)NSArray *keyArr3;
@end

@implementation CreditLoanRecordDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    angle = 0;
    self.navigationBarTitle = @"贷款申请记录";
    self.nameArr1 = @[@"业主姓名：",@"身份证号：",@"联系电话：",];
    self.nameArr2 = @[@"房屋地址：",@"建筑面积：",@"小区评估价：",@"房屋估值："];
    self.nameArr3 = @[@"本人月收入：",@"预估贷款金额：",@"期望贷款金额："];
    self.keyArr1 = @[@"cu_Name",@"cu_idno",@"cu_telp"];
    self.keyArr2 = @[@"em_name",@"sp_spua",@"sd_value",@"sd_suggest_value"];
    self.keyArr3 = @[@"sd_guarantee_amount",@"sd_big_amount",@"po_amount"];
    [self createUI];
    [self UploadDataSchedule];//进度
    if (self.dataArray.count == 0) {
        [self UploadDatadynamicList];
    }
    

}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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
-(void)stopLoppAnimation:(UIImageView *)iamgview{

    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        iamgview.transform = endAngle;
    } completion:^(BOOL finished) {
        angle = angle+5; //旋转速度的快慢
        [self stopLoppAnimation:iamgview];
    }];


}
/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.frame)/2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    
    [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.nameArr1.count;
    }else if (section == 1){
        return self.nameArr2.count;
    }else if (section == 2){
        return self.nameArr3.count;
    }else if (section == 3){
        if (self.dataArray.count) {
            if ([self.dataArray[0][@"imageA"] isKindOfClass:[NSString class]] || [self.dataArray[0][@"imageB"] isKindOfClass:[NSString class]]) {
                return 1;
            }
        }

    }
  
    return 0;
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
        
    }
    [cell.contentView removeAllSubviews];

    if (indexPath.section < 3) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = JHColor(53, 53, 53);
        label.font = [UIFont systemFontOfSize:15];
        NSString *key = @"";
        if (indexPath.section == 0) {
            key = self.keyArr1[indexPath.row];
            label.text = self.nameArr1[indexPath.row];
        }else if(indexPath.section == 1){
            key = self.keyArr2[indexPath.row];
            label.text = self.nameArr2[indexPath.row];
        }else if(indexPath.section == 2){
            key = self.keyArr3[indexPath.row];
            label.text = self.nameArr3[indexPath.row];
        }
        
        
        CGSize lbsize = [label.text selfadaption:15];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset(lbsize.width + 5);
            
        }];
        UILabel *objclabel = [[UILabel alloc]init];
        objclabel.textColor = JHColor(102, 102, 102);
        objclabel.font = [UIFont systemFontOfSize:15];
        objclabel.numberOfLines = 0;
        if (self.dataArray.count) {
            if (self.dataArray[0][key]) {
                objclabel.text = [NSString stringWithFormat:@"%@",self.dataArray[0][key]];
            }
        }
        
        
        [cell.contentView addSubview:objclabel];
        [objclabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(label.mas_right).offset(5);
            make.top.offset(0);
            make.bottom.offset(0);
            make.width.offset([objclabel.text selfadap:15 weith:lbsize.width + 20].width +5);
            
        }];
        if (indexPath.section == 2) {
            if(indexPath.row == 1){
                UILabel *lb = [[UILabel alloc]init];
                lb.text = @"(实际以最终审批结果为准)";
                lb.textColor = JHsimpleColor;
                lb.font = [UIFont systemFontOfSize:12];
                lb.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:lb];
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-10);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.left.equalTo(objclabel.mas_right).offset(0);
                }];
            }else if(indexPath.row == 2){
                objclabel.textColor = JHColor(0, 169, 224);
            }
        }
        
    }else{
        NSMutableArray *imarr = [[NSMutableArray alloc]init];
        if ([self.dataArray[0][@"imageA"] isKindOfClass:[NSString class]]) {
            [imarr addObject:self.dataArray[0][@"imageA"]];
        }
        if ([self.dataArray[0][@"imageB"] isKindOfClass:[NSString class]]) {
            [imarr addObject:self.dataArray[0][@"imageB"]];
        }
        for (int i = 0; i < imarr.count; i ++) {
            IndexBtn *btn = [[IndexBtn alloc]initWithFrame:CGRectMake(i ==0 ?10 : SCREEN.size.width/2 + 5, 15, (SCREEN.size.width - 20)/2, [UIImage imageNamed:@"shenfenzhengkuang"].size.height)];
            btn.string = imarr[i];
            [btn sd_setImageWithURL:[NSURL URLWithString:imarr[i]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"shenfenzhengkuang"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(IdcodeClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
        
    }

    
    return cell;
    
    
}
-(void)IdcodeClick:(IndexBtn *)btn{
    NSArray *arr = @[btn.string];
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:arr currentIndex:0];
    [broser show];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *imagevw = [[UIImageView alloc]init];
    imagevw.image = [UIImage imageNamed:@"biaotikuang_xinyongdai"];
    UILabel *lb = [[UILabel alloc]init];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = JHsimpleColor;
    if (section == 0) {
        lb.text = @"贷款人基本信息";
    }else if(section == 1){
        lb.text = @"贷款人房产信息";
    }else if(section == 2){
        lb.text = @"贷款意向";
    }else if(section == 3){
        lb.text = @"身份证照片";
    }else if(section == 4){
        lb.text = @"贷款进度";
    }
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
    if (indexPath.section == 3) {
        if (self.dataArray.count) {
            if ([self.dataArray[0][@"imageA"] isKindOfClass:[NSString class]] || [self.dataArray[0][@"imageB"] isKindOfClass:[NSString class]]) {
                return [UIImage imageNamed:@"shenfenzhengkuang"].size.height + 30;
            }
        }

    }
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

#pragma mark - *************记录详情*************
-(void)UploadDatadynamicList{
    [self presentLoadingTips];
    NSString *leid = [UserDefault objectForKey:@"leid"];
    if (leid == nil) {
        leid = @"";
    }
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }
    NSString *mobile = [UserDefault objectForKey:@"mobile"];
    if (mobile == nil) {
        mobile = @"";
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:leid,@"leid",coid,@"coid",mobile,@"mobile", nil];
    if (self.sdid) {
        [dt setObject:self.sdid forKey:@"sdid"];
    }
    //    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    //    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    //    [dt setObject:pagination forKey:@"pagination"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"103") params:dt success:^(id response) {
        LFLog(@"记录:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            [self.dataArray removeAllObjects];

            [self.dataArray addObject:response[@"note"][0]];
            [self.tableView reloadData];
        }else{
            
            [self presentLoadingTips:response[@"date"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - *************进度详情*************
-(void)UploadDataSchedule{
    NSString *leid = [UserDefault objectForKey:@"leid"];
    if (leid == nil) {
        leid = @"";
    }
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }
    NSString *mobile = [UserDefault objectForKey:@"mobile"];
    if (mobile == nil) {
        mobile = @"";
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:leid,@"leid",coid,@"coid",mobile,@"mobile", nil];
    if (self.sdid) {
        [dt setObject:self.sdid forKey:@"sdid"];
    }
    
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"105") params:dt success:^(id response) {
//    [LFLHttpTool get:@"http://120.26.112.117/weixin/?coid=10&id=105&sdid=CLT-ED-TB-09072017-000005&usid=1697" params:nil success:^(id response) {
        LFLog(@"进度:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            NSArray *arr = response[@"arr"];
//            NSArray *arr = @[@{@"path1":@[@{@"cu_name":@"12"}],
//                               @"path2":@[@{@"sd_name":@"12"}],
//                               @"path3":@[@{@"sd_name":@"12"}]
//                               @"path4":@[@{@"sd_name":@"12"}]
//                               }];
            NSArray *arrname = response[@"arrname"];
//            NSArray *arrname = @[@{
//                                     @"path6":@[@{@"cu_name":@"12",@"apply_time":@"2017-7-10"}],
//                                   @"path7":@[@{@"sd_states":@"1",@"sd_incedate":@"2017-7-10 13:49:23"}],
//                                   @"path8":@[@{@"sd_states":@"2",@"sd_incedate":@"2017-7-10 13:49:23"}]
//                                   ,@"path9":@[@{@"sd_states":@"1",@"sd_incedate":@"2017-7-10 13:49:23"}]
//                                   }];
            if (foootview == nil) {
                foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 650)];
                
                UIView *dashedViewGray = [[UIView alloc]initWithFrame:CGRectMake(125, 20, 1, 350)];
                [foootview addSubview:dashedViewGray];
                
                UIView *dashedView = [[UIView alloc]initWithFrame:CGRectMake(125, 20, 1, 300)];
                [foootview addSubview:dashedView];
                CGFloat HH = 20;
                NSArray *imageArr = @[@"tijiaoshenqing_hui",@"xianxiamianqian_hui",@"shenhepidai_hui",@"yinhangfangkuan_hui",@"daikuanwanchenghuise"];
                NSArray *selectImageArr = @[@"tijiaoshenqing_lan",@"xianxiamianqian_lan",@"shenhepidai_lan",@"yinhangfangkuan_lan",@"daikuanwanchenghua"];
                NSArray *nameArr = @[@"提交申请",@"线下面签",@"审核批贷",@"银行放款",@"贷款完成"];
                for (int i = 0; i < nameArr.count; i ++) {
                    UIImage *im = [UIImage imageNamed:imageArr[i]];
                    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(110, HH, im.size.width, im.size.height)];
                    NSString *path = [NSString stringWithFormat:@"path%d",i + 1];
                    NSString *pathname = [NSString stringWithFormat:@"path%d",i + 6];
                    if (arr.count) {
                        if (arr[0][path]) {
                            im = [UIImage imageNamed:selectImageArr[i]];
                        }
                    }
                    iconImage.image = im;
                    [foootview addSubview:iconImage];
                    //转圈圈图标
                    if (arr.count && arr[0][path]) {
                        if (arrname.count && !arrname[0][pathname]) {
                            UIImageView *TurnImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuanzhuanquanquan"]];
                            TurnImage.backgroundColor = [UIColor clearColor];
                            [foootview addSubview:TurnImage];
                            [TurnImage mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.centerX.equalTo(iconImage.mas_centerX).offset(0);
                                make.centerY.equalTo(iconImage.mas_centerY).offset(0);
                            }];
                            [self stopLoppAnimation:TurnImage];
                        }
                        
                    }
                    UILabel *nameLb = [[UILabel alloc]init];
                    nameLb.text = nameArr[i];
                    nameLb.textColor = JHmiddleColor;
                    nameLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
                    [foootview addSubview:nameLb];
                    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(iconImage.mas_right).offset(10);
                        make.centerY.equalTo(iconImage.mas_centerY).offset(0);
                        //            make.height.offset(20);
                        //            make.right.offset(-10);
                    }];
                    if (arrname.count && arrname[0][pathname]) {
                        if (i == 0) {
                            if ([arrname[0][pathname][0][@"cu_name"] isKindOfClass:[NSString class]]) {
                                nameLb.textColor = JHColor(36, 168, 230);
                            }
                        }else{
                            if ([arrname[0][pathname][0][@"sd_states"] isKindOfClass:[NSString class]]) {
                                if ([[NSString stringWithFormat:@"%@",arrname[0][pathname][0][@"sd_states"]] isEqualToString:@"1"]) {
                                    nameLb.textColor = JHColor(36, 168, 230);
                                }else if ([[NSString stringWithFormat:@"%@",arrname[0][pathname][0][@"sd_states"]] isEqualToString:@"2"]){
                                nameLb.text = [NSString stringWithFormat:@"%@（未通过）",nameArr[i]];
                                }
                            }
                        }
                    }
                    UILabel *contentLb = [[UILabel alloc]init];
                    contentLb.textColor = JHmiddleColor;
                    contentLb.textAlignment = NSTextAlignmentCenter;
                    contentLb.numberOfLines = 0;
                    contentLb.font = [UIFont systemFontOfSize:11];
                    [foootview addSubview:contentLb];
                    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                        //            make.left.equalTo(iconImage.mas_right).offset(10);
                        //            make.top.equalTo(nameLb.mas_bottom).offset(5);
                        //            make.right.offset(-10);
                        make.left.offset(10);
                        make.right.equalTo(iconImage.mas_left).offset(10);
                        make.centerY.equalTo(iconImage.mas_centerY).offset(0);
                    }];
                    if (arrname.count && arrname[0][pathname]) {
                        NSString *time = @"";
                        if (i == 0) {
                            if ([arrname[0][pathname][0][@"apply_time"] isKindOfClass:[NSString class]]) {
                                time = arrname[0][pathname][0][@"apply_time"];
                            }
                        }else{
                            if ([arrname[0][pathname][0][@"sd_incedate"] isKindOfClass:[NSString class]]) {
                                time = arrname[0][pathname][0][@"sd_incedate"];
                            }
                        }
                        NSArray *timeArr = [time componentsSeparatedByString:@" "];
                        if (timeArr.count) {
                            if (timeArr.count > 1) {
                                contentLb.text = [NSString stringWithFormat:@"%@\n%@",timeArr[1],timeArr[0]];
                            }else{
                            contentLb.text = time;
                            }
                        }
                        
                        
                    }
                    if (arr.count && arr[0][path]) {
                        dashedView.frame = CGRectMake(125, 20, 1, HH - 20);
                    }
                    if (i == 4) {
                        if (arr.count && arr[0][@"path4"]) {
                            if (arrname.count && arrname[0][@"path9"]) {
                                if ([[NSString stringWithFormat:@"%@",arrname[0][@"path9"][0][@"sd_states"]] isEqualToString:@"1"]) {
                                    nameLb.textColor = JHColor(36, 168, 230);
                                    iconImage.image = [UIImage imageNamed:@"daikuanwanchenghua"];
                                    dashedView.frame = CGRectMake(125, 20, 1, HH - 20);
                                }
                            }
                        }
                    }
                    if (i == nameArr.count - 1) {
                        dashedViewGray.frame = CGRectMake(125, 20, 1, HH - 20);
                    }
                    //        HH += [contentLb.text selfadap:11 weith:50].height + 40;
                    HH += 70;
                }
                [self drawDashLine:dashedView lineLength:2 lineSpacing:2 lineColor:JHMaincolor];
                [self drawDashLine:dashedViewGray lineLength:2 lineSpacing:2 lineColor:[UIColor grayColor]];
                foootview.frame = CGRectMake(0, 0, SCREEN.size.width, HH + 30);
                self.tableView.tableFooterView = foootview;
            }
            [self.tableView reloadData];
        }else{
            
            [self presentLoadingTips:response[@"date"]];
        }
    } failure:^(NSError *error) {
//        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end

