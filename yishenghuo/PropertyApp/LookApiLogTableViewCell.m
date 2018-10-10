//
//  LookApiLogTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/9/1.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "LookApiLogTableViewCell.h"
static UIPasteboard *pasteBoard;
@implementation LookApiLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.urlLb.delegate = self;
//    self.contentLb.delegate = self;

}
//响应事件
//- (void)handleTap:(UITapGestureRecognizer *)sender {
//    [self becomeFirstResponder]; //UILabel默认是不能响应事件的，所以要让它成为第一响应者
//    UIMenuController *menuVC = [UIMenuController sharedMenuController];
//    [menuVC setTargetRect:self.urlLb.frame inView:self.superview]; //定位Menu
//    [menuVC setMenuVisible:YES animated:YES]; //展示Menu
//}
//
//- (BOOL)canBecomeFirstResponder { //指定UICopyLabel可以成为第一响应者 切忌不要把这个方法不小心写错了哟， 不要写成 becomeFirstResponder
//    return YES;
//}
////
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender { //指定该UICopyLabel可以响应的方法
//    if (action == @selector(copy:)) {
//        return YES;
//    }
//
//    if (action == @selector(selectAll:)) {
//        return YES;
//    }
//
//    return NO;
//}
//-(void)textViewDidBeginEditing:(UITextView *)textView{

//    [textView selectAll:textView];
//}
//
//
//
//- (void)copy:(id)sender {
//        pasteBoard.string = self.urlLb.text;
//
//}
//
//
//
//
//- (void)selectAll:(id)sender {
//    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
//    pasteBoard.string = self.contentLb.text;
////    self.urlLb.textColor = [UIColor blueColor];
//    NSLog(@"全选的数据%@", pasteBoard.string);
//}


@end
