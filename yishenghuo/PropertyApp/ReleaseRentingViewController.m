//
//  ReleaseRentingViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/12.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "ReleaseRentingViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "ZBLookImagesView.h"
#import "TZImagePickerController.h"
#import "HPGrowingTextView.h"
#import "SelectViewController.h"
@interface ReleaseRentingViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UITextViewDelegate,SelectViewControllerDelegate>{
    HPGrowingTextView *tfview;
}
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSArray *array1;
@property (nonatomic,strong)NSArray *keyArr;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *houseArray;
@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation ReleaseRentingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarTitle = @"发布租售信息";
    self.array1 = @[@"标    题:",@"联系人:",@"联系电话:",@"户  型：",@"房屋图片:",@"详细描述："];
    self.keyArr = @[@"title",@"username",@"mobile",@"housetype",@"imgurl",@"content"];
    
    [self upDateDetail];
    
    
}

//懒加载
-(NSMutableArray *)houseArray{
    
    if (_houseArray == nil) {
        _houseArray = [[NSMutableArray alloc]init];
    }
    
    return _houseArray;
    
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(NSMutableArray *)imageArray{
    
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    
    return _imageArray;
    
}
-(void)cancelClick:(UIButton *)btn{
    
    [[UserModel shareUserModel] removeAllUserInfo];
    [self showLogin:^(id response) {
    }];
    
    
}
-(void)createTableview{
    if (self.tableview == nil) {
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height - 64)];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.tableview registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetupPageViewController"];
        [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ReleaseRentingcell"];
        [self.view addSubview:self.tableview];
        UIView *foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];
    
        UIButton *submitBtn = [[UIButton alloc]init];
        [submitBtn setImage:[UIImage imageNamed:@"tijiao"] forState:UIControlStateNormal];
        if (self.dataArray.count) {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
            
            rightItem.tintColor = JHAssistColor;
            self.navigationItem.rightBarButtonItem = rightItem;
        }
        
        [submitBtn addTarget:self action:@selector(employsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
        [foootview addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(foootview.mas_centerY);
            make.centerX.equalTo(foootview.mas_centerX);
        }];
        self.tableview.tableFooterView = foootview;
        [self upDateRoomType];
        
    }

    
}
#pragma mark 删除
-(void)rightItemClick:(UIButton *)btn{
    [self upDateDelete];
}
#pragma mark 提交
-(void)employsubmitClick:(UIButton *)btn{
    UITextField *tf1 = [self.view viewWithTag: 200];
    UITextField *tf2 = [self.view viewWithTag: 201];
    UITextField *tf3 = [self.view viewWithTag: 202];

    if (tf1.text.length == 0) {
        [self presentLoadingTips:@"请输入标题"];
        return;
    }
    if (tf2.text.length == 0) {
        [self presentLoadingTips:@"请输入联系人"];
        return;
    }
    if (tf3.text.length == 0) {
        [self presentLoadingTips:@"请输入联系电话"];
        return;
    }
    [self upDateSubmit];

}
-(void)createCollectionview{
    
    if (self.collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake((SCREEN.size.width-60)/4, (SCREEN.size.width-60)/4);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 60) collectionViewLayout:flowLayout];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self tz_addPopGestureToView:self.collectionView];
        //注册Cell，必须要有
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.array1.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 4){
        if (self.imageArray.count) {
            return (SCREEN.size.width-60)/4 + 50;
        }else{
            return 50;
            
        }
    }else if(indexPath.row == 5){
        
        return 100;
        
    }
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *Identifier = [NSString stringWithFormat:@"ReleaseRentingcell_%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *sub in cell.contentView.subviews) {
        if (![sub isKindOfClass:[UITextField class]] && ![sub isKindOfClass:[HPGrowingTextView class]]) {
            [sub removeFromSuperview];
        }
    }
    UILabel *label = [[UILabel alloc]init];
    label.textColor = JHColor(53, 53, 53);
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.array1[indexPath.row];
    CGSize lbsize = [label.text selfadaption:15];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(10);
        make.height.offset(50);
        make.width.offset(lbsize.width + 5);
        
    }];
    if (indexPath.row < 4) {
        UITextField *tf = [cell viewWithTag:indexPath.row + 200];
        if (tf == nil) {
            tf = [[UITextField alloc]init];
            tf.tag =  indexPath.row + 200;
            tf.font = [UIFont systemFontOfSize:15];
            tf.textColor = JHsimpleColor;
            if (indexPath.row < 3) {
                tf.placeholder = @"请输入";
            }else{
                tf.text = @"请选择";
                 tf.enabled = NO;
                UIImageView *rightimage = [[UIImageView alloc]init];
                rightimage.image = [UIImage imageNamed:@"gerenzhongxinjiantou"];
                [cell.contentView addSubview:rightimage];
                [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.offset(-10);
                    make.centerY.equalTo(cell.mas_centerY);
                    
                }];
                
            }
            
            if (self.dataArray.count) {
                LFLog(@"dataArray:%@",self.dataArray);
                tf.text = [NSString stringWithFormat:@"%@",self.dataArray[0][self.keyArr[indexPath.row]]];
            }
        }
        [cell.contentView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(10);
            make.top.offset(0);
            make.bottom.offset(0);
            if (indexPath.row < 3) {
                make.right.offset(-10);
                
            }else{
                make.right.offset(-30);
            }
        }];
        
        
    }else if (indexPath.row == 4) {
        [self createCollectionview];
        if (self.imageArray.count) {
            self.collectionView.frame = CGRectMake(0, 50, SCREEN.size.width, (SCREEN.size.width-60)/4);
        }else{
            self.collectionView.frame = CGRectMake(0, 50, SCREEN.size.width, 0);

        }
        [cell.contentView addSubview:self.collectionView];
        UIButton *pickBtn = [[UIButton alloc]init];
        [pickBtn setImage:[UIImage imageNamed:@"shangchuanzhaopian"] forState:UIControlStateNormal];
        [pickBtn addTarget:self action:@selector(choseImage:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:pickBtn];
        [pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.equalTo(label.mas_centerY);
        }];

    }else if (indexPath.row == 5) {

        if (tfview == nil) {
            tfview = [[HPGrowingTextView alloc]init];
            tfview.placeholder = @"请输入内容";

            if (self.dataArray.count) {
                tfview.text = self.dataArray[0][self.keyArr[indexPath.row]];
            }
        }
        [cell.contentView addSubview:tfview];
        [tfview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(10);
            make.top.offset(10);
            make.bottom.offset(0);
            make.right.offset(-10);
            
        }];
        
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        SelectViewController *select = [[SelectViewController alloc]init];
        select.delegate = self;
        select.dataArray = self.houseArray;
        [self.navigationController pushViewController:select animated:YES];

    }else{

    }
}
- (void)SelectViewControllerDelegate:(NSString *)tyName tyId:(NSString *)tyId{

    UITextField *tf3 = [self.view viewWithTag: 203];
    tf3.text = tyName;
}
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.imageArray.count;
}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    if (self.imageArray.count <= 3) {
//        return 1;
//    }else{
//    return 2;
//
//    }
//
//}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.userInteractionEnabled = YES;
    imageview.contentMode = UIViewContentModeScaleToFill;
    if ([self.imageArray[indexPath.row] isKindOfClass:[UIImage class]]) {
        imageview.image = self.imageArray[indexPath.row];
    }else{
        [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    UIButton *btn = [[UIButton alloc]init];
    //btn.backgroundColor = [UIColor blueColor];
    [btn setImage:[UIImage imageNamed:@"shanchu_baoxiutupian"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [cell.contentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(5);
        make.right.offset(5);
        make.bottom.offset(5);
    }];
    
    //    if (!(indexPath.row == self.imageArray.count - 1)) {
    [cell.contentView addSubview:btn];
    //        [imageview addGestureRecognizer:tap];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.width.offset(25);
        make.height.offset(25);
    }];
    //    }
    
    
    
    
    btn.tag = indexPath.row + 22;
    
    
    return cell;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
    
}


-(void)buttonclick:(UIButton *)button{
    
    
    [self.imageArray removeObjectAtIndex:button.tag - 22];
    //    [self.imagedata removeObjectAtIndex:button.tag - 22];
    [self.tableview reloadData];
    [self.collectionView reloadData];
    
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"collectioncell:");
    NSMutableArray * muarr = [self.imageArray mutableCopy];
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:muarr currentIndex:indexPath.row];
    [broser show];
    
    
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

//选择tu
-(void)choseImage:(UIButton *)btn{
    if (self.imageArray.count <= 5) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"图库", nil];
        [sheet showInView:self.view];
    }else{
        [self alertController:@"提示" prompt:@"最多上传九张图片" sure:@"确定" cancel:nil success:^{
            
        } failure:^{
            
        }];
    }
    
    
    
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 2)return;
    
    UIImagePickerController *pic = [[UIImagePickerController alloc]init];
    pic.delegate = self;
    
    //允许编辑图片
    pic.allowsEditing = NO;
    
    
    if (buttonIndex == 0) {
        
        pic.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        imagePickerVc.maxImagesCount = 9 - self.imageArray.count;
        imagePickerVc.allowPickingOriginalPhoto = NO;

        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        return;
    }
    
    //显示控制器
    [self presentViewController:pic animated:YES completion:nil];
}
#pragma mark  图片选择成功的方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    for (UIImage *im in photos) {
        [self.imageArray addObject:im];
    }
    LFLog(@"imageArray:%@",self.imageArray);
//    [self.lookImagesView sImageArray:self.imageArray];
    //    [self.imageArray addObject:self.picture];
    [self.tableview reloadData];
    [self.collectionView reloadData];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //    LFLog(@"info%@",info);
    
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
   
    editimage = [editimage fixOrientation];
    [self.imageArray addObject:editimage];

    [self.tableview reloadData];
    [self.collectionView reloadData];
    //移除图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}

#pragma mark 户型
-(void)upDateRoomType{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }

    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ReleaseRentingLeaseUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"户型：%@",response);
        if ([str isEqualToString:@"1"]) {
            for (NSString *str in response[@"data"]) {
                [self.houseArray addObject:str];
            }
            if (self.houseArray.count) {
                UITextField *tf3 = [self.view viewWithTag: 203];
                tf3.text = self.houseArray[0];
            }
            
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark 详情
-(void)upDateDetail{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.poname) {
        [dt setObject:self.poname forKey:@"address"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ReleaseRentingDetailUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"详情：%@",response);
        if ([str isEqualToString:@"1"]) {
            NSDictionary *arr = response[@"data"];
            if (arr.count) {
                [self.dataArray addObject:arr];
            }
            if (self.dataArray.count) {
                for (NSDictionary *dic in response[@"data"][@"imgurl"]) {
                    [self.imageArray addObject:dic];
                }
            }
            
            [self createTableview];
            [self.tableview reloadData];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark 提交
-(void)upDateSubmit{
    UITextField *tf1 = [self.view viewWithTag: 200];
    UITextField *tf2 = [self.view viewWithTag: 201];
    UITextField *tf3 = [self.view viewWithTag: 202];
    UITextField *tf4 = [self.view viewWithTag: 203];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.poname) {
        [dt setObject:self.poname forKey:@"address"];
    }
    [dt setObject:tf1.text forKey:@"title"];
    [dt setObject:tf2.text forKey:@"username"];
    [dt setObject:tf3.text forKey:@"mobile"];
    [dt setObject:tf4.text forKey:@"housetype"];
    if (tfview.text.length) {
        [dt setObject:tfview.text forKey:@"content"];
    }
    if (self.dataArray.count) {
        [dt setObject:self.dataArray[0][@"id"] forKey:@"article_id"];
        NSMutableString *mstr = [NSMutableString string];
        [self.imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dt = (NSDictionary *)obj;
                LFLog(@"dt:%@",dt);
                [mstr appendFormat:@"%@",dt[@"id"]];
                if (idx < self.imageArray.count - 1) {
                    [mstr appendString:@","];
                }
            }
        }];
        if (mstr.length) {
            [dt setObject:mstr forKey:@"imgurl_id"];
        }
    }
    NSMutableArray *imArr = [[NSMutableArray alloc]init];
    [self.imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [imArr addObject:obj];
        }
    }];
    LFLog(@"提交dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ReleaseRentingSubmitUrl) params:dt body:imArr success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"提交：%@",response);
        if ([str isEqualToString:@"1"]) {

            [self presentLoadingTips:@"发布成功"];
            [self performSelector:@selector(goback) withObject:nil afterDelay:2.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark 删除
-(void)upDateDelete{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
//    if (self.poname) {
//        [dt setObject:self.poname forKey:@"address"];
//    }

    if (self.dataArray.count) {
        [dt setObject:self.dataArray[0][@"id"] forKey:@"id"];

    }

    LFLog(@"删除dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ReleaseRentinDeleteUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"删除：%@",response);
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"删除成功"];
            [self performSelector:@selector(goback) withObject:nil afterDelay:2.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"请求失败"];
    }];
    
    
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
}

@end

