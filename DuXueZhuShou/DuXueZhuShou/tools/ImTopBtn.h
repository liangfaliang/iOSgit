//
//  ImTopBtn.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/26.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleNone, // none
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};
@interface ImTopBtn : UIButton
@property(nonatomic,assign)MKButtonEdgeInsetsStyle  edgeInsetsStyle ;
@property(nonatomic,assign)CGFloat  space ;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,strong)NSString *string;
@end
