//
//  InforViewController.m
//  shop
//
//  Created by wwzs on 16/4/20.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//修改备份名字：新版iOS绵阳物业app头条修改备份17/06/07

#import "HeadlineViewController.h"
#import "NSString+selfSize.h"
#import "STImageVIew.h"
#import "STPhotoBroswer.h"

#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "Label.h"
@interface HeadlineViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong)UIScrollView *scrollview;

@property(nonatomic,strong)UIImageView *backview;

@property(nonatomic,strong)Label *titlelabel;
@property(nonatomic,strong)UILabel *namelabel;
@property(nonatomic,strong)UILabel *timelabel;
@property(nonatomic,strong)UIImageView *vline;
@property(nonatomic,strong)UIImageView *pitureImage;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong) STPhotoBroswer * brose;
@property(nonatomic,strong)NSMutableArray *imageArr;

@end

@implementation HeadlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    LFLog(@"_dataArrray:%@",_dataArrray);
    if (![[_dataArrray objectForKey:@"imgurl"] isKindOfClass:[NSNull class]]) {
        for (NSString *image in [_dataArrray objectForKey:@"imgurl"]) {
            [self.imageArr addObject:image];
        }
    }
    
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height)];
    self.scrollview.delegate = self;
    
    self.scrollview.backgroundColor = JHColor(185, 225, 228);
    //    _scrollview.pagingEnabled = NO;
    
    self.backview = [[UIImageView alloc]init];
    self.backview.image = [UIImage imageNamed:@"jinritoutiaojuxing"];
    self.backview.userInteractionEnabled = YES;
    //    self.backview.layer.cornerRadius = 15;
    //    self.backview.layer.masksToBounds = YES;
    [_scrollview addSubview:_backview];
    [self.view addSubview:self.scrollview];
    [self createUI];
}
-(NSDictionary *)dataArrray{
    
    if (_dataArrray == nil) {
        _dataArrray = [[NSDictionary alloc]init];
    }
    
    return _dataArrray;
}

-(NSMutableArray *)imageArr{
    
    if (_imageArr == nil) {
        _imageArr = [[NSMutableArray alloc]init];
    }
    
    return _imageArr;
}
-(void)createUI{
    
    self.titlelabel = [[Label alloc]init];
    _titlelabel.text = _dataArrray[@"in_title"];
    _titlelabel.BoldFont = 20;
    _titlelabel.textColor = [UIColor whiteColor];
    _titlelabel.Strokecolor = JHColor(61, 145, 143);
    _titlelabel.shadowcolor = JHColor(61, 145, 143);
    _titlelabel.numberOfLines = 0;
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    CGSize titlesize = [_titlelabel.text selfadap:20 weith:30];
    [_scrollview addSubview:_titlelabel];
    _titlelabel.frame = CGRectMake(15, 15, SCREEN.size.width - 30, titlesize.height + 5);
    
    double times = [self.dataArrray[@"add_time"] doubleValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *time = [formatter stringFromDate:date];
    LFLog(@"%@",time);
    self.namelabel = [[UILabel alloc]init];
    _namelabel.text =self.dataArrray[@"in_bedate"];
    _namelabel.font = [UIFont systemFontOfSize:14];
    _namelabel.textColor = JHColor(151, 151, 151);
    
    CGSize namesize = [_namelabel.text selfadaption:15];
    [_backview addSubview:_namelabel];
    [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-10);
        make.width.offset(namesize.width + 10);
        make.bottom.offset(-30);
        make.height.offset(15);
        
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = _dataArrray[@"in_info"];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = JHColor(51, 51, 51);
    [_contentLabel NSParagraphStyleAttributeName:20];
    CGSize contentsize = [_contentLabel.text selfadap:15 weith:60 Linespace:20];
    [_backview addSubview:_contentLabel];
    
    
    if (_imageArr.count > 0) {
        
        _pitureImage = [[UIImageView alloc]init];
        
        [_pitureImage sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagetap:)];
        _pitureImage.userInteractionEnabled = YES;
        [_pitureImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _pitureImage.contentMode =  UIViewContentModeScaleAspectFill;
        _pitureImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _pitureImage.clipsToBounds  = YES;
        [_pitureImage addGestureRecognizer:tap];
        [_backview addSubview:_pitureImage];
        [_pitureImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(15);
            make.right.offset(-15);
            make.top.offset(15);
            //            make.height.offset(capHeight);
            //            make.width.offset(capWidth);
            make.height.mas_equalTo(_pitureImage.mas_width).multipliedBy(0.5);
            
        }];
        UILabel *countlabel = [[UILabel alloc]init];
        countlabel.font = [UIFont systemFontOfSize:12];
        countlabel.text = [NSString stringWithFormat:@"共%d张",(int)_imageArr.count];
        [_backview addSubview:countlabel];
        [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.top.equalTo(_pitureImage.mas_bottom).offset(5);
            make.height.offset(14);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(15);
            make.right.offset(-15 );
            make.top.equalTo(_pitureImage.mas_bottom).offset(15);
            make.height.offset(contentsize.height + 35);
            
        }];
        _backview.frame = CGRectMake(15, titlesize.height + 30, SCREEN.size.width -30 , contentsize.height + SCREEN.size.width/2 + 120 );
        _scrollview.contentSize = CGSizeMake(0,  contentsize.height + SCREEN.size.width/2 + 150 + titlesize.height + 130);
    }else{
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(15);
            make.right.offset(-15 );
            make.top.offset(15);
            make.height.offset(contentsize.height + 35);
            
        }];
        _backview.frame = CGRectMake(15,  titlesize.height + 30, SCREEN.size.width-30, contentsize.height  + 105 );
        _scrollview.contentSize = CGSizeMake(0,  contentsize.height + 135 + titlesize.height + 130);
        
    }
    CGFloat consize = _backview.frame.size.height + titlesize.height + 30 + 130;
    UIImageView *imaeveiw = [[UIImageView alloc]init];
    imaeveiw.image = [UIImage imageNamed:@"dibutupian"];
    [_scrollview addSubview:imaeveiw];
    [imaeveiw mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if ((consize)< SCREEN.size.height) {
            make.bottom.offset(SCREEN.size.height - 64);
        }else{
            make.bottom.equalTo(_backview.mas_bottom).offset(130);
        }
        make.width.offset(SCREEN.size.width);
        make.centerX.equalTo(_backview.mas_centerX);
    }];
    self.brose = [[STPhotoBroswer alloc]initWithImageArray:self.imageArr currentIndex:0];
    
    
    
}
//图片点击事件
-(void)imagetap:(UITapGestureRecognizer *)tap{
    
    LFLog(@"点击图片");
    
    [_brose show];
    
}
@end
