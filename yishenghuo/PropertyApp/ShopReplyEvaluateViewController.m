//
//  ShopReplyEvaluateViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/16.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopReplyEvaluateViewController.h"
#import "HPGrowingTextView.h"
#import "GoodsReviewTableViewCell.h"
#import "DoodsDetailsViewController.h"
@interface ShopReplyEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HPGrowingTextViewDelegate>
@property (nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)HPGrowingTextView *tfview;
@property (nonatomic,strong)UIButton *sendBtn;
//添加屏幕的蒙罩
@property(nonatomic,strong)UIView *layView;

@property(nonatomic,strong)NSMutableArray *listArray;
@end

@implementation ShopReplyEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"回复";
    for (NSDictionary *dt in self.dataArray[0][@"re_list"]) {
        [self.listArray addObject:dt];
    }
    LFLog(@"listArray:%@",self.listArray);
    [self createTableview];
    [self creatBottomview];
    
    //添加键盘通知
//    [Notification addObserver:self selector:@selector(replykbWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [Notification addObserver:self selector:@selector(replykbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [[NSMutableArray alloc]init];
    }
    return _listArray;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)replykbWillShow:(NSNotification *)noti{
    NSDictionary *dict = [noti userInfo];
    CGRect keyboardRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.layView.frame = CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - keyboardRect.size.height);
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(100);
    }];
    
}

-(void)replykbWillHide:(NSNotification *)noti
{
    
    CGSize size = [self.tfview.text selfadap:14 weith:55];
    CGFloat hh = 30;
    if (size.height  + 5> 30) {
        if (size.height + 5< 80) {
            hh = size.height + 5;
        }else{
        hh = 80;
        }
        
    }
    LFLog(@"hh:%f",hh);
    self.layView.frame = CGRectMake(0, SCREEN.size.height-(hh + 20)-(kDevice_Is_iPhoneX ? 34 :0), SCREEN.size.width, hh + 20);

    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(hh + 20);
    }];
    self.tableview.frame = CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height  -(hh + 20));
}
- (void)creatBottomview
{
    //蒙版
    self.layView = [[UIView alloc]init];
    self.layView.frame = CGRectMake(0, SCREEN.size.height-(kDevice_Is_iPhoneX ? 84 :50), SCREEN.size.width, 50);
    self.layView.backgroundColor = JHColoralpha(0, 0, 0, 0.2);
    [self.view addSubview:self.layView];
    self.bottomView = [[UIView alloc]init];
//    self.bottomView.frame = CGRectMake(0, SCREEN.size.height-50, SCREEN.size.width, 50);
    [self.bottomView setBackgroundImage:[UIImage imageNamed:@"base"]];
    //self.bottomView.backgroundColor = [UIColor redColor];
    [self.layView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(50);
    }];
    
    self.tfview = [[HPGrowingTextView alloc]init];
    self.tfview.layer.borderColor = [JHbgColor CGColor];
    self.tfview.animateHeightChange = YES;
    self.tfview.layer.borderWidth = 1;
    self.tfview.layer.cornerRadius = 5;
    self.tfview.font = [UIFont systemFontOfSize:14];
    self.tfview.placeholder = @"评论";
    self.tfview.textColor = [UIColor grayColor];
    self.tfview.delegate = self;
    [self.bottomView addSubview:self.tfview];
    [self.tfview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-100);
        make.bottom.offset(-10);
        make.top.offset(10);
    }];
    
    
    self.sendBtn = [[UIButton alloc]init];
    [self.sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.sendBtn.backgroundColor = JHAssistColor;
    self.sendBtn.layer.cornerRadius = 5;
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sendBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tfview.mas_right).offset(10);
        make.right.offset(-10);
        make.bottom.offset(-10);
        make.height.offset(30);
    }];

}
-(void)submitClick:(UIButton *)btn{

    if (self.tfview.text.length == 0) {
        [self presentLoadingTips:@"请输入您要评价的内容"];
        return;
    }
    [self.tfview resignFirstResponder];
    [self UploadDatagoodsEvaluation];
    
}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height  -50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerNib:[UINib nibWithNibName:@"GoodsReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopReplyEvaluateViewController"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cartfirmCell"];
    [self.view addSubview:self.tableview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.listArray.count) {
        return self.listArray.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.listArray.count) {
        NSDictionary *dt = self.listArray[indexPath.section];
        CGFloat HH = 0;
        NSString *content = dt[@"content"];;
        
        HH += [content selfadap:14 weith:20].height;
        
        return HH + 105;
    }
    return SCREEN.size.height - 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.listArray.count) {
        GoodsReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopReplyEvaluateViewController"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dt = self.listArray[indexPath.section];
        cell.xxbackHeight.constant = 0;
        cell.xxbackWidth.constant = 0;   
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:dt[@"headimage"]] placeholderImage:[UIImage imageNamed:@"morentouxiang-zhijie"]];
        cell.nameLabel.text = dt[@"username"];
        cell.timeLabel.text = dt[@"add_time"];
        cell.contentLabel.text = dt[@"content"];
        cell.imageHeigth.constant = 10;
        cell.businessHeight.constant = 0;
        cell.replycount.hidden = YES;
        cell.replyImage.hidden = YES;
        cell.likeView.hidden = YES;
        cell.likeLabel.hidden = YES;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartfirmCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        UIImageView *plImview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"replyshafa"]];
        [cell.contentView addSubview:plImview];
        [plImview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(60);
            make.centerX.equalTo(cell.contentView.mas_centerX);
        }];
        return cell;
    }
    
}

#pragma mark - *************评价提交
-(void)UploadDatagoodsEvaluation{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSString *ip = @"119.57.138.165";

    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.dataArray[0][@"id"],@"parent_id",self.tfview.text,@"content",ip,@"ip_address",self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    LFLog(@"dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderEvaluateUrl) params:dt success:^(id response) {
        [self dismissTips];
        LFLog(@"评价：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"您已评价成功"];
            [self UploadDatagoodsEvaluateReplyList];
//            [self performSelector:@selector(popviewcontroller) withObject:nil afterDelay:2.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
     
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"评价error：%@",error);
        [self dismissTips];
    }];
    
    
}

#pragma mark - *************商品评论列表请求*************
-(void)UploadDatagoodsEvaluateReplyList{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.dataArray[0][@"id"],@"comment_id",self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderEvaluateReplyListUrl) params:dt success:^(id response) {
        LFLog(@"商品评论详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            [self.listArray removeAllObjects];
            for (NSDictionary *dict in response[@"data"][@"re_list"]) {
                [self.listArray addObject:dict];
            }
            [self.tableview reloadData];
            
        }else{
            //            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            //            if ([error_code isEqualToString:@"100"]) {
            //                [self showLogin];
            //            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}


@end
