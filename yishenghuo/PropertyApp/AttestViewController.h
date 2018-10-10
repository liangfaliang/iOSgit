//
//  AttestViewController.h
//  shop
//
//  Created by 梁法亮 on 16/4/7.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttestViewController : BaseViewController
@property(nonatomic,strong)NSMutableString *str;

@property(nonatomic,strong)NSMutableString *strID;
@property (retain, nonatomic) IBOutlet UIButton *proButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;

@property(nonatomic,strong)NSString *isSenbox;

-(void)poprootviewcontroler;

-(void)isqwertt;
@end
