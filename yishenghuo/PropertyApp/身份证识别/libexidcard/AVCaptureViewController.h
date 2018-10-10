//
//  AVCaptureViewController.h
//  实时视频Demo
//
//  Created by zhongfeng1 on 2017/2/16.
//  Copyright © 2017年 zhongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDInfo.h"
typedef void(^IdCodesuccessBlock)(IDInfo *Info,UIImage *image);
@interface AVCaptureViewController : UIViewController
@property (strong, nonatomic) IdCodesuccessBlock block;
-(void)StartTesting:(BOOL)isFace;
- (void)successfulGetIdCodeInfo:(IdCodesuccessBlock)success;
@end

