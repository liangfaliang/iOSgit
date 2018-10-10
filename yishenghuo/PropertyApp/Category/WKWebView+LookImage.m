//
//  WKWebView+LookImage.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/3/13.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "WKWebView+LookImage.h"
#import "STPhotoBroswer.h"
@implementation WKWebView (LookImage)
static char imgUrlArrayKey;
- (void)setMethod:(NSArray *)imgUrlArray
{
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getImgUrlArray
{
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
}
-(void)ImageAdaptiveIphone:(WKWebView *)wkWebView{

    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.height = %f/myimg.width *myimg.height;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);%@";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15,[UIScreen mainScreen].bounds.size.width-15,@"ResizeImages();"];
    //    LFLog(@"js:%@",js);
    [wkWebView evaluateJavaScript:js  completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];


    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    [wkWebView evaluateJavaScript:jSString  completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}


/*
 *通过js获取htlm中图片url
 */
-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView
{
    
    //查看大图代码
    //js方法遍历图片添加点击事件返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };function registerImageClickAction(){\
    var imgs=document.getElementsByTagName('img');\
    var length=imgs.length;\
    for(var i=0;i<length;i++){\
    img=imgs[i];\
    img.onclick=function(){\
    window.location.href='image-preview:'+this.src}\
    }\
    }";
//用js获取全部图片
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
        NSLog(@"js___Result==%@",Result);
        NSLog(@"js___Error -> %@", error);
    }];


    NSString *js2=@"getImages()";

    __block NSMutableArray *array=[NSMutableArray array];
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        NSLog(@"js2__Result==%@",Result);
        NSLog(@"js2__Error -> %@", error);
        
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        
        if([resurlt hasPrefix:@"#"])
        {
            resurlt=[resurlt substringFromIndex:1];
        }
        NSLog(@"result===%@",resurlt);
         array=[NSMutableArray arrayWithArray:[resurlt componentsSeparatedByString:@"+"]];
        if (array.count >= 2) {
            [array removeLastObject];
        }
        NSLog(@"array===%@",array);
        [wkWebView setMethod:array];
    }];

    return array;
}


//显示大图
-(BOOL)showBigImage:(NSURLRequest *)request
{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"image-preview:"])
    {
        NSString *imageUrl = [requestString substringFromIndex:@"image-preview:".length];
        NSLog(@"image url------%@", imageUrl);
        
        NSArray *imgUrlArr=[self getImgUrlArray];
        NSInteger index=0;
        for (NSInteger i=0; i<[imgUrlArr count]; i++) {
            if([imageUrl isEqualToString:imgUrlArr[i]])
            {
                index=i;
                break;
            }
        }
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:imgUrlArr currentIndex:0];
        [broser show];
//        [WFImageUtilshowImgWithImageURLArray:[NSMutableArrayarrayWithArray:imgUrlArr] index:index myDelegate:nil];
        
        return NO;
    }
    return YES;
}


@end
