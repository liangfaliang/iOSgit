//
//  HealthRecordHeaderview.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/19.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthRecordHeaderview.h"
#import "HealthRecordsFirstViewController.h"
@implementation HealthRecordHeaderview

- (IBAction)iconClick:(id)sender {
    BaseViewController *vc = (BaseViewController *)[self viewController];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.maxImagesCount = 1 ;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.cropRect = CGRectMake(0, (screenH-screenW)/2, screenW, screenW);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count) {
            [self.iconBtn setImage:photos[0] forState:UIControlStateNormal];
            if ([vc isKindOfClass:[HealthRecordsFirstViewController class]]) {
                ((HealthRecordsFirstViewController *)vc).iconIm = photos[0];
            }
        }
    }];
    [vc presentViewController:imagePickerVc animated:YES completion:nil];
}

@end
