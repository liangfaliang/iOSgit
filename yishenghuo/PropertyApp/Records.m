//
//  Records.m
//  shop
//
//  Created by 梁法亮 on 16/4/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "Records.h"



@implementation Records

-(void)awakeFromNib{
    [super awakeFromNib];
    self.roomNme.numberOfLines = 0;

}



-(void)setRoom:(UILabel *)room{
    _room = room;
    
    
//    self.room.lineBreakMode = UILineBreakModeWordWrap;


}



@end
