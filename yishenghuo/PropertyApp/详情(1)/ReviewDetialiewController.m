
//
//  ReviewDetialiewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/2.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "ReviewDetialiewController.h"
#import "reviewDetailTableViewCell.h"
#import "NSString+selfSize.h"
#import "HPGrowingTextView.h"
#import "CustomButton.h"
@interface ReviewDetialiewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HPGrowingTextViewDelegate>
@property (nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)HPGrowingTextView *tfview;
@property (nonatomic,strong)UIButton *sendBtn;
//添加屏幕的蒙罩
@property(nonatomic,strong)UIView *layView;
//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;

@end

@implementation ReviewDetialiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarTitle = @"更多评论";
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 114)];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"reviewDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"reviewDetailTableViewCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self creatBottomview];
    //添加键盘通知
    [Notification addObserver:self selector:@selector(reviewkbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [Notification addObserver:self selector:@selector(reviewkbWillHide:) name:UIKeyboardWillHideNotification object:nil];

    LFLog(@"model:%@",self.model);
}

- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    reviewDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewDetailTableViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.model = self.model;
    __weak typeof(cell) weakcell = cell;
    [cell setPraiseblock:^(NSInteger str) {
        
        [self requestPinglunpraiseData:weakcell.model.id];
    }];
    
    [cell setReviewBlock:^(NSInteger str) {
        [self tfviewisFirst];
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    CGFloat H = 0;
    CGSize content = [_model.content selfadap:13 weith:20];
    CGFloat h = 5;
    if (_model.comment.count > 0 ) {
        
        
        for (int i = 0; i < _model.comment.count ; i ++) {
            NSDictionary *dt = _model.comment[i];
            
            NSString *str = [NSString stringWithFormat:@"%@：%@",dt[@"username1"],dt[@"content"]];
            CGSize size = [str selfadaption:13];
            h += size.height + 10;
            
        }
        
    
            H = content.height + 70 + h;
        
    }else{
        H = content.height + 70;
        
    }
    
    
    
    return H ;

}

- (void)creatBottomview
{
    self.bottomView = [[UIView alloc]init];
    self.bottomView.frame = CGRectMake(0, SCREEN.size.height-40, SCREEN.size.width, 40);
    [self.bottomView setBackgroundImage:[UIImage imageNamed:@"base"]];
    //self.bottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.bottomView];
    
    
    self.tfview = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(20, 5, SCREEN.size.width-80, 30)];
//    self.tfview.layer.borderColor = [[UIColor colorWithRed:235/256.0 green:236/256.0 blue:237/256.0 alpha:1.0]CGColor];
//    self.tfview.layer.borderWidth = 1;
//    self.tfview.layer.cornerRadius = 5;
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
- (void)sendClick1
{
    if ([self.tfview.text isEqualToString:@""] == YES)
    {
        [self presentLoadingTips:@"请输入评论内容~~~"];
        return;
    }
    LFLog(@"%@",self.tfview.text);

    [self requestreviewcontentData:self.modelid username2:_model.username2 parentid:_model.id content:self.tfview.text];


    self.tfview.text = nil;
    [self.tfview resignFirstResponder];
}
-(void)reviewkbWillShow:(NSNotification *)noti
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
- (void)tfviewisFirst{
    [ self.tfview becomeFirstResponder];
    
}
-(void)reviewkbWillHide:(NSNotification *)noti
{
    
    self.tfview.text = nil;
    [self.layView removeFromSuperview];
    self.bottomView.frame = CGRectMake(0, SCREEN.size.height-40, SCREEN.size.width, 40);
    self.tfview.frame = CGRectMake(20, 5, SCREEN.size.width-80, 30);
    
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
    [self.bottomView endEditing:YES];
}
#pragma mark 评论点赞请求数据
- (void)requestPinglunpraiseData:(NSString *)commentid{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid,@"commentid":commentid};
    [LFLHttpTool post:NSStringWithFormat(ZJBBsBaseUrl,@"11") params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            //            LFLog(@"获取成功%@",dict);
            [self requestreviewreloadData:_model.id];
            [self presentLoadingTips:@"点赞成功~~"];
            self.model.is_collect = @"1";
            NSInteger praise = [self.model.collect_count integerValue];
            praise ++;
            self.model.collect_count = [NSString stringWithFormat:@"%d",(int)praise];
        }else{
            
            [self presentLoadingTips:response[@"err_msg"]];
        }

    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    }];
    
}


#pragma mark 用户评论请求数据
- (void)requestreviewcontentData:(NSString *)articleid username2:(NSString *)username2 parentid:(NSString *)parentid content:(NSString *)content{
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSString *username = [UserDefault objectForKey:@"username"];
    NSDictionary *dt = @{@"userid":uid,@"username":username,@"articleid":articleid,@"content":content,@"parentid":parentid,@"username1":username,@"username2":username2};
    [LFLHttpTool post:NSStringWithFormat(ZJBBsBaseUrl,@"9") params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            
            [self requestreviewreloadData:_model.id];
            
            [self presentLoadingTips:@"评论成功~~"];
        }else{
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
        
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    }];
    
}

#pragma mark 评论刷新数据
- (void)requestreviewreloadData:(NSString *)reviewid{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"id":reviewid};
    [LFLHttpTool get:NSStringWithFormat(ZJBBsBaseUrl,@"17") params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            ReviewModel *mo = [[ReviewModel alloc]init];
            
            mo.comment = response[@"note"];
            LFLog(@"评论刷新：%@",mo.comment);
            _model.comment = mo.comment;
            
            //            self.modelid = nil;
            [self.tableview reloadData];
            
        }else{
            
            
        }
        
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    }];
    
}


@end
