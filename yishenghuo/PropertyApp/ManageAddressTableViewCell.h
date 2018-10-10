//
//  ManageAddressTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/31.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^myblock) (NSInteger index);
@interface ManageAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addname;
@property (weak, nonatomic) IBOutlet UILabel *addPhone;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIView *manageView;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;
@property(copy,nonatomic)myblock defaultblock;
-(void)setDefaultblock:(myblock)defaultblock;
@end
