//
//  ArticleListTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIView *imView;
@property (weak, nonatomic) IBOutlet UILabel *scroceLb;
-(void)setimviewSubview:(NSArray *)imarr;
@end
