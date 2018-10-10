//
//  VolunteerControlRegulationsViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/7.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "VolunteerControlRegulationsViewController.h"
#import "YYText.h"
#import "NSParagraphStyle+YYText.h"
@interface VolunteerControlRegulationsViewController ()
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UIView *backview;
@property(nonatomic,strong)UILabel *lb;
@end

@implementation VolunteerControlRegulationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTitle = @"志愿者管理条例";
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height)];
    self.scrollview.backgroundColor = JHColor(165, 192, 251);
    //    _scrollview.pagingEnabled = NO;
    
    self.backview = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width - 20, SCREEN.size.height)];
    //    self.backview.image = [UIImage imageNamed:@"zuixintongzhibeijing"];
    self.backview.backgroundColor = JHColor(204, 215, 246);
    //    self.backview.layer.cornerRadius = 15;
    //    self.backview.layer.masksToBounds = YES;
    [_scrollview addSubview:_backview];
    [self.view addSubview:self.scrollview];
    
//    self.scrollview.contentSize = CGSizeMake(0, 19000);
    
    _lb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width - 40, SCREEN.size.height)];
//    _lb.backgroundColor = [UIColor redColor];
    _lb.font = [UIFont systemFontOfSize:15];
    _lb.textColor = JHmiddleColor;
    _lb.numberOfLines = 0;

    [_backview addSubview:_lb];
    [self updateRegulations];
}

#pragma mark 活动
-(void)updateRegulations{

    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersRegulationsUrl) params:nil success:^(id response) {
//        [_tableview.mj_header endRefreshing];
        LFLog(@"活动：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            NSString *str = response[@"data"][@"system"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *strhtml = [str filterHTML];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _lb.text = strhtml;
                    [_lb NSParagraphStyleAttributeName:15];
                    _lb.frame = CGRectMake(10, 0, SCREEN.size.width - 40, [strhtml selfadap:15 weith:40 Linespace:15].height);
                    _backview.frame = CGRectMake(10, 0, SCREEN.size.width - 20, [strhtml selfadap:15 weith:40 Linespace:15].height);
                    _scrollview.contentSize = CGSizeMake(0, [strhtml selfadap:15 weith:40 Linespace:15].height);
                    //回调或者说是通知主线程刷新，
                });
            });
            
        }else{
             [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
