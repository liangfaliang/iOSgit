//
//  AlertSelectTimeView.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlertSelectTimeView;
@protocol AlertSelectTimeViewDelegate <NSObject>
@optional
-(void)AlertSelectTimeViewDidSelectCell:(AlertSelectTimeView *)alertview phy_timeArr:(NSArray *)phyArr Indexpath:(NSIndexPath *)indexpath;
@end
@interface AlertSelectTimeView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)baseTableview *alertTableView;
@property(nonatomic,strong)UIView *backview;
@property (strong,nonatomic)NSArray *phy_timeArr;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)showAlertview:(NSArray *)phy_timeArr;
@property(nonatomic,weak)id<AlertSelectTimeViewDelegate> delegate;
@end
