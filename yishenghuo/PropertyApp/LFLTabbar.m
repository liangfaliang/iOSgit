//
//  LFLTabbar.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "LFLTabbar.h"
#import "LFLButton.h"

@interface LFLTabbar()

//记录当前选中的按钮
@property(nonatomic, strong) UIButton * selectedButton;

@end


@implementation LFLTabbar




-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.isSelect = NO;
    }
    return self;
}
//重写item的set方法（每次给item属性赋值的时候，都可以创建一个对应button）
- (void)setItem:(UITabBarItem *)item{
    
    //set方法的本质是给成员变量赋值
    _item = item;
    
    //创建一个对应的button
    LFLButton * button = [[LFLButton alloc] init];
    
    if (self.isSelect) {
        button.selected = YES;
        self.selectedButton = button;
    }
    //设置属性
    //1.title
    [button setTitle:item.title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    //2.image(正常状态下)
    [button setImage:item.image forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    //3.selegateImage
    [button setImage:item.selectedImage forState:UIControlStateSelected];
    
    
    //将按钮添加到tabBar上
    [self addSubview:button];
    
    //添加按钮点击事件
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
}


-(void)setBolock:(buttonBlock)bolock{

    _bolock = bolock;

}

//按钮点击
- (void)buttonClicked:(UIButton *)button{
    
    //1.将原来选中的按钮设置成不被选中
    self.selectedButton.selected = NO;
    
    //2.将当前点击的这个按钮设置成选中状态
    button.selected = YES;
    
    //3.更新selectedButton的值
    self.selectedButton = button;
    NSInteger index = button.frame.origin.x / button.frame.size.width;
    if (_bolock) {
        _bolock(index);
    }
    
    
}

//控件将要显示的时候会调用这个方法
//layoutSubviews执行两遍？
- (void)layoutSubviews{
    //设置各个button的frame
    //1.遍历出所有的button
    float buttonW = self.frame.size.width / self.subviews.count;
    float buttonY = 0;
    float buttonH = self.frame.size.height;
    for (int i = 0; i < self.subviews.count; i ++) {
        
        //a.拿到子视图（实质就是拿到所有的button）
        UIView * subView = self.subviews[i];
        
        //b.设置子视图的frame
        float buttonX = i * buttonW;
        subView.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
    }
    
    //    NSLog(@"===:%@", self.subviews);
}


@end
