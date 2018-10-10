//
//  MineHeaderView.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MineHeaderView.h"
#import "UploadManager.h"
@implementation MineHeaderView
+ (MineHeaderView *)view{
    return (MineHeaderView *)[[[NSBundle mainBundle]loadNibNamed:@"MineHeaderView" owner:self options:nil]firstObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.iconIm.layer.cornerRadius = 38;
    self.iconIm.layer.masksToBounds = YES;
}
- (IBAction)iconClick:(id)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    //    imagePickerVc.autoDismiss = NO;
    imagePickerVc.maxImagesCount = 1;
    //        imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.cropRect = CGRectMake(0, (screenH-screenW)/2, screenW, screenW);
    imagePickerVc.didFinishPickingPhotosWithInfosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        if (!photos.count) {
            return ;
        }
        [AlertView showProgress];
        __block NSString *avatar = nil;
        [UploadManager uploadImagesWith:photos uploadFinish:^(NSArray *imFailArr) {
            if (imFailArr.count || avatar == nil) {
                [AlertView dismiss];
                [AlertView showMsg:@"图片上传失败！"];
            }else{
                __weak typeof(self) weakSelf = self;
                [LFLHttpTool post:NSStringWithFormat(SERVER_IP,ChangeAvatarUrl) params:@{@"avatar":avatar} viewcontrllerEmpty:nil success:^(id response) {
                    LFLog(@"头像上传:%@",response);
                    [AlertView dismiss];
                    NSNumber *code = @([response[@"code"] integerValue]);
                    if (code.integerValue == 1) {
                        weakSelf.iconIm.image = photos[0];
                    }
                    [AlertView showMsg:response[@"msg"]];
                    
                } failure:^(NSError *error) {
                    [AlertView dismiss];
                }];
            }
        } success:^(NSDictionary *imgDic, int idx) {
            avatar = imgDic[@"data"][@"url"];
        } failure:^(NSError *error, int idx) {
            
        }];
    } ;
    [[self viewController] presentViewController:imagePickerVc animated:YES completion:nil];
    
}

@end
