//
//  InviteFriendsViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/9/9.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "JWCycleScrollView.h"
#import "UIButton+WebCache.h"
#import "CustomEditLabel.h"
#import "YYLabel.h"
#import "YYText.h"
@interface InviteFriendsViewController ()<JWCycleScrollImageDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UISearchBarDelegate>
@property (nonatomic,strong)NSMutableArray * cateArray;
@property (nonatomic,strong)NSDictionary * dataDt;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic,strong)NSMutableArray *pictureArr;//存储的信息数组
@property (nonatomic, strong) UIImageView * jwView;
@property (nonatomic, strong) UIImage * bannerImage;

@end
@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitle = @"邀请邻里";
    [self createTableview];
    [self setupRefresh];
    [self UploadDatalatesnotice];
    
}


- (NSMutableArray *)pictureArr
{
    if (!_pictureArr) {
        _pictureArr = [[NSMutableArray alloc]init];
    }
    return _pictureArr;
}

- (NSMutableArray *)cateArray
{
    if (!_cateArray) {
        _cateArray = [[NSMutableArray alloc]init];
    }
    return _cateArray;
}


-(void)createTableview{
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/2, (SCREEN.size.width-10)/2 * 408/370 + 10);
    //    flowLayout.minimumInteritemSpacing = 5;
    //    flowLayout.minimumLineSpacing = 1;
    //    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    if (self.collectionview == nil) {
        self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width,SCREEN.size.height ) collectionViewLayout:flowLayout];
    }
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor whiteColor]];
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"InviteFriendsViewCell"];
       [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    
    [self.view addSubview:self.collectionview];
    
    
}


-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index
{
    if (cycleScrollView==_jwView)
    {
        //判断网络状态
        if (![userDefaults objectForKey:NetworkReachability]) {
            [self presentLoadingTips:@"网络貌似掉了~~"];
        }else{
            LFLog(@"---点击了第%ld张图片", (long)index);
            
        }
        
    }
}



-(void)buttonClock:(UIButton *)btn{
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
    LFLog(@"%@",self.cateArray[btn.tag - 100]);
    
    
    
}

#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.cateArray.count;
    
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InviteFriendsViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor =[UIColor whiteColor];
    [cell.contentView removeAllSubviews];
    NSDictionary *dt = self.cateArray[indexPath.item];
    UIImageView *iconview = [[UIImageView alloc]init];
    
    [cell.contentView addSubview:iconview];
    NSString *url = [NSString string];
    if (IS_IPHONE_6_PLUS) {
        url = dt[@"imgurl3"];
    }else{
        
        url = dt[@"imgurl2"];
        
    }
    [iconview sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [iconview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(image.size.height);
        }];
    }];
    [iconview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.centerX.equalTo(cell.contentView.mas_centerX);
        
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.equalTo(iconview.mas_bottom);
        make.bottom.offset(0);
        
    }];
    
    label.text = dt[@"name"];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = JHColor(51, 51, 51);
    
    
    
    return cell;
}


// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionview) {
        return 0.001;
    }
    return 0.001;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataDt) {
        NSInteger type = -1;
        if ([self.cateArray[indexPath.row][@"code"] isEqualToString:@"wxhy"]) {
            type = 22;
        }else if ([self.cateArray[indexPath.row][@"code"] isEqualToString:@"wxpyq"]) {
            type = 23;
        }else if ([self.cateArray[indexPath.row][@"code"] isEqualToString:@"qqhy"]) {
            type = 24;
        }
        if (type > 0) {
            NSDictionary *dt = self.dataDt[@"share_info"];
            [[ShareSingledelegate sharedShareSingledelegate] ShareContentPlatformType:type content:dt[@"content"] title:dt[@"title"] url:dt[@"url"] image:dt[@"imgurl"]];
        }else{
            [self presentLoadingTips:@"暂不能分享！"];
        }
        
    }else{
        [self presentLoadingTips:@"暂不能分享！"];
    }

}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
//头视图尺寸
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.dataDt) {
        CGFloat HH = 0;
        if (self.bannerImage) {
             HH = SCREEN.size.width * self.bannerImage.size.height/self.bannerImage.size.width;
        }
        CGFloat ruleHeight = [self.dataDt[@"content"] selfadap:14 weith:20].height + 20;
        return CGSizeMake(SCREEN.size.width, HH + ruleHeight + 90);
    }
    return CGSizeZero;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake( (SCREEN.size.width - 2)/3, 89);
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionview) {
        UICollectionReusableView *reusableview = nil;
        NSLog(@"kind = %@", kind);
        if (kind == UICollectionElementKindSectionHeader){
            UIView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse" forIndexPath:indexPath];
            reusableview = (UICollectionReusableView *)headerV;
        }
        reusableview.backgroundColor = JHbgColor;
        [reusableview removeAllSubviews];
        if (self.dataDt) {
            CGFloat HH = 0;
            if (self.bannerImage) {
                 HH = SCREEN.size.width * self.bannerImage.size.height/self.bannerImage.size.width;
                if (_jwView == nil) {
                    _jwView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width,HH )];
                    
                    _jwView.contentMode = UIViewContentModeScaleAspectFill;
                    
                }
                _jwView.image = self.bannerImage;
                [reusableview addSubview:_jwView];
            }
            
            UIView *Vf = [[UIView alloc]initWithFrame:CGRectMake(0, HH, SCREEN.size.width, 45)];
            Vf.backgroundColor = [UIColor whiteColor];
            
            [reusableview addSubview:Vf];
            IndexBtn *but = [[IndexBtn alloc]init];
            if (self.dataDt[@"name"]) {
                [but sd_setImageWithURL:[NSURL URLWithString:self.dataDt[@"name"]] forState:UIControlStateNormal];
            }
            [Vf addSubview:but];
            [but mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.height.offset(40);
                make.centerX.equalTo(Vf.mas_centerX);
      
            }];
            YYLabel *ruleLabel = [[YYLabel alloc]init];
            ruleLabel.numberOfLines = 0;
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.dataDt[@"content"]];
            text.yy_font = [UIFont boldSystemFontOfSize:13];
            NSString *attstring = self.dataDt[@"referral_code"];
            NSRange range =[[text string]rangeOfString:attstring];
            text.yy_color = JHmiddleColor;
            [text yy_setFont:[UIFont systemFontOfSize:14] range:range];
            [text yy_setColor:JHAssistColor range:range];
            [text yy_setTextHighlightRange:range//设置点击的位置
                                     color:JHAssistColor
                           backgroundColor:[UIColor whiteColor]
                                 tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                     [ruleLabel becomeFirstResponder];
                                     UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyS:)];

                                     UIMenuController *menuC = [UIMenuController sharedMenuController];
                                     
                                     menuC.menuItems = @[menuItem1];
                                     menuC.arrowDirection = UIMenuControllerArrowUp;
                                     
                                     if (menuC.menuVisible) {
                                         //        NSLog(@"menuC.menuVisible    判断 --  %d", menuC.menuVisible);
                                         return ;
                                     }
                                     
                                     [menuC setTargetRect:ruleLabel.frame inView:Vf];
                                     [menuC setMenuVisible:YES animated:YES];
                                 }];
            ruleLabel.attributedText = text;

            CGFloat ruleHeight = [ruleLabel.text selfadap:14 weith:20].height + 20;
            [Vf addSubview:ruleLabel];
            [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(but.mas_bottom);
                make.left.offset(10);
                make.right.offset(-10);
                make.height.offset(ruleHeight);
            }];
            Vf.height = ruleHeight + 40;
            UIView *shareview = [[UILabel alloc]initWithFrame:CGRectMake(0, Vf.height + 10 + HH, SCREEN.size.width, 40)];
            shareview.backgroundColor = [UIColor whiteColor];
            [reusableview addSubview:shareview];
            UILabel *shareLb = [[UILabel alloc]initWithFrame:CGRectMake(10, Vf.height + 10 + HH, SCREEN.size.width - 20, 40)];
            shareLb.backgroundColor = [UIColor whiteColor];
            shareLb.font = [UIFont systemFontOfSize:14];
            shareLb.textColor = JHmiddleColor;
            shareLb.text = @"分享至：";
            [reusableview addSubview:shareLb];
        }

        reusableview.backgroundColor = JHbgColor;
        return reusableview;
    }else{
        return nil;
    }
    
}


#pragma mark - *************邀请好友*************
-(void)UploadDatalatesnotice{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,InviteFriendsUrl) params:dt success:^(id response) {
        LFLog(@"邀请好友：%@",response);
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.dataDt = response[@"data"];
            if ([response[@"data"][@"banner"] isKindOfClass:[NSString class]]) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:response[@"data"][@"banner"]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        self.bannerImage = image;
                        [self.collectionview reloadData];
                    }
                }];
            }
            [self.cateArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"][@"share"]) {
                [self.cateArray addObject:dt];
            }
            [self.collectionview reloadData];
            //                [self createUI];
        }else{
            
            
        }
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self UploadDatalatesnotice];
    }];
    //    _collectionview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //
    //        if ([self.more isEqualToString:@"0"]) {
    //            [self presentLoadingTips:@"没有更多商品了"];
    //            [self.collectionview.mj_footer endRefreshing];
    //        }else{
    //            self.page ++;
    //            [self UploadDatadynamic:self.page];
    //        }
    //
    //    }];
    
    
}



@end
