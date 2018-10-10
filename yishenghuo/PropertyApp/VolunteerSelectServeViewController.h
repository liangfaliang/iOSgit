//
//  VolunteerSelectServeViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/5.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolunteerSelectServeViewController : BaseViewController
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSString *nameTitle;
@property (nonatomic,assign)NSInteger tag;
@property (nonatomic,copy) void (^Block)(NSInteger index, NSMutableArray *marray);
@end
