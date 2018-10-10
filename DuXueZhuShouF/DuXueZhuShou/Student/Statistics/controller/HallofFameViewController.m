
//
//  HallofFameViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HallofFameViewController.h"
#import "HallofFameCollectionViewCell.h"
#import "GradeAnalysisViewController.h"
@interface HallofFameViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSMutableArray * bookArr;
@property (nonatomic,strong)UICollectionView * collectionview;

@end

@implementation HallofFameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"光荣榜";
    self.view.backgroundColor = [UIColor colorFromHexCode:@"FEF6E8"];
    [self.view addSubview:self.collectionview];
    [self createHeaderFooter];
    [self updata];
    
}
-(void)createHeaderFooter{
    for (int i = 0 ; i < 2; i ++) {
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:i == 0 ? @"grbs" : @"grbx"]];
        CGFloat hh = imageview.image.size.height/imageview.image.size.width * screenW;
        imageview.frame = CGRectMake(0, i == 0 ? SAFE_NAV_HEIGHT : screenH - hh, screenW, hh);
        [self.view addSubview:imageview];
        self.collectionview.contentInset = UIEdgeInsetsMake(i == 0 ? hh : self.collectionview.contentInset.top, 0, i == 1 ? hh : 0,  0);
    }
    
}
-(void)updata{
    [self getData];
}

- (NSMutableArray *)bookArr
{
    if (!_bookArr) {
        _bookArr = [[NSMutableArray alloc]init];
    }
    return _bookArr;
}


-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((screenW - 141) /3, (screenW - 141) /3);
        flowLayout.minimumInteritemSpacing = 30;
        flowLayout.minimumLineSpacing = 20;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 40, 0, 40);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenW,screenH) collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        _collectionview.backgroundColor = [UIColor colorFromHexCode:@"FEF6E8"];
        [_collectionview registerNib:[UINib nibWithNibName:@"HallofFameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HallofFameCollectionViewCell"];
        //        [_AcCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ActivityHomeCollectionViewCell"];
        
    }
    return _collectionview;
}




#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bookArr.count;
    
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"HallofFameCollectionViewCell";
    HallofFameCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.picture.layer.cornerRadius = (screenW - 141) /6;
    cell.picture.layer.masksToBounds = YES;
    [cell.picture sd_setImageWithURL:[NSURL URLWithString:self.bookArr[indexPath.row][@"avatar"]] placeholderImage:PlaceholderImage] ;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GradeAnalysisViewController *vc  =[[GradeAnalysisViewController alloc]init];
    vc.student_id = self.bookArr[indexPath.row][@"student_id"];
    vc.TitleName = @"成绩曲线图";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取列表
- (void)getData{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,GradeInsSetRoleSetRoleUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] ) {
            [self.bookArr removeAllObjects];

            for (NSDictionary *temDt in response[@"data"]) {
                [self.bookArr addObject:temDt];
                [self.bookArr addObject:temDt];
                [self.bookArr addObject:temDt];
                [self.bookArr addObject:temDt];
                [self.bookArr addObject:temDt];
            }
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
        [self.collectionview reloadData];
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
}
@end
