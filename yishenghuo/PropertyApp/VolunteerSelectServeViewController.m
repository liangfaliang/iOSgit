//
//  VolunteerSelectServeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/5.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "VolunteerSelectServeViewController.h"

@interface VolunteerSelectServeViewController ()<UIScrollViewDelegate>
@property(strong,nonatomic)UIScrollView *scrollview;
@end

@implementation VolunteerSelectServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.nameTitle;
    [self createUI];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick:)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)createUI{

    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, SCREEN.size.width, SCREEN.size.height)];
    self.scrollview.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.scrollview];
    UIView *backview = [[UIView alloc]init];
    backview.backgroundColor = JHBorderColor;
    [self.scrollview addSubview:backview];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 30)];
    lb.backgroundColor = [UIColor whiteColor];
    lb.text = @"     可多选";
    
    lb.textColor = JHAssistColor;
    lb.font =[UIFont systemFontOfSize:12];
    [self.view addSubview:lb];
    CGFloat HH = 0;
    for (int i = 0 ; i < ((self.dataArr.count%2  == 0) ? self.dataArr.count/2 : (self.dataArr.count/2 + 1)); i ++) {
        UIView *bview = [[UIView alloc]initWithFrame:CGRectMake(0,  1 + HH, SCREEN.size.width, 59)];
        bview.backgroundColor = [UIColor whiteColor];
        [self.scrollview addSubview:bview];
        
        for (int j = 0; j < 2; j ++) {
            if ((i * 2 + j) < self.dataArr.count) {

            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(j * SCREEN.size.width/2 + 10 , 0, SCREEN.size.width/2 - 10, 59)];
            LFLog(@"%d",i * 2 + j);
            NSDictionary*dt = self.dataArr[i * 2 + j];
            [button setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];

            [button setTitle:dt[@"ep_name"] forState:UIControlStateNormal];
            [button  setImage:[UIImage imageNamed:@"xuanzemoren"] forState:UIControlStateNormal];
            [button  setImage:[UIImage imageNamed:@"dianzedianji"] forState:UIControlStateSelected];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//水平方向文字居左显示
            button.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 50 + i *2 +j;
            [bview addSubview:button];
            
        }
      
      }
        HH += 60;
    }
    backview.frame = CGRectMake(0, 0, SCREEN.size.width, HH);
    self.scrollview.contentSize = CGSizeMake(0, HH + 30);
    

}
-(void)selectBtnClick:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}

//确定按钮
-(void)rightClick:(UIBarButtonItem *)rightbtn{

    NSMutableArray *marray = [[NSMutableArray alloc]init];
    for (int i= 0; i < self.dataArr.count; i ++) {
        UIButton *btn = [self.view viewWithTag:50 + i];
        if (btn.selected) {
            [marray addObject:self.dataArr[i]];
        }
    }
    if (self.Block) {
        self.Block(self.tag,marray);
    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
