//
//  Records.h
//  shop
//
//  Created by 梁法亮 on 16/4/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Records : UIView

@property (retain, nonatomic) IBOutlet UILabel *username;

@property (retain, nonatomic) IBOutlet UILabel *usercompany;
@property (retain, nonatomic) IBOutlet UILabel *userproject;

@property (retain, nonatomic) IBOutlet UILabel *location;

@property (retain, nonatomic) IBOutlet UILabel *room;
@property (weak, nonatomic) IBOutlet UILabel *roomNme;

@property (retain, nonatomic) IBOutlet UILabel *recordtime;

@property(nonatomic,assign)CGFloat height;
@property (retain, nonatomic) IBOutlet UIButton *phoneButon;

@end
