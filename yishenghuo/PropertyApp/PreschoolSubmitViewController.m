
//
//  PreschoolSubmitViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PreschoolSubmitViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "PreschoolModel.h"
#import "MChooseBanKuaiViewController.h"
#import "UITextView+Placeholder.h"
#import "YYText.h"
#import "ImTopBtn.h"
#import "SKGraphicViewController.h"
#import "MHDatePicker.h"
@interface PreschoolSubmitViewController ()<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,MHSelectPickerViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *leftBtnView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)PreschoolModel *model;
@property(nonatomic, strong)UITextView *tfview;
@property (nonatomic, strong) UIView *selectTimeView;
@property (nonatomic, strong) UIImage *signImage;
@end

@implementation PreschoolSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitle = @"填写报名表";
    self.model = [[PreschoolModel alloc]init];
    [self setupUI];
    self.isEmptyDelegate = NO;
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(0, screenH -  50, screenW,  50)];
    footview.backgroundColor = JHAssistRedColor;;
    [footview setTitle:@"提交报名表" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITextView *)tfview{
    if (_tfview == nil) {
        _tfview = [[UITextView alloc]init];
        _tfview.text = @"家长签字";
        [_tfview setViewBorderColor:JHBorderColor borderWidth:1];
        _tfview.delegate = self;
    }
    return _tfview;
}
-(UIView *)selectTimeView{
    if (!_selectTimeView) {
        CGFloat wid = [@"性      别" selfadap:15 weith:100].width;
        _selectTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW - 35 -wid, 40)];
        for (int i = 0; i < 2; i ++) {
            ImTopBtn *btn = [[ImTopBtn alloc]initWithFrame:CGRectMake(i * (_selectTimeView.width / 2), 0, _selectTimeView.width / 2, _selectTimeView.height)];
            btn.index = i;
            [btn addTarget:self action:@selector(SelectTimeClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"   %@",i ? @"女": @"男"] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"   %@",i ? @"女": @"男"] forState:UIControlStateSelected];
            if (i == 0) {
                btn.selected = YES;
                self.model.sex = @"0";
            }
            [_selectTimeView addSubview:btn];
        }
    }
    return _selectTimeView;
}
-(void)SelectTimeClick:(ImTopBtn *)btn{
    btn.selected = YES;
    for (UIButton *sender in self.selectTimeView.subviews) {
        if (btn != sender) {
            sender.selected = NO;
        }
    }
    self.model.sex = btn.index ? @"1" : @"0";
}
#pragma  mark 立即预约
-(void)submitClick{
    for (NSMutableArray *marr in self.dataArray) {
        for (TextFiledModel *tmodel in marr) {
            if (!tmodel.value && tmodel.prompt) {
                [self presentLoadingTips:tmodel.prompt];
                return;
            }else{
                if (tmodel.value) {
                    [self.model setValue:tmodel.value forKey:tmodel.key];
                }

            }
            
        }
    }
    if (!self.signImage) {
        [self presentLoadingTips:@"请先签字"];
        return;
    }
    NSMutableDictionary *mdt = [self.model mj_keyValues];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    [mdt setObject:session forKey:@"session"];
    [self SubmitData:mdt];
}
#pragma  mark 房屋选择
- (void)setupUI{
    
    //prompt：必填提示语
    NSArray * array = @[@[@{@"name":@"类      别",@"text":@"",@"placeholder":@"请选择",@"key":@"en_type",@"rightim":@"1",@"prompt":@"请选择类别"},
                          @{@"name":@"幼儿姓名",@"placeholder":@"请请输入儿童姓名",@"key":@"name",@"enable":@"1",@"prompt":@"请请输入儿童姓名"},
                          @{@"name":@"性      别",@"key":@"sex",@"enable":@"1"},
                          @{@"name":@"出生年月",@"text":@"",@"placeholder":@"请选择",@"key":@"birthday",@"rightim":@"1",@"prompt":@"请选择出生年月"},
                          @{@"name":@"有无过敏史、特殊病史",@"text":@"",@"placeholder":@"请填写",@"key":@"medical_history",@"enable":@"1"}],
                        
                        
                        @[@{@"name":@"父亲姓名",@"text":@"",@"placeholder":@"请输入父亲姓名",@"key":@"father_name",@"enable":@"1"},
                          @{@"name":@"联系电话",@"text":@"",@"placeholder":@"请输入手机号",@"key":@"father_mobile",@"enable":@"1"},
                          @{@"name":@"工作单位",@"text":@"",@"placeholder":@"请填写",@"key":@"father_work",@"enable":@"1"}
                          ],
                        @[@{@"name":@"母亲姓名",@"text":@"",@"placeholder":@"请输入母亲姓名",@"key":@"mother_name",@"enable":@"1"},
                          @{@"name":@"联系电话",@"text":@"",@"placeholder":@"请输入手机号",@"key":@"mother_mobile",@"enable":@"1"},
                          @{@"name":@"工作单位",@"text":@"",@"placeholder":@"请填写",@"key":@"mother_work",@"enable":@"1"}
                          ],
                        @[@{@"name":@"家庭住址",@"text":@"",@"placeholder":@"请填写家庭住址",@"key":@"home_address",@"enable":@"1",@"prompt":@"请填写家庭住址"},
                          @{@"name":@"备      注",@"text":@"",@"key":@"remarks",@"enable":@"1"}
                          ]];
    
    for (NSArray *arr in array) {
        NSMutableArray *marr = [NSMutableArray array];
        for (NSDictionary *dt in arr) {
            TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
            [marr addObject:model];
        }
        [self.dataArray addObject:marr];
    }
    [self initTableView];
}


#pragma mark - tableView
- (void)initTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 50) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = 75;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TextFiledLableTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TextFiledLableTableViewCell class])];
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 200)];
    footer.backgroundColor = [UIColor whiteColor];
    NSString  *str = @"我已阅读诚信承诺，以上信息真实有效";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:str];
    text.yy_font = [UIFont systemFontOfSize:15];
    text.yy_textUnderline.color = JHMaincolor;
    text.yy_textUnderline = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle
                                    width:@(1)
                                    color:JHMaincolor];

    text.yy_color = JHMaincolor;
    NSRange ran1 = [str rangeOfString:str];
    [text yy_setTextHighlightRange:ran1 color:JHMaincolor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //            WKPresentViewController *html = [[WKPresentViewController alloc]init];
        //            html.titleStr = strArr[i];
        //            html.urlStr = [NSString stringWithFormat:@"%@%@%d",EnergyBaseUrl,MineHTMLUrl,i + 6];
        //            [self presentViewController:html animated:YES completion:nil];
    }];
    YYLabel *lb = [[YYLabel alloc]init];
    lb.attributedText = text;
    lb.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(30);
        make.bottom.offset(-10);
    }];
    [footer addSubview:self.tfview];
    [self.tfview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
        make.bottom.offset(-40);
    }];
    _tableView.tableFooterView = footer;
    [self.view addSubview:_tableView];
}
#pragma  mark textviewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    SKGraphicViewController *vc = [[SKGraphicViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    vc.saveBlock = ^(UIImage *image) {
        weakSelf.signImage = image;
        if (image) {
            self.tfview.text = @"";
            self.tfview.backgroundImage = image;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextFiledLableTableViewCell class]) forIndexPath:indexPath];
    cell.textfiled.textAlignment = NSTextAlignmentLeft;
    NSMutableArray *marr = self.dataArray[indexPath.section];
    TextFiledModel *model = marr[indexPath.row];
    cell.model = model;

    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.textfiled.leftView = self.selectTimeView;
        cell.textfiled.leftViewMode =  UITextFieldViewModeAlways;
    }else {
        cell.textfiled.leftView = nil;
    }
    //    WEAKSELF;
    //    cell.TextChangeBlock = ^(NSString *text) {
    //        LFLog(@"row:%ld",(long)indexPath.row);
    //        NSMutableDictionary *mdt = weakSelf.dataArray[indexPath.row];
    //        [mdt setObject:text ? text :@"" forKey:@"value"];
    //
    //    } ;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *marr = self.dataArray[indexPath.section];
    TextFiledModel *wmodel = marr[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        MChooseBanKuaiViewController *vc = [[MChooseBanKuaiViewController alloc] init];
        vc.type = SelectPreschool;
        __weak typeof(self) weakSelf = self;
        vc.doneBlock = ^(HSDTagModel *model,id dict){
            wmodel.value = model.ID;
            wmodel.text = model.content;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        MHDatePicker *date = [[MHDatePicker alloc]init];
        date.delegate = self;
        date.isBeforeTime = YES;
        date.datePickerMode = UIDatePickerModeDate;
        date.maxSelectDate = [NSDate date];
        date.Displaystr = @"yyyy-MM-dd";
    }
    
}
#pragma mark - 时间回传值
- (void)timeString:(NSString *)timeString
{
    NSMutableArray *marr = self.dataArray[0];
    TextFiledModel *wmodel = marr[3];
    LFLog(@"%@",timeString);
    wmodel.value = timeString;
    wmodel.text = timeString;
    [self.tableView reloadData];
}
#pragma mark - 数据提交
- (void)SubmitData:(NSMutableDictionary *)dt{
    [self presentLoadingTips];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PreschoolSubmitUrl) params:dt body:self.signImage success:^(id response) {
        [self dismissTips];
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            //            [AlertView showMsg:@"预约成功！"];

        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}

@end
