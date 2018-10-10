
//
//  GradeListViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "GradeListViewController.h"
#import "ImageLabelCollectionViewCell.h"
@interface GradeListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray * bookArr;
@property (nonatomic,strong)UICollectionView * collectionview;

@end

@implementation GradeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"等级说明";
    [self.view addSubview:self.collectionview];
    [self updata];
    
}

-(void)updata{
    
}



- (NSMutableArray *)bookArr
{
    if (!_bookArr) {
        _bookArr = [[NSMutableArray alloc]init];
        NSArray *arr= @[@{@"name":@"二等兵",@"imgurl":@"edb"},
                        @{@"name":@"一等兵",@"imgurl":@"ydb"},
                        @{@"name":@"上等兵",@"imgurl":@"sdb"},
                        @{@"name":@"下士",@"imgurl":@"xs"},
                        @{@"name":@"中士",@"imgurl":@"zs"},
                        @{@"name":@"上士",@"imgurl":@"ss"},
                        @{@"name":@"少尉",@"imgurl":@"sw1"},
                        @{@"name":@"中尉",@"imgurl":@"zw"},
                        @{@"name":@"上尉",@"imgurl":@"sw"},
                        @{@"name":@"少校",@"imgurl":@"sx1"},
                        @{@"name":@"中校",@"imgurl":@"zx"},
                        @{@"name":@"上校",@"imgurl":@"sx"},
                        @{@"name":@"少将",@"imgurl":@"sj"},
                        @{@"name":@"中将",@"imgurl":@"zj"},
                        @{@"name":@"上将",@"imgurl":@"shj"},
                        @{@"name":@"元帅",@"imgurl":@"ys"}];
        for (NSDictionary *temdt in arr) {
            ImLbModel *model = [ImLbModel mj_objectWithKeyValues:temdt];
            [_bookArr addObject:model];
        }
    }
    return _bookArr;
}


-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((screenW - 51) /3, 100);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenW,screenH ) collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        [_collectionview registerNib:[UINib nibWithNibName:@"ImageLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageLabelCollectionViewCell"];
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
    static NSString * CellIdentifier = @"ImageLabelCollectionViewCell";
    ImageLabelCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = self.bookArr[indexPath.item];
    return cell;
}
@end
