//
//  SKGraphicView.m
//  SKDrawingBoard
//
//  Created by youngxiansen on 15/10/10.
//  Copyright © 2015年 youngxiansen. All rights reserved.
//

#import "SKGraphicViewController.h"
#import "SKGraphicView.h"
@interface SKGraphicViewController (){
    SKGraphicView *signatureView;
}

@end
@implementation SKGraphicViewController
-(instancetype)init{
    if (self = [super init]) {
        _lineWidth = 3;
        _color = [UIColor blackColor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarTitle = @"手写签名";
    //创建保存功能
    UIButton *but = [[UIButton alloc]init];
    but.frame = CGRectMake(0, 0, 60, 44);
    but.titleLabel.font = [UIFont systemFontOfSize:15];
    [but setTitle:@"保存" forState:UIControlStateNormal];
    [but setTitleColor:JHMaincolor forState:UIControlStateNormal];
    [but addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [headerview addSubview:but];
    
//    UIButton *undoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    undoBtn.frame = CGRectMake(110, 0, 100, 64);
//    [undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
//    [undoBtn addTarget:self action:@selector(undoBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    //        [headerview addSubview:undoBtn];
    
    UIButton *clearBtn = [[UIButton alloc]init];
//    clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    clearBtn.frame = CGRectMake(0, 0, 60, 44);
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn setTitleColor:JHMaincolor forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
//    [headerview addSubview:clearBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 60, 44);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];

    [backBtn addTarget:self action:@selector(backBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//    [headerview addSubview:backBtn];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:but],[[UIBarButtonItem alloc]initWithCustomView:clearBtn]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn],[[UIBarButtonItem alloc]initWithCustomView:clearBtn];
    signatureView = [[SKGraphicView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    signatureView.backgroundColor = [UIColor whiteColor];
    signatureView.color = self.color;
    signatureView.lineWidth = self.lineWidth;
    [self.view addSubview:signatureView];
}

#pragma mark --点击事件--

- (void)savePhoto {
    UIImage *image = [signatureView getDrawingImg];
    if (image) {
        if (self.saveBlock) {
            self.saveBlock(image);
        }

        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"请您先绘制图形" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    
}
-(void)clearBtnEvent{
    [signatureView clearBtnEvent];

}

-(void)backBtnEvent{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)fd_interactivePopDisabled{

    return YES;
}
@end
