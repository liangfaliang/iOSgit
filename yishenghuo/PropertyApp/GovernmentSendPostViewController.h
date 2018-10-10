//
//  GovernmentSendPostViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/12.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SuccessblockClick)();
@interface GovernmentSendPostViewController : BaseViewController
@property(nonatomic,strong)NSString *cat_id;
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,copy)SuccessblockClick block;

-(void)setBlock:(SuccessblockClick)block;
@end
