//
//  PayViewController.h
//  shop
//
//  Created by FGH on 16/4/13.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : BaseViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>

{
    //    BOOL selectedArr[5000];
    //    BOOL reloading;
    BOOL first;
    //    BOOL btnSelected;
}
@property (strong,nonatomic)UITableView *tableView;

@property (strong,nonatomic)UIView *view1;
@property (strong,nonatomic)UISegmentedControl *segment;
@property (strong,nonatomic)UITableView *tableView2;
@property (strong,nonatomic)NSArray *titleArr;
@property (strong,nonatomic)NSArray *hArr;
@property (strong,nonatomic)NSArray *totalArr;
//底部付款view
@property (strong,nonatomic)UIView *bottomView;
//************************未缴费页面********************
//第一个cell的姓名
@property (strong,nonatomic)NSString *nameStr;
//第一个cell的房间号
@property (strong,nonatomic)NSString *roomStr;
//第一个cell的面积
@property (strong,nonatomic)NSString *areaStr;



//********************************************

@property (strong,nonatomic)UIImageView *imageView;
//已选xx元
@property (strong,nonatomic)UIButton *selectedBtn;
//底部金额
@property (strong,nonatomic)NSString *moneyStr;
@property (copy,nonatomic)NSMutableArray *unpayNoteArr;
@property (strong,nonatomic)NSMutableArray *payNoteArr;
@property (strong,nonatomic)NSMutableArray *unpayArr;//存未交费model
@property (strong,nonatomic)NSMutableArray *payArr;
@property (strong,nonatomic)NSString *imageStr;
@property (strong,nonatomic)NSString *isPop;
@property (strong,nonatomic)UIButton *allSelectedBtn;

@property (strong,nonatomic)NSMutableArray *keyArr;

//订单信息数组
@property (strong,nonatomic)NSMutableArray *orderArray;//提交订单数组信息
//@property (strong,nonatomic)NSMutableDictionary *idDicArr;
//@property (strong,nonatomic)NSMutableDictionary *amouDicArr;
//@property (strong,nonatomic)NSMutableDictionary *nameDicArr;
@property (strong,nonatomic)UIImageView *imgView;

//全选计数器
//@property(nonatomic,assign)NSUInteger total;
//
@property(nonatomic,assign)NSUInteger totalcount;
@property (strong,nonatomic)NSString *image;
@property(assign,nonatomic)NSInteger selectIndex;
//数据请求对象
//@property(nonatomic,strong)NSMutableArray *requestArr;
-(void)paywillappear;

@end
