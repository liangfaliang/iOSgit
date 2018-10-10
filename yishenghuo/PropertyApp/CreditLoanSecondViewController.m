
//
//  CreditLoanSecondViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CreditLoanSecondViewController.h"
#import "AVCaptureViewController.h"
#import "CreditLoanThirdViewController.h"
@interface CreditLoanSecondViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITextField *tf;
}
@property (nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *nameArr1;
@property(nonatomic,strong)NSArray *imageArr;
@property(nonatomic,strong) NSMutableArray *boolArray;
@property(nonatomic,strong)NSMutableDictionary *imageDt;
@end

@implementation CreditLoanSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"贷款申请";
    self.nameArr1 = @[@"本人月收入：",@"预估贷款金额：",@"期望贷款金额："];
    self.imageArr = @[@"edushuoming",@"shenqingtiaojian_xinyongdai",@"yongfeishuoming_xinyongdai"];
    self.boolArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 3; i ++) {
        [self.boolArray addObject:@NO];
    }

    [self createUI];
    UILabel *rightLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    rightLb.font = [UIFont systemFontOfSize:15];
    rightLb.textColor = JHmiddleColor;
    rightLb.text = @"2/2步";
    UIBarButtonItem *rightItem= [[UIBarButtonItem alloc]initWithCustomView:rightLb];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(NSMutableDictionary *)imageDt{
    if (_imageDt == nil) {
        _imageDt = [[NSMutableDictionary alloc]init];
    }

    return _imageDt;
}

-(void)createUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIView *foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 200)];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setImage:[UIImage imageNamed:@"querenbingtijiao_xinyongdai"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(employsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [foootview addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(foootview.mas_centerY);
        make.centerX.equalTo(foootview.mas_centerX);
    }];
    self.tableView.tableFooterView = foootview;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.nameArr1.count;
    }else if (section == 1){
        return 1;
    }else if (section > 2){
        BOOL ret = [self.boolArray[section - 3] boolValue];
        if (ret) {
            
            return 1;
        }else{
            return 0;
        }
    }
    return 0;
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
        
        
        if (indexPath.section == 0 ) {
            
            UILabel *label = [[UILabel alloc]init];
            label.textColor = JHColor(53, 53, 53);
            label.font = [UIFont systemFontOfSize:15];
            label.text = self.nameArr1[indexPath.row];
            CGSize lbsize = [label.text selfadaption:15];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.offset(10);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.width.offset(lbsize.width + 5);
                
            }];
            
            UITextField *objclabel = [[UITextField alloc]init];
            objclabel.textColor = JHColor(102, 102, 102);
            objclabel.font = [UIFont systemFontOfSize:15];
            objclabel.tag = 55 + indexPath.row;
            objclabel.textColor = JHColor(0, 169, 224);
            objclabel.keyboardType = UIKeyboardTypeNumberPad;
            
            UILabel *lb = [[UILabel alloc]init];
            if (indexPath.row == 1) {
                if (self.PropertyDt) {
                    objclabel.text = [NSString stringWithFormat:@"%@",self.PropertyDt[@"sd_big_amount"]];
                }
                objclabel.enabled = NO;
                objclabel.adjustsFontSizeToFitWidth = YES;
                lb.text = @"(实际以最终审批结果为准)";
                lb.textColor = JHsimpleColor;
                lb.font = [UIFont systemFontOfSize:12];
                [cell.contentView addSubview:lb];
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-10);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.width.offset([lb.text selfadap:12 weith:20].width + 5);
                    
                }];
            }else{
            objclabel.placeholder = @"请输入";
            }
            [cell.contentView addSubview:objclabel];
            [objclabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(label.mas_right).offset(5);
                make.top.offset(0);
                make.bottom.offset(0);
                if (indexPath.row == 1) {
                    make.right.equalTo(lb.mas_left).offset(5);
                }else{
                    make.right.offset(-10);
                }
            }];
        }else if(indexPath.section == 1){
            NSArray *imarr = @[@"shenfenzhengrenxiangmian",@"shenfenzhengguohuimian"];
            for (int i = 0; i < 2; i ++) {
                UIImage *im = [UIImage imageNamed:imarr[i]];
                IndexBtn *btn = [[IndexBtn alloc]initWithFrame:CGRectMake(i ==0 ?10 : SCREEN.size.width/2 + 5, 15, (SCREEN.size.width - 20)/2, [UIImage imageNamed:@"shenfenzhengkuang"].size.height)];
                btn.index = i + 10;
                [btn setBackgroundImage:[UIImage imageNamed:@"shenfenzhengkuang"] forState:UIControlStateNormal];
                [btn setImage:im forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(IdCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
            }
//            [self.imageDt setObject:[UIImage imageNamed:@"shenfenzhengrenxiangmian"] forKey:@"Negative"];//反面
//             [self.imageDt setObject:[UIImage imageNamed:@"shenfenzhengguohuimian"] forKey:@"positive"];//
            
        }

    }
    if(indexPath.section > 2){
        [cell.contentView removeAllSubviews];
        NSString *text = @"";
        if (indexPath.section == 3) {
            if (self.dataDt[@"quota"]) {
                text = self.dataDt[@"quota"];
            }
        }else if (indexPath.section == 4) {
            if (self.dataDt[@"appcond"]) {
                text = self.dataDt[@"appcond"];
            }
        }else if (indexPath.section == 5) {
            if (self.dataDt[@"paydesc"]) {
                text = self.dataDt[@"paydesc"];
            }
        }
        UILabel *contentLb = [[UILabel alloc]init];
        contentLb.text = text;
        contentLb.numberOfLines = 0;
        contentLb.textColor =  JHmiddleColor;
        contentLb.font = [UIFont systemFontOfSize:12];
        [contentLb NSParagraphStyleAttributeName:10];
        [cell.contentView addSubview:contentLb];
        [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.bottom.offset(0);
            make.top.offset(0);
            make.right.offset(-10);
        }];
        
    }
    
    return cell;
    
    
}
//上传身份证
-(void)IdCardBtnClick:(IndexBtn *)sender{
    
    AVCaptureViewController *AVCaptureVC = [[AVCaptureViewController alloc] init];
    if (sender.index == 10) {
        [AVCaptureVC StartTesting:YES];
    }else{
        [AVCaptureVC StartTesting:NO];
    }
    [AVCaptureVC successfulGetIdCodeInfo:^(IDInfo *Info, UIImage *image) {
        LFLog(@"Info:%@",Info.num);
        if (sender.index == 10) {
            if (self.keyArr1.count > 1) {
                if ([self.keyArr1[1] isEqualToString:Info.num]) {
                    [sender setImage:image forState:UIControlStateNormal];
                    [self.imageDt setObject:image forKey:@"Negative"];//反面
                }else{
                    [self alertController:@"提示" prompt:@"扫描身份证信息和您输入的身份证号码信息不一致，请重新拍摄!" sure:@"确定" cancel:nil success:^{
                        
                    } failure:^{
                        
                    }];
                }
            }else{
                [self presentLoadingTips:@"您输入的身份证号码不存在，请核对!"];
            }
            
        }else{
            [sender setImage:image forState:UIControlStateNormal];
            [self.imageDt setObject:image forKey:@"positive"];//正面
        }
        
    }];
    
    [self.navigationController pushViewController:AVCaptureVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIImageView *imagevw = [[UIImageView alloc]init];
    imagevw.userInteractionEnabled = YES;
    if (section < 2) {
        imagevw.image = [UIImage imageNamed:@"biaotikuang_xinyongdai"];
        UILabel *lb = [[UILabel alloc]init];
        lb.font = [UIFont systemFontOfSize:14];
        lb.textColor = JHsimpleColor;
        if (section == 0) {
            lb.text = @"贷款人意向";
        }else{
            lb.text = @"上传身份证照片";
        }
        [imagevw addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.offset(-10);
        }];
    }else{
        imagevw.image = nil;
        IndexBtn *senderBtn = [[IndexBtn alloc]init];
        if (section > 2) {
            senderBtn.index = section;
            [senderBtn addTarget:self action:@selector(senderBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
             [senderBtn setImage:[UIImage imageNamed:self.imageArr[section - 3]] forState:UIControlStateNormal];
            senderBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        }else{
            [senderBtn setTitle:@"贷款说明" forState:UIControlStateNormal];
            [senderBtn setTitleColor:JHColor(0, 169, 224) forState:UIControlStateNormal];
            
        }
        [imagevw addSubview:senderBtn];
        [senderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(imagevw.mas_centerY);
        }];
    }

    return imagevw;
    
}
//点击展开
-(void)senderBtnClick:(IndexBtn *)btn event:(id)event{

//    NSSet *touches =[event allTouches];
//    UITouch *touch =[touches anyObject];
//    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
//    NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:currentTouchPosition];
//    LFLog(@"x:%f  y:%f",currentTouchPosition.x,currentTouchPosition.y);
    LFLog(@"indexPath.row:%ld",(long)btn.index);
    BOOL ret = [self.boolArray[btn.index - 3] boolValue];
    if (ret) {
        [self.boolArray replaceObjectAtIndex:btn.index - 3 withObject:@NO];
    }else{
        [self.boolArray replaceObjectAtIndex:btn.index -3 withObject:@YES];
        
    }
    
    [ self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:btn.index]withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return [UIImage imageNamed:@"shenfenzhengkuang"].size.height + 30;
    }
    if (indexPath.section > 2) {
        NSString *text = @"";
        if (indexPath.section == 3) {
            if (self.dataDt[@"quota"]) {
                text = self.dataDt[@"quota"];
            }
        }else if (indexPath.section == 4) {
            if (self.dataDt[@"appcond"]) {
                text = self.dataDt[@"appcond"];
            }
        }else if (indexPath.section == 5) {
            if (self.dataDt[@"paydesc"]) {
                text = self.dataDt[@"paydesc"];
            }
        }
        return [text selfadap:12 weith:20 Linespace:10].height + 15;
    }
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

#pragma mark 下一步
-(void)employsubmitClick:(UIButton *)btn{
//    [self.imageDt setObject:image forKey:@"Negative"];//反面
//}else{
//    [self.imageDt setObject:image forKey:@"positive"];//正面
    UITextField *tf1 = [self.view viewWithTag:55];
    UITextField *tf2 = [self.view viewWithTag:57];
    if (tf1.text.length == 0) {
        [self presentLoadingTips:@"请请输入本人月收入"];
        [tf1 becomeFirstResponder];
        return;
    }
    if (tf2.text.length == 0) {
        [self presentLoadingTips:@"请请输入期望贷款金额"];
        [tf2 becomeFirstResponder];
        return;
    }
    if (!self.imageDt[@"Negative"]) {
        [self presentLoadingTips:@"请先拍照身份证的反面"];
        return;
    }
    if (!self.imageDt[@"positive"]) {
        [self presentLoadingTips:@"请先拍照身份证的正面"];
        return;
    }
    [self.view endEditing:YES];
    [self UpdateFile];
 
}

-(void)UpdateFile{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 2; i ++) {
        NSMutableDictionary *mdt = [[NSMutableDictionary alloc]init];
        [mdt setObject:ImagePathKey forKey:FliePathKey];
        if (i == 0) {
            [mdt setObject:@"身份证反面" forKey:ImageNameKey];
            [mdt setObject:self.imageDt[@"Negative"] forKey:FlieImageKey];
        }else{
            [mdt setObject:@"身份证正面" forKey:ImageNameKey];
            [mdt setObject:self.imageDt[@"positive"] forKey:FlieImageKey];
        }
        [marr addObject:mdt];
        
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ImagePath_FileUrl) params:nil body:marr success:^(id response) {
        //    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ImagePathUrl) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"上传文件：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self submitDataload:response[@"data"]];
        }else{
            [self presentLoadingTips:@"身份证上传失败"];
        }
        
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"身份证上传失败"];

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - *************申请提交*************
-(void)submitDataload:(NSDictionary *)FileDt{
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
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) {
        uid = @"";
    }
    NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithObjectsAndKeys:leid,@"leid",coid,@"coid",mobile,@"mobile",uid,@"usid", nil];
    if (self.keyArr1.count) {
        [dt setObject:self.keyArr1[0] forKey:@"cu_name"];
    }
    if (self.PropertyDt) {
        [dt setObject:self.PropertyDt[@"poid"] forKey:@"poid"];
        [dt setObject:self.PropertyDt[@"po_name"] forKey:@"po_name"];
        [dt setObject:self.PropertyDt[@"sd_value"] forKey:@"sd_value"];
        [dt setObject:self.PropertyDt[@"sd_suggest_value"] forKey:@"sd_suggest_value"];
        [dt setObject:self.PropertyDt[@"sd_big_amount"] forKey:@"sd_big_amount"];
    }
    UITextField *tf1 = [self.view viewWithTag:55];
    UITextField *tf2 = [self.view viewWithTag:57];
    [dt setObject:tf1.text forKey:@"sd_guarantee_amount"];
    [dt setObject:tf2.text forKey:@"po_amount"];
    if (FileDt.count) {
        if (FileDt[@"身份证正面"]) {
            [dt setObject:FileDt[@"身份证正面"] forKey:@"imageA"];
        }
        if (FileDt[@"身份证反面"]) {
            [dt setObject:FileDt[@"身份证反面"] forKey:@"imageB"];
        }

    }
    NSString *dateString = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    [dt setObject:dateString forKey:@"apply_time"];
    
    LFLog(@"申请提交dt:%@",dt);
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"jrSave") params:dt success:^(id response) {
        LFLog(@"申请提交:%@",response);
        
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            [self presentLoadingTips:response[@"date"]];
            CreditLoanThirdViewController *third = [[CreditLoanThirdViewController alloc]init];
            if ([response[@"sdid"] isKindOfClass:[NSString class]] ) {
                third.sdid  = response[@"sdid"];
            }
            [self.navigationController pushViewController:third animated:YES];
//            [self performSelector:@selector(goBlack) withObject:nil afterDelay:2.0];
            
        }else{
        
        }
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

@end
