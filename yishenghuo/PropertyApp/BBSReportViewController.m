//
//  BBSReportViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/18.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "BBSReportViewController.h"
#import "UserUIview.h"
#import "LFLUibutton.h"
@interface BBSReportViewController ()
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UIView *footerView;

@property(nonatomic,strong)UserUIview *userView;
@property(nonatomic,strong)LFLUibutton * selectBtn;
@property(nonatomic,strong)NSMutableArray *dataarr;
@end

@implementation BBSReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"投诉";
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height - 60)];
    [self.view addSubview:self.scrollview];
    [self createUI];
    [self requestDetialData];
}

-(NSMutableArray *)dataarr{
    
    if (_dataarr == nil) {
        _dataarr = [[NSMutableArray alloc]init];
    }
    return _dataarr;
}
-(void)createUI{
    
    if (self.headerView == nil) {
        self.headerView= [[UIView alloc]init];
    }
    
    
    CGSize h = [self.model.content selfadaption:12];
    
    
    if (self.userView == nil) {
        self.userView = [[NSBundle mainBundle]loadNibNamed:@"UserUIview" owner:nil options:nil][0];
        //    self.userView = [[UserUIview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 100)];
        self.userView.layer.cornerRadius = 5;
        [self.headerView addSubview:self.userView];
    }
    if (self.model) {
        self.userView.model = self.model;
        
        
        if (self.model.imgurl.count > 0) {
            
            self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width,  h.height + 90 +self.userView.titleHieght.constant + (SCREEN.size.width-40)/2.0);
            self.userView.frame = CGRectMake(0, 0, SCREEN.size.width, h.height + 90 + self.userView.titleHieght.constant+ (SCREEN.size.width-40)/2.0);
        }else{
            self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width,  h.height + 80 +self.userView.titleHieght.constant);
            self.userView.frame = CGRectMake(0, 0, SCREEN.size.width, h.height + 80 +self.userView.titleHieght.constant );
            
        }
    }
    self.userView.praiseimage.hidden = YES;
    self.userView.praiseLabel.hidden = YES;
    self.userView.reviewImage.hidden = YES;
    self.userView.reviewLabel.hidden = YES;
    [self.scrollview addSubview:self.headerView];
    
    
    
}
-(void)createReport{
    for (int i = 0; i < self.dataarr.count; i ++) {
        LFLUibutton *button = [[LFLUibutton alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/self.dataarr.count, self.headerView.height + 30, SCREEN.size.width/4, 50)];
        button.Ratio = 0.7;
        [button.imageView setContentMode:UIViewContentModeLeft];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button setTitle:self.dataarr[i][@"complain_name"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
        [button setTitleColor:JHAssistColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(reportlistClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 30 + i;
        if (i == 0) {
            
            self.selectBtn = button;
        }
        
        [button setImage:[UIImage imageNamed:@"gongdanxiangqingweixuanzhong"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gongdanxiangqingxuanzhong"] forState:UIControlStateSelected];
        
        [self.scrollview addSubview:button];
        
    }
    self.scrollview.contentSize = CGSizeMake(0, self.headerView.height + 120);
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(10,SCREEN.size.height - 60, SCREEN.size.width-20, 40);
    [submitBtn.layer setMasksToBounds:YES];
    [submitBtn.layer setCornerRadius:5.0];
    [submitBtn setBackgroundColor:JHColor(4, 146, 245)];
    [submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(reportsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}
-(void)reportlistClick:(LFLUibutton *)btn{
    
    if (self.selectBtn.tag == btn.tag) {
        self.selectBtn.selected = YES;
        
    }else{
        self.selectBtn.selected = NO;
        
        btn.selected = YES;
        self.selectBtn = btn;
        
    }
    
    
    
}
-(void)reportsubmitClick:(UIButton *)btn{
    if (self.selectBtn.selected == NO) {
        [self presentLoadingTips:@"请选择投诉类型"];
        return;
    }
    [self requestDetialSumb];
    
    
}
#pragma mark 投诉类型
- (void)requestDetialData{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJBBsBaseUrl,@"20") params:nil success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        LFLog(@"投诉类型：%@",response);
        if ([str isEqualToString:@"0"]) {
            [self.dataarr removeAllObjects];
            
            for (NSDictionary *dt in response[@"note"]) {
                [self.dataarr addObject:dt];
            }
            [self createReport];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark 投诉提交
- (void)requestDetialSumb{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid,@"articleid":self.model.id,@"typeid":self.dataarr[self.selectBtn.tag - 30][@"complain_id"],@"content":@"投诉"};
    LFLog(@"dt::%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJBBsBaseUrl,@"19") params:dt success:^(id response) {
        LFLog(@"投诉提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            [self presentLoadingTips:@"提交成功，我们稍后做出处理"];
            [self performSelector:@selector(goBlack) withObject:nil afterDelay:2.0];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)goBlack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
