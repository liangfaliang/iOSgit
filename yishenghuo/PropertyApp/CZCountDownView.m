//
//  CZCountDownView.m
//  countDownDemo
//
//  Created by 孔凡列 on 15/12/9.
//  Copyright © 2015年 czebd. All rights reserved.
//

#import "CZCountDownView.h"
#import "UIView+Extension.h"
// label数量
#define labelCount 4
#define separateLabelCount 2
#define padding 5
@interface CZCountDownView (){
    // 定时器
    NSTimer *timer;
    dispatch_source_t _timer;
}
@property (nonatomic,strong)NSMutableArray *timeLabelArrM;
@property (nonatomic,strong)NSMutableArray *separateLabelArrM;
// day
@property (nonatomic,strong)UILabel *dayLabel;
// hour
@property (nonatomic,strong)UILabel *hourLabel;
// minues
@property (nonatomic,strong)UILabel *minuesLabel;
// seconds
@property (nonatomic,strong)UILabel *secondsLabel;
@end

@implementation CZCountDownView
// 创建单例
+ (instancetype)shareCountDown{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CZCountDownView alloc] init];
        
    });
    return instance;
}

+ (instancetype)countDown{
    return [[self alloc] init];
}

-(instancetype)init{
    if (self = [super init]) {
        [self createSubview];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        
    }
    return self;
}


-(void)createSubview{
    //        [self addSubview:self.dayLabel];
    [self addSubview:self.hourLabel];
    [self addSubview:self.minuesLabel];
    [self addSubview:self.secondsLabel];
    
    for (NSInteger index = 0; index < separateLabelCount; index ++) {
        UILabel *separateLabel = [[UILabel alloc] init];
        separateLabel.text = @":";
        separateLabel.textColor = [UIColor redColor];
        separateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:separateLabel];
        separateLabel.frame = CGRectMake(index ==  0 ? 45 : 90, 0, 15, self.frame.size.height);
        [self.separateLabelArrM addObject:separateLabel];
    }
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName{
    _backgroundImageName = backgroundImageName;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
//    [self bringSubviewToFront:imageView];
}
-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}
// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    _timestamp = timestamp;
//    if (_timestamp != 0) {
//        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
//    }
    
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate_tomorrow = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDate *startDate = [NSDate date];
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.timerStopBlock();
                        self.dayLabel.text = @"";
                        self.hourLabel.text = @"00";
                        self.minuesLabel.text = @"00";
                        self.secondsLabel.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        self.dayLabel.text = @"";
                    }
                    int hours = (int)(timeout/3600);
                    int minute = (int)(timeout-days*24*3600-((timeout-days*24*3600)/3600)*3600)/60;
                    int second = timeout-days*24*3600-((timeout-days*24*3600)/3600)*3600-minute*60;
//                    int hours = (int)((timeout-days*24*3600)/3600);
//                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
//                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            self.dayLabel.text = @"0天";
                        }else{
                            self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
                        }
//                        self.dayLabel.width = [self.dayLabel.text selfadaption:_font].width + 10;
                        if (hours<10) {
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                        }
//                        self.hourLabel.width = [self.dayLabel.text selfadaption:_font].width + 10;
                        if (minute<10) {
                            self.minuesLabel.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuesLabel.text = [NSString stringWithFormat:@"%d",minute];
                        }
//                        self.minuesLabel.width = [self.dayLabel.text selfadaption:_font].width + 10;
                        if (second<10) {
                            self.secondsLabel.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondsLabel.text = [NSString stringWithFormat:@"%d",second];
                        }
//                        self.secondsLabel.width = [self.dayLabel.text selfadaption:_font].width + 10;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
    
}

-(void)timer:(NSTimer*)timerr{
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    if (_timestamp == 0) {
        [timer invalidate];
        timer = nil;
        // 执行block回调
        self.timerStopBlock();
    }
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
//    NSLog(@"%zd日:%zd时:%zd分:%zd秒",day,hour,minute,second);
    
    self.dayLabel.text = [NSString stringWithFormat:@"%zd天",day];
    self.hourLabel.text = [NSString stringWithFormat:@"%zd时",hour];
    self.minuesLabel.text = [NSString stringWithFormat:@"%zd分",minute];
    self.secondsLabel.text = [NSString stringWithFormat:@"%zd秒",second];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    // 获得view的宽、高
//    CGFloat viewW = self.frame.size.width;
//    CGFloat viewH = self.frame.size.height;
//    // 单个label的宽高
//    CGFloat labelW = (viewW - (labelCount - 1) * 5) / labelCount ;
//    CGFloat labelH = viewH;
//    self.dayLabel.frame = CGRectMake(0, 0, labelW, labelH);
//    self.hourLabel.frame = CGRectMake(labelW + 5, 0, labelW, labelH);
//    self.minuesLabel.frame = CGRectMake(2 * labelW + 10 , 0, labelW, labelH);
//    self.secondsLabel.frame = CGRectMake(3 * labelW + 15, 0, labelW, labelH);
    for (NSInteger index = 0; index < self.separateLabelArrM.count ; index ++) {
        UILabel *separateLabel = self.separateLabelArrM[index];
        separateLabel.height = self.bounds.size.height;
    }
    _hourLabel.frame = CGRectMake(0, 0, 45, 25);
     _minuesLabel.frame = CGRectMake(60, 0, 30, self.bounds.size.height);
    _secondsLabel.frame = CGRectMake(105, 0, 30, self.bounds.size.height);


}

#pragma mark - setter & getter

- (NSMutableArray *)timeLabelArrM{
    if (_timeLabelArrM == nil) {
        _timeLabelArrM = [[NSMutableArray alloc] init];
    }
    return _timeLabelArrM;
}

- (NSMutableArray *)separateLabelArrM{
    if (_separateLabelArrM == nil) {
        _separateLabelArrM = [[NSMutableArray alloc] init];
    }
    return _separateLabelArrM;
}

- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] init];
//        _dayLabel.frame = CGRectMake(0, 0, labelW, self.frame.size.height);

        _dayLabel.textAlignment = NSTextAlignmentCenter;
//        _dayLabel.backgroundColor = [UIColor grayColor];
    }
    return _dayLabel;
}

- (UILabel *)hourLabel{
    if (_hourLabel == nil) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.layer.cornerRadius = 5;
        _hourLabel.layer.masksToBounds = YES;
//        _hourLabel.backgroundColor = [UIColor redColor];
    }
    return _hourLabel;
}

- (UILabel *)minuesLabel{
    if (_minuesLabel == nil) {
        _minuesLabel = [[UILabel alloc] init];
        _minuesLabel.layer.cornerRadius = 5;
        _minuesLabel.layer.masksToBounds = YES;

        _minuesLabel.textAlignment = NSTextAlignmentCenter;
//        _minuesLabel.backgroundColor = [UIColor orangeColor];
    }
    return _minuesLabel;
}

- (UILabel *)secondsLabel{
    if (_secondsLabel == nil) {
        _secondsLabel = [[UILabel alloc] init];
        _secondsLabel.layer.cornerRadius = 5;
        _secondsLabel.layer.masksToBounds = YES;
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
//        _secondsLabel.backgroundColor = [UIColor yellowColor];
    }
    return _secondsLabel;
}

-(void)setBackColor:(UIColor *)backColor{
    _backColor = backColor;
    _secondsLabel.backgroundColor = _backColor;
    _minuesLabel.backgroundColor = _backColor;
    _hourLabel.backgroundColor = _backColor;
    _dayLabel.backgroundColor = _backColor;
}
-(void)setFont:(NSInteger)font{
    _font =font;
    _secondsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:_font];
    _minuesLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:_font];
    _hourLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:_font];
    _dayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:_font];
}

-(void)setTextColor:(UIColor *)textColor{

    _textColor = textColor;
    _secondsLabel.textColor = _textColor;
    _minuesLabel.textColor = _textColor;
    _hourLabel.textColor = _textColor;
    _dayLabel.textColor = _textColor;
    
}

@end
