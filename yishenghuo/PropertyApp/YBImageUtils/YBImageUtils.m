//
//  YBImageUtils.m
//  LuoLongChat
//
//  Created by admin on 2018/11/5.
//  Copyright © 2018年 Harton. All rights reserved.
//

#import "YBImageUtils.h"
#import <YBImageBrowser.h>
#import <YBIBUtilities.h>
#import <YBImageBrowserTipView.h>
@implementation YBImageUtils
+ (void)showBrowserForMixedCaseWithArr:(NSArray *)imageArr viewArr:(NSArray *)viewArr  index:(NSInteger)index {
    NSMutableArray *browserDataArr = [NSMutableArray array];
    [imageArr enumerateObjectsUsingBlock:^( id _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[NSString class]]) {
            NSString *imageStr = (NSString *)value;
            // 此处只是为了判断测试用例的数据源是否为视频，并不是仅支持 MP4。/ This is just to determine whether the data source of the test case is video, not just MP4.
            if ([imageStr hasSuffix:@".MP4"] || [imageStr hasSuffix:@".mp4"]) {
                if ([imageStr hasPrefix:@"http"]) {
                    
                    // Type 1 : 网络视频 / Network video
                    YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
                    data.url = [NSURL URLWithString:imageStr];
                    if (viewArr.count > idx) {
                        data.sourceObject = viewArr[idx];
                    }
                    [browserDataArr addObject:data];
                    
                } else {
                    
                    // Type 2 : 本地视频 / Local video
                    NSString *path = [[NSBundle mainBundle] pathForResource:imageStr.stringByDeletingPathExtension ofType:imageStr.pathExtension];
                    NSURL *url = [NSURL fileURLWithPath:path];
                    YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
                    data.url = url;
                    if (viewArr.count > idx) {
                        data.sourceObject = viewArr[idx];
                    }
                    [browserDataArr addObject:data];
                    
                }
            } else if ([imageStr hasPrefix:@"http"]) {
                
                // Type 3 : 网络图片 / Network image
                YBImageBrowseCellData *data = [YBImageBrowseCellData new];
                static int i = 0;
                if (i++ != 0) data.url = [NSURL URLWithString:imageStr];
                if (viewArr.count > idx) {
                    data.sourceObject = viewArr[idx];
                }
                [browserDataArr addObject:data];
                
            } else {
                
                // Type 4 : 本地图片 / Local image
                YBImageBrowseCellData *data = [YBImageBrowseCellData new];
                data.image = [YBImage imageNamed:imageStr];
                if (viewArr.count > idx) {
                    data.sourceObject = viewArr[idx];
                }
                [browserDataArr addObject:data];
                
            }
        }else if ([value isKindOfClass:[UIImage class]]){
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.image = value;
            [browserDataArr addObject:data];
        }else if ([value isKindOfClass:[NSURL class]]){
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.url = value;
            [browserDataArr addObject:data];
        }
    }];

    
    //Type 5 : 自定义 / Custom
//    CustomCellData *data = [CustomCellData new];
//    data.text = @"Custom Cell";
//    [browserDataArr addObject:data];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = browserDataArr;
    browser.currentIndex = index;
    [browser show];
}
@end
