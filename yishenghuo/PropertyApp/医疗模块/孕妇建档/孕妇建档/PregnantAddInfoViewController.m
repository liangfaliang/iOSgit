//
//  PregnantAddInfoViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/27.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PregnantAddInfoViewController.h"
#import "MHDatePicker.h"
#import "PickerChoiceView.h"
#import "TZImagePickerController.h"
#import "YYText.h"
@interface PregnantAddInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MHSelectPickerViewDelegate,TFPickerDelegate,TZImagePickerControllerDelegate>

@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong,nonatomic)NSMutableArray *subViewArray;
@property (strong,nonatomic)NSArray *nameArr;
@property (strong,nonatomic)NSArray *placeholderArr;
@property (strong,nonatomic)NSString *dateTime;
@property (strong,nonatomic)NSString *week;
@property (strong,nonatomic)UIImage *icon;
@end

@implementation PregnantAddInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"孕产妇信息";
    self.nameArr = @[@"头像",@"居住小区",@"姓名",@"联系电话",@"身份证号\n保存后不可修改",@"怀孕周数",@"预产期"];
    self.placeholderArr = @[@"",@"请输入居住小区",@"请输入姓名",@"请输入联系电话",@"请输入身份证号",@"请选择",@"请选择"];
    [self createUI];
}
-(NSMutableArray *)subViewArray{
    if (_subViewArray == nil) {
        _subViewArray = [[NSMutableArray alloc]init];
    }
    return _subViewArray;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(void)createUI{
    
    for (int i = 0; i < self.nameArr.count; i ++) {
        if(i == 0){
            UIImageView * imview = [[UIImageView alloc]init];
            imview.layer.shouldRasterize = YES;
            imview.layer.cornerRadius = 28;
            imview.layer.masksToBounds = YES;
            imview.image = [UIImage imageNamed:@"touxiang"];
            [self.subViewArray addObject:imview];
        }else if(i == 5 || i == 6){
            UILabel * lb = [[UILabel alloc]init];
            lb.text = self.placeholderArr[i];
            lb.textColor  = JHsimpleColor;
            lb.textAlignment = NSTextAlignmentRight;
            lb.font = [UIFont systemFontOfSize:15];
            lb.numberOfLines = 0;
            [self.subViewArray addObject:lb];
        }else{
            UITextField *tf = [[UITextField alloc]init];
            tf.placeholder = self.placeholderArr[i];
            //            tf.textAlignment = NSTextAlignmentRight;
            tf.font = [UIFont systemFontOfSize:15];
            tf.textColor = JHmiddleColor;
            if (i == 3 || i == 4) {
                tf.keyboardType = UIKeyboardTypeNumberPad;
            }
            [self.subViewArray addObject:tf];
        }
        
    }
    LFLog(@"self.subViewArray:%@",self.subViewArray);
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 50) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorColor = JHColor(222, 222, 222);
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"othercell"];
    self.tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableview];
    
//    UIView * foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];
//    self.tableview.tableFooterView = foootview;
//    [foootview addSubview:submitBtn];
//    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(70);
//        make.centerX.equalTo(foootview.mas_centerX);
//    }];
    UIButton * submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50)];
    submitBtn.backgroundColor = JHMedicalColor;
    [submitBtn setTitle:@"提交信息" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [submitBtn setImage:[UIImage imageNamed:@"tijiaobuttun"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(employsubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}
#pragma mark 性别点击
-(void)sexBtnClick:(IndexBtn *)sender{
    sender.selected = YES;
    NSMutableArray *btnArr = self.subViewArray[1];
    for (IndexBtn *btn in btnArr) {
        if (btn != sender) {
            btn.selected = NO;
            return;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.nameArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"   信息必须填写完整哦" forState:UIControlStateNormal];
    [btn setTitleColor:JHMedicalColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"yunchanfutixing"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [header addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(0);
    }];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==  0) {
        return 85;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"creditcell%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YYLabel *label = [[YYLabel alloc]init];
        label.textColor = JHColor(53, 53, 53);
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 0;
        if (indexPath.row == 4) {
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.nameArr[indexPath.row]];
            text.yy_font = [UIFont boldSystemFontOfSize:13];
            NSRange range =[[text string]rangeOfString:@"\n保存后不可修改"];
            text.yy_color = JHdeepColor;
            text.yy_font = [UIFont systemFontOfSize:15];
            [text yy_setFont:[UIFont systemFontOfSize:12] range:range];
            [text yy_setColor:JHAssistRedColor range:range];
            text.yy_lineSpacing = 5;
            label.attributedText = text;
//            label.attributedText = [self.nameArr[indexPath.row] AttributedString:@"\n保存后不可修改" backColor:nil uicolor:JHAssistRedColor uifont:[UIFont systemFontOfSize:12]];
        }else{
            label.text = self.nameArr[indexPath.row];
        }
        
        CGSize lbsize = [label.text selfadaption:15];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.bottom.offset(0);
            make.top.offset(0);
            make.width.offset(lbsize.width + 5);
            
        }];
        if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 6) {
            UIImageView *rightIm = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gerenzhongxinjiantou"]];
            [cell.contentView addSubview:rightIm];
            [rightIm mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
        }
        if ([self.subViewArray[indexPath.row] isKindOfClass:[UIImageView class]]){
            UIImageView * imview = self.subViewArray[indexPath.row];
            [cell.contentView addSubview:imview];
            [imview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-60);
                make.width.offset(55);
                make.height.offset(55);
            }];
        }else if ([self.subViewArray[indexPath.row] isKindOfClass:[UILabel class]]){
            UILabel *lb = self.subViewArray[indexPath.row];
            [cell.contentView addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.left.equalTo(label.mas_right).offset(10);
                make.right.offset(-30);
                
            }];
        }else {
            UIView *tf = self.subViewArray[indexPath.row];
            [cell.contentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(0);
                make.top.offset(0);
                make.left.equalTo(label.mas_right).offset(10);
                make.right.offset(-30);
            }];
        }
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        //    imagePickerVc.autoDismiss = NO;
        imagePickerVc.maxImagesCount = 1;
        //        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingVideo = NO;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        return;
    }
    if ( indexPath.row == 6) {
        [self timeClick];
        return;
    }
    if ( indexPath.row == 5) {
        PickerChoiceView * _picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        _picker.titlestr = @"请选择";
        _picker.inter =2;
        _picker.delegate = self;
        _picker.arrayType = HeightArray;
        for (int i = 0; i < 50; i++) {
            [_picker.typearr addObject:[NSString stringWithFormat:@"%d周",i]];
        }
        [self.view addSubview:_picker];
        return;
    }
}
#pragma mark  图片选择成功的方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    LFLog(@"photos:%@",photos);
    if (photos.count && assets.count) {
        TZImagePickerController * mypicker = [[TZImagePickerController alloc]initCropTypeWithAsset:assets[0] photo:photos[0] completion:^(UIImage *cropImage, id asset) {
            UIImageView * imview = self.subViewArray[0];
            imview.image = cropImage;
            self.icon = cropImage;
        }];
        mypicker.needCircleCrop = YES;
        mypicker.circleCropRadius = SCREEN.size.width / 2 - 20;
        [self presentViewController:mypicker animated:YES completion:nil];
    }
    
}
#pragma mark - 选择时间点击事件
- (void)timeClick
{
    MHDatePicker *_selectTimePicker = [[MHDatePicker alloc] init];
    _selectTimePicker.datePickerMode = UIDatePickerModeDate;
    _selectTimePicker.isBeforeTime = NO;
    _selectTimePicker.minSelectDate = [NSDate date];
    _selectTimePicker.Displaystr = @"yyyy-MM-dd";
    _selectTimePicker.delegate = self;
}

#pragma mark - 时间回传值
- (void)timeString:(NSString *)timeString
{
    
    UILabel *lb = self.subViewArray[6];
    lb.text = timeString;
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[format dateFromString:timeString];
    time= (long)[fromdate timeIntervalSince1970];
    NSNumber *longNumber = [NSNumber numberWithLong:time];
    self.dateTime = [longNumber stringValue];
    
}
- (void)PickerSelectorIndixString:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    NSLog(@"%@",str);
    self.week = str;
    UILabel *lb = self.subViewArray[5];
    lb.text = str;
    
}
#pragma mark - 提交
-(void)employsubmitClick{
    [self upDateInfo];
}
//#pragma mark - *************宝宝关系*************
//-(void)requestDataChildRelation:(BOOL )isFirst{
//
//    NSDictionary * session =[userDefaults objectForKey:@"session"];
//    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
//    if (session) {
//        [dt setObject:session forKey:@"session"];
//    }
//    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ChildRelationUrl) params:dt success:^(id response) {
//        [_tableview.mj_header endRefreshing];
//        [_tableview.mj_footer endRefreshing];
//        LFLog(@"预约体检列表:%@",response);
//        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
//        if ([str isEqualToString:@"1"]) {
//            [self.dataArray removeAllObjects];
//            for (NSString *str in response[@"data"]) {
//                [self.dataArray addObject:str];
//            }
//        }else{
//            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
//            if ([error_code isEqualToString:@"100"]) {
//                [self showLogin:^(id response) {
//                    if ([response isEqualToString:@"1"]) {
//
//                    }
//
//                }];
//            }
//            [self presentLoadingTips:response[@"status"][@"error_desc"]];
//        }
//    } failure:^(NSError *error) {
//        LFLog(@"%@",error);
//        [self presentLoadingTips:@"请求失败！"];
//    }];
//
//}
-(void)upDateInfo{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSArray *parameterArr = @[@"",@"gra_address",@"gra_name",@"gra_mobile",@"gra_cardid",@"pregnancy_time",@"expected_childbirth"];
    for (int i = 0 ; i < self.subViewArray.count; i ++) {
        if ([self.subViewArray[i] isKindOfClass:[UITextField class]]) {
            UITextField *tf = self.subViewArray[i];
            if (!tf.text.length) {
                [self presentLoadingTips:self.placeholderArr[i]];
                [tf becomeFirstResponder];
                return;
            }else{
                if (i == 3 && tf.text.length != 11) {
                    [self presentLoadingTips:@"请输入正确的手机号！"];
                    return;
                }
                if (i == 4 && tf.text.length != 18) {
                    [self presentLoadingTips:@"请输入正确的身份账号！"];
                    return;
                }
                [dt setObject:tf.text forKey:parameterArr[i]];
            }
        }else if ([self.subViewArray[i] isKindOfClass:[UILabel class]]){
            if (i == 6) {
                if (self.dateTime) {
                    [dt setObject:self.dateTime forKey:parameterArr[i]];
                }else{
                    [self presentLoadingTips:@"请选择预产期"];
                    return;
                }
            }
            if (i == 5) {
                if (self.week) {
                    [dt setObject:self.week forKey:parameterArr[i]];
                }else{
                    [self presentLoadingTips:@"请选择怀孕周数"];
                    return;
                }
            }
        }
    }
    [self presentLoadingTips];
    LFLog(@"孕妇提交dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantInfoSumbitUrl) params:dt body:self.icon ? @[self.icon]:nil success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"孕妇提交：%@",response);
        [self dismissTips];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"提交成功"];
            [self performSelector:@selector(successClick) withObject:nil afterDelay:.2];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"提交失败，网络错误！"];
    }];
}
-(void)successClick{
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[ChildCareHomeViewController class]]) {
//            [((ChildCareHomeViewController*)vc) refeshData];
//            [self.navigationController popToViewController:vc animated:YES];
//            return;
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
