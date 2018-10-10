//
//  DetailsViewController.m
//  shop
//
//  Created by 梁法亮 on 16/5/11.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "DetailsViewController.h"
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
#import "GovernmentView.h"
#import "GovernmentCommentTableViewCell.h"
@interface DetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HPGrowingTextViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)baseTableview *tableview;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UIView *footerView;


@property(nonatomic,strong)baseTableview *alertTableView;
@property(nonatomic,strong)UIView *alertview;

@property(nonatomic,strong)GovernmentView *userView;

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
@property(nonatomic,strong)UIButton *layView;

@property(nonatomic,strong)NSMutableArray *detailArr;
@property(nonatomic,strong)NSMutableArray *ReportArr;//举报
@property(nonatomic,assign)BOOL isReport;//是否举报
@property(nonatomic,strong)NSMutableArray *reviewArr;
@property(nonatomic,assign)BOOL isdetail;

@property(nonatomic,assign)NSString * praiseId;

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,strong)NSArray *nameArray;
@property(nonatomic,strong)NSArray *iconArr;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isdetail = YES;
    self.isReport = NO;
    self.page = 1;
    self.more = @"1";
    self.navigationBarTitle = @"详情";
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTableview];
    [self creatBottomview];
    [self createAlertview];
    [self requestDetialData];
    [self requestReportType];//举报
    [self requestreviewData:self.page];

    //举报按钮
    self.navigationBarRightItem = [UIImage imageNamed:@"jubaodiandian"];
    __weak typeof(self) weakSelf = self;
    [self setRightBarBlock:^(UIBarButtonItem *sender) {
        if (weakSelf.model) {
            [weakSelf createAlertview];
            [weakSelf.alertTableView reloadData];
            weakSelf.alertview.hidden = !weakSelf.alertview.hidden;
        }
    }];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)return;
    NSString *myuid = [UserDefault objectForKey:@"useruid"];
    if ([myuid isEqualToString:self.model.uid]) {
        //        uid = @"删除";
        //        [self DeleteThePost:self.model.id];
    }else{
        //        BBSReportViewController *report = [[BBSReportViewController alloc]init];
        //        report.model = self.model;
        //        [self.navigationController pushViewController:report animated:YES];
    }
    
    
    
}

-(NSMutableArray *)ReportArr{
    
    if (_ReportArr == nil) {
        _ReportArr = [[NSMutableArray alloc]init];
    }
    
    return _ReportArr;
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
    
    NSString *myuid = [UserDefault objectForKey:@"useruid"];
    LFLog(@"myuid:%@ ==== %@",myuid,self.model.user_id);
    if (([myuid isEqualToString:self.model.user_id])) {
        self.nameArray = @[@"分享",@"删帖"];
        self.iconArr = @[@"buttun_tiezixiangqing",@"shantie"];
    }else{
        self.nameArray = @[@"分享",@"举报"];
        self.iconArr = @[@"buttun_tiezixiangqing",@"jubaofatie"];
    }
    if (self.userView == nil) {
        self.userView = [[NSBundle mainBundle]loadNibNamed:@"GovernmentView" owner:nil options:nil][0];
    }
    
    
    if (self.model) {
        self.userView.GovernmentModel = self.model;
        
        CGFloat viewHH = [self.model.content selfadap:14 weith:20].height + 10 ;
        viewHH += 90;
        if (self.model.imgurl.count) {
            CGFloat imgWidth = (SCREEN.size.width - 40)/3 + 10;
            if (self.model.imgurl.count == 1) {
                imgWidth = (SCREEN.size.width - 40)/3 * 2;
            }else if (self.model.imgurl.count == 4){
                imgWidth += imgWidth;
            }else{
                imgWidth = imgWidth * (((self.model.imgurl.count - 1)/3 +1) < 4? (self.model.imgurl.count - 1)/3 +1:3);
            }
            viewHH += imgWidth;
            
        }
        
        self.userView.frame = CGRectMake(0, 0, SCREEN.size.width, viewHH );
        self.tableview.tableHeaderView = self.userView;
        [self.tableview reloadData];
    }
    __weak typeof(self) weakSelf = self;
    [self.userView setImblock:^(NSInteger index) {//图片点击
        NSArray *arr = weakSelf.model.imgurl;
        if (arr.count > 0) {
            STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:arr currentIndex:index];
            [broser show];
        }
    }];
    
    [self.userView setLikeblock:^(NSInteger index) {//点赞
        [weakSelf requestpraiseData:weakSelf.model.id parentid:nil isdetail:YES index:0];
    }];
}

-(void)createAlertview{
    if (self.alertview == nil) {
        self.alertview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
        self.alertview.backgroundColor = [UIColor clearColor];
        self.alertview.hidden = YES;
        
//        [win addSubview:self.alertview];
        LFLog(@"self.nameArray.count:%lu",(unsigned long)self.nameArray.count);
        UIView *alertLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - self.nameArray.count * 50)];
        alertLayer.backgroundColor = JHColoralpha(0, 0, 0, 0.1);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Alertview)];
        tap.delegate = self;
        [alertLayer addGestureRecognizer:tap];
        [self.alertview addSubview:alertLayer];
        self.alertTableView = [[baseTableview alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - self.nameArray.count * 50- (kDevice_Is_iPhoneX ? 34 :0), SCREEN.size.width, self.nameArray.count * 50) style:UITableViewStylePlain];
        self.alertTableView.delegate  = self;
        self.alertTableView.dataSource = self;
        
        self.alertTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置分割线的边距
        [self.alertTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"alertcell"];
        [self.alertview addSubview:self.alertTableView];
    }
    self.alertTableView.frame = CGRectMake(0, SCREEN.size.height - self.nameArray.count * 50- (kDevice_Is_iPhoneX ? 34 :0), SCREEN.size.width, self.nameArray.count * 50);
    [self.view addSubview:self.alertview];
    
}
-(void)Alertview{
    self.alertview.hidden = YES;
    self.isReport = NO;
    CGFloat cout = self.nameArray.count;
    CGFloat HH = cout *50 < SCREEN.size.height ?cout *50 :SCREEN.size.height;
    self.alertTableView.frame = CGRectMake(0, SCREEN.size.height - HH, SCREEN.size.width, HH);
    [self.alertTableView reloadData];
    
}

- (void)creatBottomview
{
    //蒙版
    if (self.layView == nil) {
        self.layView = [[UIButton alloc]init];
        self.layView.frame = CGRectMake(0, SCREEN.size.height-(kDevice_Is_iPhoneX ? 74 :40), SCREEN.size.width, 40);
        self.layView.backgroundColor = JHColoralpha(0, 0, 0, 0.1);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLayView)];
        tap.delegate = self;
        [self.layView addGestureRecognizer:tap];
//        [win addSubview:self.layView];
        
        self.bottomView = [[UIView alloc]init];
        self.bottomView.frame = CGRectMake(0, 0, SCREEN.size.width, 40);
        [self.bottomView setBackgroundImage:[UIImage imageNamed:@"base"]];
        //self.bottomView.backgroundColor = [UIColor redColor];
        [self.layView addSubview:self.bottomView];
        
        
        self.tfview = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(20, 5, SCREEN.size.width-80, 30)];
        self.tfview.layer.borderColor = [[UIColor colorWithRed:235/256.0 green:236/256.0 blue:237/256.0 alpha:1.0]CGColor];
        self.tfview.layer.borderWidth = 1;
        self.tfview.layer.borderColor = [JHbgColor CGColor];
        self.tfview.layer.cornerRadius = 5;
        self.tfview.font = [UIFont systemFontOfSize:14];
        self.tfview.layer.masksToBounds = YES;
        self.tfview.placeholder = @"回复 楼主";
        self.tfview.textColor = [UIColor grayColor];
        self.tfview.delegate = self;
        [self.bottomView addSubview:self.tfview];
        
        self.sendBtn = [CustomButton btnBgImg:nil title:@"发送" titleColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0] backGroundColor:[UIColor clearColor] cornerRadius:1.0 textAlignment:NSTextAlignmentCenter];
        self.sendBtn.frame = CGRectMake(SCREEN.size.width-50, 5, 40, 30);
        [self.sendBtn addTarget:self action:@selector(sendClick1:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.sendBtn];

    }
    [self.view addSubview:self.layView];
    //    //蒙版
    //    self.layView = [[UIView alloc]init];
    //    self.layView.frame = CGRectMake(0, self.bottomView.frame.origin.y, SCREEN.size.width, self.bottomView.frame.origin.y);
    //    self.layView.backgroundColor = [UIColor blackColor];
    //    self.layView.alpha = 0.3;
    
    
}




- (void)creatTableview
{
    
    if (self.tableview == nil) {
        self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height-44) style:UITableViewStylePlain];
        self.tableview.delegate  = self;
        self.tableview.dataSource = self;
        self.tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置分割线的边距
        [self.tableview registerNib:[UINib nibWithNibName:@"GovernmentCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"GovernmentCommentTableViewCell"];
        
        [self.view addSubview:self.tableview];
        [self setupRefresh];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        return self.reviewArr.count;
    }
    if (self.isReport) {
        return self.ReportArr.count;
    }
    return self.nameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableview) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"GovernmentCommentTableViewCell"];
        GovernmentCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.reviewArr[indexPath.row];
        __weak typeof(cell) weakcell = cell;
        [cell setLikeblock:^(NSInteger index) {//点赞
            [self requestpraiseData:self.model.id parentid:weakcell.model.comment_id isdetail:NO index:indexPath.row];
        }];
        
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alertcell"];
        if (self.isReport) {
            cell.textLabel.text = self.ReportArr[indexPath.row][@"name"];
            cell.imageView.image = nil;
        }else{
            cell.textLabel.text = self.nameArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:self.iconArr[indexPath.row]];
        }
        cell.textLabel.textColor = JHdeepColor;
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableview) {
        if (!self.tfview.isFirstResponder) {
            GoReviewModel *model = self.reviewArr[indexPath.row];
            self.praiseId = model.comment_id;
            self.isdetail = NO;
            self.tfview.placeholder = model.user_name;
            [self.tfview becomeFirstResponder];
        }
    }else{
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        CGFloat cout= 0;
        self.alertview.hidden = YES;
        if (!self.isReport) {
            
            if ([cell.textLabel.text isEqualToString:@"分享"]) {
                [[ShareSingledelegate sharedShareSingledelegate] ShareContent:self.view content:self.model.share[@"content"] title:self.model.share[@"title"] url:self.model.share[@"url"] image:self.model.share[@"imgurl"]];
                cout = self.nameArray.count;
            }else if ([cell.textLabel.text isEqualToString:@"举报"]) {
                self.isReport = YES;
                cout = self.ReportArr.count +1;
                self.alertview.hidden = NO;
            }else if ([cell.textLabel.text isEqualToString:@"删帖"]) {
                cout = self.nameArray.count;
                [self DeleteThePost];
            }
            
        }else{
            cout = self.nameArray.count;
            self.isReport = NO;
            [self requestReport:self.ReportArr[indexPath.row][@"id"]];
        }
        CGFloat HH = cout *50 < SCREEN.size.height ?cout *50 :SCREEN.size.height;
        self.alertTableView.frame = CGRectMake(0, SCREEN.size.height - HH, SCREEN.size.width, HH);
        [self.alertTableView reloadData];
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableview) {
        GoReviewModel *model = self.reviewArr[indexPath.row];
        CGFloat H = 0;
        CGSize content = [model.comment_content selfadap:14 weith:70];
        
        H = content.height + 5 + 80;
        if (model.parent_info.count > 0 ) {
            CGSize replysize = [model.parent_info[@"comment_content"] selfadap:14 weith:70];
            H += replysize.height + 50 + 10;
        }
        return H ;
    }else{
        return 50;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.alertTableView) {
        if (self.isReport) {
            UIButton *btn = [[UIButton alloc]init];
            [btn setTitle:@"请选择举报类型" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            //            [btn setImage:[UIImage imageNamed:@"remenhuatiwenzi"] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            return btn;
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.alertTableView) {
        if (self.isReport) {
            return 50;
        }
    }
    return 0.001;
}
#pragma mark  粘贴复制
// 允许长按菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 允许每一个Action
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    // 可以支持所有Action，也可以只支持其中一种或者两种Action
    //    if (action == @selector(pinglun:) || action == @selector(paste:)) { // 支持复制和黏贴
    //        return YES;
    //    }
    return YES;
}

// 对一个给定的行告诉代表执行复制或黏贴操作内容
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    //    if (action == @selector(copy:)) {
    //        NSLog(@"复制");
    //        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; // 黏贴板
    //        [pasteBoard setString:cell.textLabel.text];
    //    } else if (action == @selector(paste:)) {
    //        NSLog(@"黏贴");
    //        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    //        NSLog(@"%@",pasteBoard.string);
    //    } else if (action == @selector(cut:)) {
    //        NSLog(@"剪切");
    //    }
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



- (void)supportClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    LFLog(@"huifu");
}
- (void)sendClick1:(UIButton *)sender
{
    if ([self.tfview.text isEqualToString:@""] == YES)
    {
        [self presentLoadingTips:@"请输入评论内容~~~"];
        return;
    }
    LFLog(@"%@",self.tfview.text);
    if (self.isdetail) {
        [self requestreviewcontentData:_model.id  parentid:nil content:self.tfview.text];
    }else{
        [self requestreviewcontentData:_model.id  parentid:self.praiseId content:self.tfview.text];
        
    }
    self.isdetail = YES;
    self.tfview.text = nil;
    [self.tfview resignFirstResponder];
}

- (void)footerClick
{
    self.page ++;
    [self requestreviewData:self.page];
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
    self.layView.hidden = YES;
    self.layView.frame = CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height);
    self.bottomView.frame = CGRectMake(0, keyboardRect.origin.y-80, SCREEN.size.width, 80);
    self.tfview.frame = CGRectMake(20, 5, SCREEN.size.width-80, 80);
    self.tfview.text = nil;
    self.layView.hidden = NO;
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLayView)];
    //    tap.delegate = self;
    //    [self.layView addGestureRecognizer:tap];
    //    self.layView.hidden = NO;
    //    [self.view insertSubview:self.layView belowSubview:self.tfview];
    
    
}
- (void)tapLayView{
    [ self.tfview resignFirstResponder];
    
}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if (touch.view == self.layView) {
//        [self.view endEditing:YES];
//        return NO;
//    }
//    return YES;
//}

-(void)kbWillHide:(NSNotification *)noti
{
    
    self.tfview.placeholder = @"回复 楼主";
    self.tfview.text = nil;
    
    //    [self.layView removeFromSuperview];
    self.layView.frame = CGRectMake(0, SCREEN.size.height-(kDevice_Is_iPhoneX ? 74 :40), SCREEN.size.width, 40);
    self.bottomView.frame = CGRectMake(0, 0, SCREEN.size.width, 40);
    self.tfview.frame = CGRectMake(20, 5, SCREEN.size.width-80, 30);
    
    
}

#pragma mark HPGrowingTextViewDelegate

-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView{
}



#pragma mark 用户评论请求数据
- (void)requestreviewcontentData:(NSString *)articleid  parentid:(NSString *)parentid content:(NSString *)content{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",self.model.id,@"id", nil];
    if (parentid) {
        [dt setObject:parentid forKey:@"comment_id"];
    }
    [dt setObject:content forKey:@"comment_content"];
    LFLog(@"用户评论dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSReplyUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"用户评论:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"评论成功~~"];
            [self requestDetialData];
            self.page = 1;
            [self requestreviewData:self.page];
        }else{
            [self presentLoadingTips:response[@"err_msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark 点赞请求数据
- (void)requestpraiseData:(NSString *)articleid parentid:(NSString *)parentid isdetail:(BOOL)isdetail index:(NSInteger )index{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",articleid,@"id", nil];
    if (parentid) {
        [dt setObject:parentid forKey:@"comment_id"];
    }
    LFLog(@"点赞dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSLikeUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (isdetail) {
                if ([self.model.is_agree isEqualToString:@"0"]) {
                    [self presentLoadingTips:@"点赞成功~~"];
                    
                }else{
                    [self presentLoadingTips:@"取消点赞~~"];
                }
                [self requestDetialData];
            }else{
                GoReviewModel *model = self.reviewArr[index];
                NSInteger praise = [model.agree_count integerValue];
                if ([model.is_agree isEqualToString:@"0"]) {
                    [self presentLoadingTips:@"点赞成功~~"];
                    model.is_agree = @"1";
                    praise ++;
                }else{
                    [self presentLoadingTips:@"取消点赞~~"];
                    model.is_agree = @"0";
                    praise --;
                    
                }
                model.agree_count = [NSString stringWithFormat:@"%d",(int)praise];
                [self.reviewArr replaceObjectAtIndex:index withObject:model];
                [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
        }else{
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
    }];
    
    
}



#pragma mark 评论列表数据
- (void)requestreviewData:(NSInteger)pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    if (!self.detailID) {
        self.detailID = self.model.id;
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",self.detailID,@"id", nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"评论列表dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSReplyListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"评论列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            if (self.page == 1) {
                [self.reviewArr removeAllObjects];
            }
            
            NSArray *arr = response[@"data"];
            if (arr.count > 0) {
                for (NSDictionary *dt in response[@"data"]) {
                    
                    GoReviewModel *model = [[GoReviewModel alloc]initWithDictionary:dt error:nil];
                    [self.reviewArr addObject:model];
                }
                [self.tableview reloadData];
                
            }else{
                
                if (self.reviewArr.count > 0) {
                    [self presentLoadingTips:@"没有更多数据了~~"];
                }
                
            }
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self requestreviewData:self.page];
                    }
                    
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
    
}
#pragma mark 举报
- (void)requestReport:(NSString *)report_type{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    LFLog(@"session：%@",session);
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [dt setObject:report_type forKey:@"report_type"];
    [dt setObject:self.model.id forKey:@"id"];
    LFLog(@"举报dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSReportPostUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"举报：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"举报成功~~"];
            
        }else{
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 举报类型
- (void)requestReportType{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    LFLog(@"session：%@",session);
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    if (!self.detailID) {
        self.detailID = self.model.id;
    }
    [dt setObject:self.detailID forKey:@"id"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSReportPostTypeUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"举报：%@",response);
        [self.ReportArr removeAllObjects];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            for (NSDictionary *dic  in response[@"data"]) {
                [self.ReportArr addObject:dic];
            }
            
        }else{
            
            
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
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",self.detailID,@"id", nil];
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSPostDetailUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            GovernmentModel *mo = [[GovernmentModel alloc]initWithDictionary:response[@"data"] error:nil];
            if (mo) {
                self.model = mo;
                self.detailID = self.model.id;
                [self createUI];
            }
            LFLog(@"帖子详情:%@",response);
        }else{
            
            
        }
        
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark 帖子删除
- (void)DeleteThePost{
    
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    LFLog(@"session：%@",session);
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (!self.detailID) {
        self.detailID = self.model.id;
    }
    [dt setObject:self.detailID forKey:@"article_id"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSDeletePostUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"删除：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"删除成功~~"];
            if ([self.delegate respondsToSelector:@selector(BBSDeletePost:isDelete:)]) {
                [self.delegate BBSDeletePost:self.model isDelete:YES];
            }
            [self performSelector:@selector(goback) withObject:nil afterDelay:2.0f];
            
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
            
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}
-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDetialData];
        [self requestReportType];
        self.page = 1;
        self.more = @"1";
        [self requestreviewData:self.page];
    }];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多评论了"];
            [self.tableview.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestreviewData:self.page];
        }
        
    }];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(BBSDeletePost:isDelete:)]) {
        [self.delegate BBSDeletePost:self.model isDelete:NO];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self creatBottomview];
    [self createAlertview];
    [self requestDetialData];
//    self.isReport = NO;
    [Notification removeObserver:self];
    //添加键盘通知
    [Notification addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [Notification addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.alertTableView removeAllSubviews];
    [self.alertTableView removeFromSuperview];
    self.alertTableView = nil;
    [self.layView removeAllSubviews];
    [self.layView removeFromSuperview];
    self.layView = nil;
    [Notification removeObserver:self];
    
    
}
-(void)dealloc{
    [self.alertTableView removeAllSubviews];
    [self.alertTableView removeFromSuperview];
    self.alertTableView = nil;
    [self.layView removeAllSubviews];
    [self.layView removeFromSuperview];
    self.layView = nil;
    [Notification removeObserver:self];
    
}


@end
