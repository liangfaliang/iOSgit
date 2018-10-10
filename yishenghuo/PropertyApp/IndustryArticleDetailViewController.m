//
//  IndustryArticleDetailViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/28.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "IndustryArticleDetailViewController.h"
#import "UserUIview.h"
#import "CustomButton.h"
#import "NSString+selfSize.h"
#import "ReviewTableViewCell.h"
#import "ReviewModel.h"
#import "D0BBBSmodel.h"
#import "STPhotoBroswer.h"
#import "HPGrowingTextView.h"
//#import "UserInfoViewController.h"
#import "ReviewDetialiewController.h"
#import "LFLUibutton.h"
#import "BBSReportViewController.h"
@interface IndustryArticleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HPGrowingTextViewDelegate,UIActionSheetDelegate>
{
    int count;
}
@property (nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UIView *footerView;


//@property(nonatomic,strong)UITextView *txtView;


@property(nonatomic,strong)UserUIview *userView;

@property (strong,nonatomic)UIButton *titleBtn;

@property (strong,nonatomic)UIButton *replyBtn;

@property (strong,nonatomic)UIButton *supportBtn;
@property (strong,nonatomic)UIButton *supportNumBtn;
@property (strong,nonatomic)UIButton *opposeNumBtn;

@property (strong,nonatomic)UILabel *contentLab;
@property(nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)HPGrowingTextView *tfview;
@property (nonatomic,strong)UIButton *sendBtn;
//添加屏幕的蒙罩
@property(nonatomic,strong)UIView *layView;

@property(nonatomic,strong)NSMutableArray *detailArr;

@property(nonatomic,strong)NSMutableArray *reviewArr;
@property(nonatomic,assign)BOOL isdetail;

@property(nonatomic,assign)NSString * praiseId;

@property(nonatomic,assign)NSString * modelid;//通知
@property(nonatomic,assign)NSInteger cellH;

@property(nonatomic,assign)NSInteger inde;
@property(nonatomic,assign)BOOL isreload;

@property(nonatomic,assign)NSInteger page;



@end

@implementation IndustryArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    count = 2;
    self.isdetail = YES;
    self.isreload = NO;
    self.page = 1;
    self.inde = -1;
    self.navigationBarTitle = @"主题详情";
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self creatTableview];
    [self setupRefresh];
    [self creatBottomview];
    [self requestDetialData];
    [self requestreviewData:@"1"];
    //    [self requestreviewreloadData:@"145"];
    self.cellH = 0;
    
    //举报按钮
    UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jubaodiandian"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick:)];
    rightbar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightbar;

}

-(void)rightBarClick:(UIBarButtonItem *)barbtn{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)return;
//    BBSReportViewController *report = [[BBSReportViewController alloc]init];
//    report.model = self.model;
//    [self.navigationController pushViewController:report animated:YES];
    
    
}

-(NSMutableArray *)reviewArr{
    
    if (_reviewArr == nil) {
        _reviewArr = [[NSMutableArray alloc]init];
    }
    
    return _reviewArr;
}

-(NSMutableArray *)detailArr{
    
    if (_detailArr == nil) {
        _detailArr = [[NSMutableArray alloc]init];
    }
    
    return _detailArr;
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
        __weak typeof(self) weakSelf = self;
        [_userView setPraiseblock:^(NSString *str) {//点赞
            if ( NO == [UserModel online] )
            {
                [weakSelf showLogin:^(id response) {

                }];
                
            }
            [weakSelf supportClick];
            
        }];
        [_userView setReviewBlock:^(NSString *str) {//评论
            if ( NO == [UserModel online] )
            {
                [weakSelf showLogin:^(id response) {
                    
                }];
                
            }
            weakSelf.isdetail = YES;
            [weakSelf tfviewisFirst];
        }];
        [_userView setImageBlock:^(CustomButton *btn) {
            
            //判断网络状态
            if (![userDefaults objectForKey:NetworkReachability]) {
                [weakSelf presentLoadingTips:@"网络貌似掉了~~"];
                return;
            }
            
            NSMutableArray *muarr = [[NSMutableArray alloc]init];
            for (NSDictionary *imurl in weakSelf.model.images) {
                [muarr addObject:imurl];
            }
            
            if (muarr.count > 0) {
                STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:muarr currentIndex:btn.tag2];
                [broser show];
            }
            
            
        }];
    }
    if (self.model) {
        self.userView.IndustryModel = self.model;
        if (self.model.images.count > 0) {
            
            self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width,  h.height + 180 +self.userView.titleHieght.constant + (SCREEN.size.width-40)/2.0);
            self.userView.frame = CGRectMake(0, 0, SCREEN.size.width, h.height + 90 + self.userView.titleHieght.constant+ (SCREEN.size.width-40)/2.0);
        }else{
            self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width,  h.height + 170 +self.userView.titleHieght.constant);
            self.userView.frame = CGRectMake(0, 0, SCREEN.size.width, h.height + 80 +self.userView.titleHieght.constant );
            
        }
    }
    
    
    
    
    //    _userView.backgroundColor = [UIColor redColor];
    //    _headerView.backgroundColor = [UIColor blueColor];
    
    
    //顶
    
    UIButton *supportBtn = [self.view viewWithTag:333];
    if (supportBtn ==nil) {
        supportBtn = [CustomButton btnBgImg:[UIImage imageNamed:@"ding"] title:nil titleColor:nil font:[UIFont systemFontOfSize:10.0] backGroundColor:nil cornerRadius:0.0 textAlignment:NSTextAlignmentCenter];
        supportBtn.tag = 333;
    }
    
    supportBtn.frame = CGRectMake(SCREEN.size.width/2.0-50,  _userView.frame.size.height + 20, 40, 40);
    [supportBtn addTarget:self action:@selector(supportClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (_supportNumBtn == nil) {
        _supportNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _supportNumBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        _supportNumBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_supportNumBtn addTarget:self action:@selector(supportClick) forControlEvents:UIControlEventTouchUpInside];
        [supportBtn addSubview:_supportNumBtn];
        _supportNumBtn.frame = CGRectMake(0,0,40, 20);
    }
    
    [_supportNumBtn setTitle:self.model.like_count forState:UIControlStateNormal];
    
    
    [self.headerView addSubview:supportBtn];
    
    
    //踩
    UIButton *oppose = [self.view viewWithTag:334];
    if (oppose == nil) {
        oppose = [CustomButton btnBgImg:[UIImage imageNamed:@"cai"] title:nil titleColor:nil font:[UIFont systemFontOfSize:10.0] backGroundColor:nil cornerRadius:0.0 textAlignment:NSTextAlignmentCenter];
        oppose.tag = 334;
    }
    
    oppose.frame = CGRectMake(SCREEN.size.width/2.0+10,_userView.frame.size.height + 20, 40, 40);
    [oppose addTarget:self action:@selector(opposeClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (_opposeNumBtn == nil) {
        _opposeNumBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _opposeNumBtn.frame = CGRectMake(0, 0, 40, 20);
        
        _opposeNumBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        _opposeNumBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_opposeNumBtn addTarget:self action:@selector(opposeClick) forControlEvents:UIControlEventTouchUpInside];
        [oppose addSubview:_opposeNumBtn];
    }
    [_opposeNumBtn setTitle:self.model.notlike_count forState:UIControlStateNormal];
    
    
    [self.headerView addSubview:oppose];
    
    if (self.footerView == nil) {
        self.footerView= [[UIView alloc]init];
        self.footerView.frame = CGRectMake(0, 0, SCREEN.size.width, 50);
        
        LFLUibutton *footerBtn = [[LFLUibutton alloc]init];
        footerBtn.Ratio = 0.7;
        [footerBtn setTitle:@"查看更多" forState:UIControlStateNormal];
//        [footerBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
        [footerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        footerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        footerBtn.frame = CGRectMake(SCREEN.size.width/2.0-40, 20, 80, 20);
        [footerBtn addTarget:self action:@selector(footerClick) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:footerBtn];
        
        
    }
    
}

- (void)creatBottomview
{
    self.bottomView = [[UIView alloc]init];
    self.bottomView.frame = CGRectMake(0, SCREEN.size.height-40, SCREEN.size.width, 40);
    [self.bottomView setBackgroundImage:[UIImage imageNamed:@"base"]];
    //self.bottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.bottomView];
    
    
    self.tfview = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(20, 5, SCREEN.size.width-80, 30)];
    self.tfview.layer.borderColor = [[UIColor colorWithRed:235/256.0 green:236/256.0 blue:237/256.0 alpha:1.0]CGColor];
    self.tfview.layer.borderWidth = 1;
    self.tfview.layer.cornerRadius = 5;
    self.tfview.font = [UIFont systemFontOfSize:14];
    self.tfview.placeholder = @"评论楼主";
    self.tfview.textColor = [UIColor grayColor];
    self.tfview.delegate = self;
    [self.bottomView addSubview:self.tfview];
    
    self.sendBtn = [CustomButton btnBgImg:nil title:@"发送" titleColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0] backGroundColor:[UIColor clearColor] cornerRadius:1.0 textAlignment:NSTextAlignmentCenter];
    self.sendBtn.frame = CGRectMake(SCREEN.size.width-50, 5, 40, 30);
    [self.sendBtn addTarget:self action:@selector(sendClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.sendBtn];
    
    //    //蒙版
    //    self.layView = [[UIView alloc]init];
    //    self.layView.frame = CGRectMake(0, self.bottomView.frame.origin.y, SCREEN.size.width, self.bottomView.frame.origin.y);
    //    self.layView.backgroundColor = [UIColor blackColor];
    //    self.layView.alpha = 0.3;
    //蒙版
    self.layView = [[UIView alloc]init];
    self.layView.frame = CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height-64);
    self.layView.backgroundColor = [UIColor blackColor];
    self.layView.alpha = 0.0;
    
}




- (void)creatTableview
{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height-44) style:UITableViewStylePlain];
    self.tableview.delegate  = self;
    self.tableview.dataSource = self;
    self.tableview.tableHeaderView = self.headerView;
    self.tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置分割线的边距
    [self.tableview registerNib:[UINib nibWithNibName:@"ReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReviewCell"];
    [self.view addSubview:self.tableview];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reviewArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"ReviewCell"];
    ReviewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.index = indexPath.row;
    cell.praiseimage.hidden = YES;
    cell.reviewIamge.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.reviewArr[indexPath.row];
    cell.nameLAbel.text = cell.model.nickname;
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:cell.model.headimage] placeholderImage:[UIImage imageNamed:@""]];
    __weak typeof(cell) weakcell = cell;
    [cell setPraiseblock:^(NSInteger str) {//点赞
        if ( NO == [UserModel online] )
        {
            [self showLogin:^(id response) {
                
            }];
            
        }
        self.modelid = weakcell.model.id;
        ReviewModel *mo = self.reviewArr[str];
        
        [self requestPinglunpraiseData:mo.id];
    }];
    [cell setReviewBlock:^(NSInteger str) {//评论
        if ( NO == [UserModel online] )
        {
            [self showLogin:^(id response) {
                
            }];
            
        }
        self.modelid = weakcell.model.id;
        ReviewModel *mo = self.reviewArr[str];
        self.isdetail = NO;
        self.praiseId = mo.id;
        [self tfviewisFirst];
    }];
    
    
    [cell setMorebtnBlock:^(NSInteger str) {//更多评论
        
        ReviewDetialiewController *reviewde = [[ReviewDetialiewController alloc]init];
        reviewde.model = weakcell.model;
        reviewde.modelid = _model.id;
        [self.navigationController pushViewController:reviewde animated:YES];
        LFLog(@"点击查看更多");
        
    }];
    
    return cell;
}

//发送通知
-(void)postNotificationName:(NSDictionary *)dt{
    [Notification postNotificationName:self.modelid object:nil userInfo:dt];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    LFLog(@"%ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ReviewModel *model = self.reviewArr[indexPath.row];
    CGFloat H = 0;
    CGSize content = [model.content selfadap:13 weith:20];
    CGFloat h = 5;
    if (model.comment.count > 0 ) {
        
        
        for (int i = 0; i < (model.comment.count < 3? model.comment.count : 2); i ++) {
            NSDictionary *dt = model.comment[i];
            
            NSString *str = [NSString stringWithFormat:@"%@：%@",dt[@"username1"],dt[@"content"]];
            CGSize size = [str selfadaption:13];
            h += size.height + 5;
            
        }
        
        if (model.comment.count > 2) {
            H = content.height + 100 + h;
        }else{
            H = content.height + 70 + h;
        }
        
        
    }else{
        H = content.height + 70;
        
    }
    
    
    
    return H ;
}
- (void)UesrClicked
{
    
    
    //    UserInfoViewController*userInfo = [[UserInfoViewController alloc]init];
    //    [self.navigationController pushViewController:userInfo animated:YES];
}

- (void)replyClick:(UIButton *)sender
{
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {
            
        }];
        return;
    }
    LFLog(@"回复");
    
    [self.tfview becomeFirstResponder];
}
- (void)replyClick
{
    LFLog(@"huifu");
}

- (void)titleclClick:(UIButton *)btn
{
    //    UserInfoViewController*userInfo = [[UserInfoViewController alloc]init];
    //    [self.navigationController pushViewController:userInfo animated:YES];
}
//顶
- (void)supportClick
{
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {
            
        }];
        return;
    }
    LFLog(@"顶顶顶顶顶");
    [self requestpraiseData:self.model.article_id collect:@"0" isdetail:YES];
}
//踩
- (void)opposeClick
{
    if ( NO == [UserModel online] )
    {
        
        [self showLogin:^(id response) {
            
        }];
        return;
    }
    LFLog(@"踩踩踩踩踩");
    [self requestpraiseData:self.model.article_id collect:@"1" isdetail:YES];
}


- (void)supportClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    LFLog(@"huifu");
}
- (void)sendClick1
{
    if ([self.tfview.text isEqualToString:@""] == YES)
    {
        [self presentLoadingTips:@"请输入评论内容~~~"];
        return;
    }
    LFLog(@"%@",self.tfview.text);
    if (self.isdetail) {
        [self requestreviewcontentData:_model.article_id username2:_model.username parentid:nil content:self.tfview.text];
    }else{
        [self requestreviewcontentData:_model.article_id username2:_model.username parentid:self.praiseId content:self.tfview.text];
        
    }
    self.isdetail = YES;
    self.tfview.text = nil;
    [self.tfview resignFirstResponder];
}

- (void)footerClick
{
    self.page ++;
    [self requestreviewData:[NSString stringWithFormat:@"%d",(int)self.page]];
    LFLog(@"查看更多");
}
//-(void)keyboardhide:(UITapGestureRecognizer*)tap
//{
//    [self.tfview resignFirstResponder];
//
//
//}
-(void)kbWillShow:(NSNotification *)noti
{
    
    NSDictionary *dict = [noti userInfo];
    CGRect keyboardRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomView.frame = CGRectMake(0, keyboardRect.origin.y-150, SCREEN.size.width, 150);
    self.tfview.frame = CGRectMake(20, 5, SCREEN.size.width-80, 80);
    self.tfview.text = nil;
    self.layView.frame = CGRectMake(0, self.bottomView.frame.origin.y, SCREEN.size.width, -self.bottomView.frame.origin.y);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLayView)];
    [self.layView addGestureRecognizer:tap];
    
    [self.view insertSubview:self.layView belowSubview:self.tfview];
    
    self.layView.alpha = 0.1;
    
    
}
- (void)tapLayView{
    [ self.tfview resignFirstResponder];
    
}

- (void)tfviewisFirst{
    [ self.tfview becomeFirstResponder];
    
}
-(void)kbWillHide:(NSNotification *)noti
{
    
//    self.tfview.text = nil;
    [self.layView removeFromSuperview];
    self.bottomView.frame = CGRectMake(0, SCREEN.size.height-40, SCREEN.size.width, 40);
    self.tfview.frame = CGRectMake(20, 5, SCREEN.size.width-80, 30);
    
    
}

-(void)HideTexeview{



}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
    [self.bottomView endEditing:YES];
}



#pragma mark 用户评论请求数据
- (void)requestreviewcontentData:(NSString *)articleid username2:(NSString *)username2 parentid:(NSString *)parentid content:(NSString *)content{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:articleid,@"article_id",content,@"content", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (parentid) {
        [dt setObject:parentid forKey:@"parent_id"];
    }
    LFLog(@"评论dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,IndustryAddReviewUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"评论response：%@",response);
        if ([str isEqualToString:@"1"]) {
            
            if (parentid) {
            self.page = 1;
            [self requestreviewData:@"1"];
            }else{
            [self requestreviewData:@"1"];
            }
            
//            [self postNotificationName:@{@"dianzan":@"praise123456789"}];
            [self requestreviewreloadData:self.modelid];
            [self requestDetialData];
            [self presentLoadingTips:@"评论成功~~"];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark 点赞请求数据
- (void)requestpraiseData:(NSString *)articleid collect:(NSString *)collect isdetail:(BOOL)isdetail{
    LFLog(@"articleid:%@",articleid);
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:articleid,@"article_id",collect,@"type", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"点赞dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,IndustryPraiseTreadUrl) params:dt success:^(id response) {
        LFLog(@"点赞:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            
            [self requestDetialData];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 评论点赞请求数据
- (void)requestPinglunpraiseData:(NSString *)commentid{
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid,@"commentid":commentid};
    [LFLHttpTool post:NSStringWithFormat(ZJBBsBaseUrl,@"11") params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            
            //            [self requestreviewData:@"0"];
            [self postNotificationName:@{@"dianzan":@"praise"}];
            [self presentLoadingTips:@"发送成功~~"];
        }else{
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 评论列表数据
- (void)requestreviewData:(NSString *)page{
    if (self.model.id) {
        self.detailID = self.model.id;
        
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailID,@"article_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"评论列表dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,IndustryArticleCommentListUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        LFLog(@"评论列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            if (self.page == 1) {
                [self.reviewArr removeAllObjects];
            }
            
            NSArray *arr = response[@"data"];
            if (arr.count > 0) {
                for (NSDictionary *dt in response[@"data"]) {
                    
                    ReviewModel *model = [[ReviewModel alloc]initWithDictionary:dt error:nil];
                    [self.reviewArr addObject:model];
                }
                if (self.reviewArr.count > 0) {
                    self.tableview.tableFooterView = self.footerView;
                    [self.tableview reloadData];
                }
            }else{
                
                if (self.reviewArr.count > 0) {
                    [self presentLoadingTips:@"没有更多数据了~~"];
                }
                
            }
            
            
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
    
}


#pragma mark 评论刷新数据
- (void)requestreviewreloadData:(NSString *)reviewid{
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    if (reviewid == nil) {
        reviewid = @"";
    }
    LFLog(@"reviewid:%@",reviewid);
    NSDictionary *dt = @{@"id":reviewid};
    [LFLHttpTool get:NSStringWithFormat(ZJBBsBaseUrl,@"17") params:dt success:^(id response) {
        //        [UITableView.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            ReviewModel *mo = [[ReviewModel alloc]init];
            
            mo.comment = response[@"note"];
            LFLog(@"评论刷新：%@",mo.comment);
            for (ReviewModel *model in self.reviewArr) {
                
                if ([model.id isEqualToString:response[@"note"][0][@"parent_id"] ]) {
                    model.comment = mo.comment;
                }
            }
            
            self.modelid = nil;
            [self.tableview reloadData];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 帖子详情请求数据
- (void)requestDetialData{
    if (self.model.id) {
        self.detailID = self.model.id;
        
    }

    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.detailID,@"article_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"帖子详情:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,IndustryArticleInfoUrl) params:dt success:^(id response) {
        LFLog(@"帖子详情:%@",response);
        [self.tableview.mj_header endRefreshing];
        [self.detailArr removeAllObjects];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
                
        self.model = [[IndustryModel alloc]initWithDictionary:response[@"data"] error:nil];
        
        [self createUI];
        self.tableview.tableHeaderView = self.headerView;
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self requestDetialData];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDetialData];
        self.page = 1;
        [self requestreviewData:@"1"];
    }];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Notification removeObserver:self];
    //添加键盘通知
    [Notification addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [Notification addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [Notification addObserver:self selector:@selector(reload:)
                         name:@"reload" object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [Notification removeObserver:self];
    
    
}

-(void)reload:(NSNotification *)notify{
    
    self.cellH = [[notify.userInfo objectForKey:@"cell"] integerValue];
    
    self.isreload = YES;
    self.inde = [[notify.userInfo objectForKey:@"index"] integerValue];
    LFLog(@"%ld",(long)self.inde);
    [self.tableview reloadData];
    
}


@end
