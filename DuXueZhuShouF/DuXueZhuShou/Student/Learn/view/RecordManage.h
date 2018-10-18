//
//  RecordManage.h
//  RLAudioRecord
//
//  Created by admin on 2018/8/6.
//  Copyright © 2018年 Enorth.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol RecordPlayDelegate<NSObject>
@required
@optional
-(void)startPlayWithplayer:(AVPlayer *)player;
-(void)updateProgressWithPlayer:(AVPlayer *)player;
-(void)updateBufferProgress:(NSTimeInterval )totalBuffer;
-(void)player:(AVPlayer *)player changeRate:(float )rate;
-(void)changeNewPlayItem:(AVPlayer *)player;
-(void)failurePlayWithplayer:(NSString *)errorDes;//播放失败
-(void)FinishedPlayWithplayer;//播放完成
@end
@interface RecordManage : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(RecordManage);
@property (nonatomic, weak, nullable) id <RecordPlayDelegate> delegate;
@property (assign,nonatomic)NSInteger countDown;  //倒计时
@property (copy,nonatomic)void (^RecordResultBlock)(BOOL success);
-(instancetype)initCofig;//初始化
- (void)startRecord:(void (^)(BOOL success))result;
- (void)stopRecord;
- (void)PlayRecord;
//播放音频的方法
- (void)p_musicPlayerWithURL:(NSURL *)playerItemURL;
- (void)stopPlay;


/**
 *  移除定时器
 */
- (void)removeTimer;
//音频文件是否存在
+(BOOL) isFileExist;
//删除文件
-(void) DeleteFile;
@end
