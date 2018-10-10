//
//  UploadManager.m
//  UploadImages
//
//  Created by yabei on 16/7/7.
//  Copyright © 2016年 com.bodi.merchant. All rights reserved.
//

#import "UploadManager.h"
#import "NSURLSessionWrapperOperation.h"
#import "AFNetworking.h"
#import "NSString+Hash.h"
@interface UploadManager ()
{
    NSMutableArray *imagesArr;
}
@end

@implementation UploadManager

//gcd上传
+ (void)commentReqWithImages:(NSArray *)imageArr
                      params:(NSMutableDictionary *)pramaDic
                     success:(void (^)(id JSON))success
                     failure:(void (^)(NSError *))failure
{
    
    __block NSInteger imgBackCount = 0;
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < imageArr.count; i++) {
        
        dispatch_group_enter(group);
        
        NSURLSessionUploadTask* uploadTask = [UploadManager uploadTaskWithImage:imageArr[i] completion:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
//                @synchronized () {  NSMutableArray 是线程不安全的，所以加个同步锁
//                    
//                }
                imgBackCount++;
                if (imgBackCount == imageArr.count) {
                    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                        
                        //图片上传之后的操作
                        
                    });

                }
                
                //处理成功返回数据
                
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
}


+ (void)uploadImagesWith:(NSArray *)images uploadFinish:(uploadCallBlock)finish success:(uploadSuccess)success failure:(uploadFailure)failure
{
    
//自己在处理operation上传多图的时候， 可能会出现bug   completionOperation在最后一个uploadOperation还没完成时就执行了   会导致少一张图    暂时没找到原因；希望有大神能够找出问题所在
// （GCD和NSOperation之间的优缺点比较就不提了）

//很坑,最终测试  两个方法都没有问题  主要还是大量的异步操作.  导致 最后一个task回调回来的时候  completion的依赖触发,就执行完成回调了,这时候最后一个图上传的结果才回来
//针对这个大坑,只能在图片上传task里面  进行判断  成功个数count和数组个数相等  再执行fisish
    
    __block NSMutableArray *marr = [NSMutableArray array];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    queue.maxConcurrentOperationCount = 5;//control it yourself
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{ // 回到主线程执行，方便更新 UI 等
            NSLog(@"上传完成!");
            
            finish(marr);
        }];
    }];
    
    __block NSInteger imgBackCount = 0;
    for (NSInteger i = 0; i < images.count; i++) {
        
        NSURLSessionUploadTask* uploadTask = [UploadManager uploadTaskWithImage:images[i] completion:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                @synchronized (marr) {
                    NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                    failure(error, (int)i);
                    [marr addObject:images[i]];
                }

            } else {
                NSLog(@"第 %d 张图片上传成功: ", (int)i + 1);
                imgBackCount++;
                @synchronized (images) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    
                    NSError *error = nil;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                    LFLog(@"dic:%@",dic);
                    NSString *str = [NSString stringWithFormat:@"%@",dic[@"code"]];
                    if ([str isEqualToString:@"1"] ) {
                        success(dic, (int)i);
                    }else{
                        @synchronized (marr) {
                            NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                            failure(error, (int)i);
                            [marr addObject:images[i]];
                        }
                    }
                    
                    /**
                     *  这里有i这个参数  所以图片成功返回数据的先后顺序是有序的  怎么做靠你自己拉
                     */
                    
                }
                
                if (imgBackCount == images.count) {
                    [queue addOperation:completionOperation];
                }
                
            }
        }];
        
        //重写系统NSOperation 很关键  你可以直接copy
        NSURLSessionWrapperOperation *uploadOperation = [NSURLSessionWrapperOperation operationWithURLSessionTask:uploadTask];
        [completionOperation addDependency:uploadOperation];
        [queue addOperation:uploadOperation];
        
    }
}

#pragma mark - util

+ (NSURLSessionUploadTask*)uploadTaskWithImage:(id)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    
    @autoreleasepool {
        NSString *type = @"1";
        if ([image isKindOfClass:[UIImage class]]) {
            type = @"1";
        }else if ([image isKindOfClass:[NSString class]]){
            type = @"2";
        }
        // 构造 NSURLRequest
        NSError* error = NULL;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:NSStringWithFormat(SERVER_IP,PictureUploadUrl) parameters:@{@"type":type} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //转换data的方法 仅适用于😈楼主😈本人
//            NSData *imageData = [image imageByScalingToWithSize:PIC_MAX_WIDTH];
            if ([image isKindOfClass:[UIImage class]]) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
            }else if ([image isKindOfClass:[NSString class]]){
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:image] name:@"file" error:nil];
            }

        } error:&error];
        
        
        [request setValue:@"iphone" forHTTPHeaderField:@"XX-Device-Type"];
        [request setValue:AppBuildVersion forHTTPHeaderField:@"XX-APP-VERSION"];
        UserModel *model = [UserUtils getUserInfo];
        if (model && model.token) {
            [request setValue:model.token forHTTPHeaderField:@"XX-Token"];
        }
        //加密
        NSInteger timeStamp = [[NSDate date]timeIntervalSince1970];
        [request setValue:[NSString stringWithFormat:@"%ld",(long)timeStamp] forHTTPHeaderField:@"XX-CHECK-TIME"];
        NSString *mdstr = [NSString stringWithFormat:@"%@%@",[lStringFormart(@"%ld", (long)timeStamp) MD5ForLower32Bate].lowercaseString,MD5String];
        NSString *checkToken = [NSString stringWithFormat:@"%@%@",MD5Header,[mdstr MD5ForLower32Bate].lowercaseString];
        [request setValue:checkToken forHTTPHeaderField:@"XX-CHECK-TOKEN"];
        // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        AFHTTPResponseSerializer *responseSerializer = manager.responseSerializer;
        NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"text/plain"];
        manager.responseSerializer = responseSerializer;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        } completionHandler:completionBlock];
        
        return uploadTask;
        
    }
}

@end
