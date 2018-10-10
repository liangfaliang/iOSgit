//
//  SKGraphicView.m
//  SKDrawingBoard
//
//  Created by youngxiansen on 15/10/10.
//  Copyright © 2015年 youngxiansen. All rights reserved.
//

#import "SKGraphicView.h"

@implementation SKGraphicView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _move = CGPointMake(0, 0);
        _start = CGPointMake(0, 0);
        _lineWidth = 3;
        _color = [UIColor redColor];
        _pathArray = [NSMutableArray array];
        _minPoint = CGPointMake(self.frame.size.width, self.frame.size.height);
        _maxPoint = CGPointMake(0, 64);
//        UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 64)];
//        headerview.backgroundColor =[UIColor whiteColor];
//        [self addSubview:headerview];
//        //创建保存功能
//        UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
//        but.frame = CGRectMake(self.frame.size.width - 80, 20, 80, 44);
//        [but setTitle:@"保存" forState:UIControlStateNormal];
//        [but addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
//        [headerview addSubview:but];
//        
//        UIButton *undoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        undoBtn.frame = CGRectMake(110, 0, 100, 64);
//        [undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
//        [undoBtn addTarget:self action:@selector(undoBtnEvent) forControlEvents:UIControlEventTouchUpInside];
////        [headerview addSubview:undoBtn];
//        
//        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        clearBtn.frame = CGRectMake(80, 20, 80, 44);
//        [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
//        [clearBtn addTarget:self action:@selector(clearBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//        [headerview addSubview:clearBtn];
//        
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        backBtn.frame = CGRectMake(0, 20, 80, 44);
//        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(backBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//        [headerview addSubview:backBtn];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPicture:context]; //画图
}

- (void)drawPicture:(CGContextRef)context {
    
    
    for (NSArray * attribute in _pathArray) {
        //将路径添加到上下文中
        CGPathRef pathRef = (__bridge CGPathRef)(attribute[0]);
        CGContextAddPath(context, pathRef);
        //设置上下文属性
        [attribute[1] setStroke];
        CGContextSetLineWidth(context, [attribute[2] floatValue]);
        //绘制线条
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"_lineWidth:%f",_lineWidth);
    UITouch *touch = [touches anyObject];
    _path = CGPathCreateMutable(); //创建路径
    NSArray *attributeArry = @[(__bridge id)(_path),_color,[NSNumber numberWithFloat:_lineWidth]];
    
    [_pathArray addObject:attributeArry]; //路径及属性数组数组
    _start = [touch locationInView:self]; //起始点
    CGPathMoveToPoint(_path, NULL,_start.x, _start.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    释放路径
    CGPathRelease(_path);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _move = [touch locationInView:self];
    //将点添加到路径上
    CGPathAddLineToPoint(_path, NULL, _move.x, _move.y);
//    if (_move.y > 64) {
        if (_move.x < _minPoint.x ) {
            _minPoint.x = _move.x;
        }
        if (_move.y < _minPoint.y ) {
            _minPoint.y = _move.y;
        }
        if (_move.x > _maxPoint.x ) {
            _maxPoint.x = _move.x;
        }
        if (_move.y > _maxPoint.y ) {
            _maxPoint.y = _move.y;
        }
//    }


    [self setNeedsDisplay];
}

#pragma mark --点击事件--

- (void)savePhoto {
    
    if (_pathArray.count) {
        UIGraphicsBeginImageContext(self.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        _minPoint.x = (_minPoint.x - 10 < 0) ? 0 : _minPoint.x - 10;
        _minPoint.y = (_minPoint.y - 10 < 0) ? 0 : _minPoint.y - 10;
        _maxPoint.x = (_maxPoint.x + 10 > self.frame.size.width) ? self.frame.size.width : _maxPoint.x + 10;
        _maxPoint.y = (_maxPoint.y + 10 > self.frame.size.height) ? self.frame.size.height : _maxPoint.y + 10;
        UIRectClip(CGRectMake(_minPoint.x, _minPoint.y, _maxPoint.x - _minPoint.x, _maxPoint.y -_minPoint.y));
        [self.layer renderInContext:context];

        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        if (self.saveBlock) {
            NSLog(@"%f===%f",image.size.width,image.size.height);
            self.saveBlock(image);
        }
    }
    else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请您先签名" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
    }
    [self dismiss];
}

-(UIImage *)getDrawingImg{
    if (_pathArray.count) {

        _minPoint.x = (_minPoint.x - 10 < 0) ? 0 : _minPoint.x - 10;
        _minPoint.y = (_minPoint.y - 10 < 0) ? 0 : _minPoint.y - 10;
        _maxPoint.x = (_maxPoint.x + 10 > self.frame.size.width) ? self.frame.size.width : _maxPoint.x + 10;
        _maxPoint.y = (_maxPoint.y + 10 > self.frame.size.height) ? self.frame.size.height : _maxPoint.y + 10;
        UIGraphicsBeginImageContext(self.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIRectClip(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        [self.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //截取所需区域
        CGRect captureRect = CGRectMake(_minPoint.x, _minPoint.y, _maxPoint.x - _minPoint.x, _maxPoint.y -_minPoint.y);
        CGImageRef sourceImageRef = [image CGImage];
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, captureRect);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];

        LFLog(@"%f==%f",newImage.size.width,newImage.size.height);
        return newImage;
    }
    return nil;
}
-(void)backBtnEvent{
    [self dismiss];
}
- (void)dismiss{
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.0000000001, 0.00000001);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)undoBtnEvent
{
    [_pathArray removeLastObject];
    [self setNeedsDisplay];
}

-(void)clearBtnEvent
{
    [_pathArray removeAllObjects];
    [self setNeedsDisplay];
}

@end
