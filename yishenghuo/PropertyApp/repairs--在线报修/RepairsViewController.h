//
//  RepairsViewController.h
//  shop
//
//  Created by wwzs on 16/4/11.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "RepairsViewController.h"
#import "ItemViewController.h"
#import "PositionViewController.h"
#import "MHDatePicker.h"
#import "ImagePostTableViewCell.h"
#import "HPGrowingTextView.h"

@interface RepairsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ItemViewControllerDelegate,PositionViewControllerDelegate,MHSelectPickerViewDelegate,HPGrowingTextViewDelegate>

@property (strong,nonatomic)NSString *contentStr;
@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)UIView *view1;
@property (strong,nonatomic)UISegmentedControl *segment;
@property (strong,nonatomic)NSArray *titleArr;
@property (strong,nonatomic)NSMutableArray *contentArr;
//title
@property (strong,nonatomic)NSString *titlename;
@property (strong,nonatomic)HPGrowingTextView *txtView;
@property (strong, nonatomic) MHDatePicker *selectTimePicker;
@property (strong, nonatomic) NSArray *segementArray;
//segment=1的时候cell里面的内容
@property (strong,nonatomic)NSString *str;
@property (strong,nonatomic)NSString *publicRepair;
@property (strong, nonatomic)  UILabel *myLabel;
//timebtn

//物业项目
@property (strong,nonatomic)UIButton *itembtn;

//物业位置
@property (strong,nonatomic)UIButton *positionbtn;
@property (strong,nonatomic)NSString *timeStr;
//预约时间
@property (strong,nonatomic)UIButton *timebtn;

@property (strong,nonatomic)NSString *isPop;
@property(nonatomic,strong)NSString *poid;//房间pid
//判断谁跳转的
@property(assign,nonatomic)NSInteger tag;
@property(assign,nonatomic)NSInteger selectIndex;
@property(strong,nonatomic)NSURL* url;
-(void)titleInfo:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3;
-(void)willappear;
-(void)userInfo;
- (void)itemString:(NSString *)string;
- (void)positionString:(NSString *)string;
@end
