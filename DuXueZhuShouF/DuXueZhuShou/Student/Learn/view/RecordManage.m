//
//  RecordManage.m
//  RLAudioRecord
//
//  Created by admin on 2018/8/6.
//  Copyright © 2018年 Enorth.com. All rights reserved.
//

#import "RecordManage.h"


@interface RecordManage()<AVAudioRecorderDelegate>{
//    NSString *filePath;
    NSTimer *_timer; //定时器
}
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) AVPlayer *player; //播放器
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址
@property (nonatomic ,strong)  id timeObserver;
@end

@implementation RecordManage
SYNTHESIZE_SINGLETON_FOR_CLASS(RecordManage);
-(instancetype)initCofig{
    RecordManage *rm = [[RecordManage alloc]init];
    self = rm;
    if (self ) {
        
        self.countDown = 1;
        //1.获取沙盒地址
        //2.获取文件路径
        self.recordFileUrl = [NSURL fileURLWithPath:RecordAudioFilePath];
        [self DeleteFile];
        AVAudioSession *session =[AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if (session == nil) {
            NSLog(@"Error creating session: %@",[sessionError description]);
        }else{
            [session setActive:YES error:nil];
        }
        self.session = session;
        //设置参数
        NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                       [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                       // 音频格式
                                       [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                       //采样位数  8、16、24、32 默认为16
                                       [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                       // 音频通道数 1 或 2
                                       [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                       //录音质量
                                       [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                       nil];
        
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
        _recorder.delegate = self;
    }
    return self;
}
- (void)startRecord:(void (^)(BOOL success))result{
    NSLog(@"开始录音");
    if (_recorder) {
        _countDown = 1;
        [self addTimer];
        if (result) {
            result(YES);
        }
        if ([_recorder isRecording]) {
            [_recorder stop];
        }
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopRecord];
        });
    }else{
        if (result) {
            result(NO);
        }
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
    
}


- (void)stopRecord{
    [self removeTimer];
    NSLog(@"停止录音");
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
//    NSFileManager *manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:filePath]){
//        _noticeLabel.text = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",COUNTDOWN - (long)countDown,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0];
        
//    }else{
//        _noticeLabel.text = @"最多录60秒";
//    }
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)refreshLabelText{
    _countDown ++;

}
//音频文件是否存在
+(BOOL) isFileExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:RecordAudioFilePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}
//删除文件
-(void) DeleteFile
{
    if ([RecordManage isFileExist]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:RecordAudioFilePath error:nil];
        NSLog(@"已删除");
    }
}
-(void)dealloc{
    [self p_currentItemRemoveObserver];
    [self DeleteFile];
}
#pragma mark - 录音机代理方法

/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音完成!");
    if (self.RecordResultBlock) {
        self.RecordResultBlock(flag);
    }
    [self removeTimer];
}
#pragma  mark  音频播放
- (AVPlayer *)player {
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0; // 默认最大音量
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord
                 withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                       error:nil];
    }
    return _player;
}
- (void)PlayRecord{
    
    NSLog(@"播放录音");
    [self.recorder stop];
    [self p_musicPlayerWithURL:[NSURL fileURLWithPath:RecordAudioFilePath]];
//    if ([self.player isPlaying])return;
//    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
//    NSLog(@"%li",self.player.data.length/1024);
//    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [self.player play];
}
//停止播放
-(void)stopPlay{
    if (self.player) {
        [self.player pause];
        [self.player.currentItem cancelPendingSeeks];
        [self.player.currentItem.asset cancelLoading];
        [self p_currentItemRemoveObserver];
        self.player = nil;
    }
}
//播放音频的方法
- (void)p_musicPlayerWithURL:(NSURL *)playerItemURL{
    // 移除监听
    [self p_currentItemRemoveObserver];
    // 创建要播放的资源
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:playerItemURL];
    // 播放当前资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    // 添加观察者
    [self p_currentItemAddObserver];
}
- (void)p_currentItemRemoveObserver {
    if (self.player) {
        [self.player.currentItem removeObserver:self  forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        if (self.timeObserver) {
            [self.player removeTimeObserver:self.timeObserver];
            self.timeObserver = nil;
        }
        
    }

}

- (void)p_currentItemAddObserver {
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    
    //监控缓冲加载情况属性
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    //监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //监控时间进度
    WEAKSELF;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        @strongify(self);
        // 在这里将监听到的播放进度代理出去，对进度条进行设置
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(updateProgressWithPlayer:)]) {
            [weakSelf.delegate updateProgressWithPlayer:weakSelf.player];
        }
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                // 开始播放
                NSLog(@"开始播放");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.player play];
                });
                
//                [self play];
                // 代理回调，开始初始化状态
                if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayWithplayer:)]) {
                    [self.delegate startPlayWithplayer:self.player];
                }
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(failurePlayWithplayer:)]) {
                    [self.delegate failurePlayWithplayer:@"加载失败"];
                }
                [AlertView showMsg:@"加载失败"];
                NSLog(@"加载失败");

            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(failurePlayWithplayer:)]) {
                    [self.delegate failurePlayWithplayer:@"未知资源"];
                }
                [AlertView showMsg:@"未知资源"];
                NSLog(@"未知资源");

            }
                break;
            default:
                break;
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        //本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f",totalBuffer);
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateBufferProgress:)]) {
            [self.delegate updateBufferProgress:totalBuffer];
        }
        
    } else if ([keyPath isEqualToString:@"rate"]) {
        // rate=1:播放，rate!=1:非播放
        float rate = self.player.rate;
        if (self.delegate && [self.delegate respondsToSelector:@selector(player:changeRate:)]) {
            [self.delegate player:self.player changeRate:rate];
        }
    } else if ([keyPath isEqualToString:@"currentItem"]) {
        NSLog(@"新的currentItem");
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeNewPlayItem:)]) {
            [self.delegate changeNewPlayItem:self.player];
        }
    }
}

- (void)playbackFinished:(NSNotification *)notifi {
    NSLog(@"播放完成");
    if (self.delegate && [self.delegate respondsToSelector:@selector(FinishedPlayWithplayer)]) {
        [self.delegate FinishedPlayWithplayer];
    }
}


@end
