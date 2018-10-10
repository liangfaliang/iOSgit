//
//  ShopEvaluateViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/9.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopEvaluateViewController.h"
#import "starView.h"
#import "HPGrowingTextView.h"
#import "ZBLookImagesView.h"
#import "TZImagePickerController.h"
@interface ShopEvaluateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    HPGrowingTextView *textview;
    starView *sta;
}
@property (nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UICollectionView  *collectionview;
@property(nonatomic,strong)NSMutableArray  *imageArray;
@property(nonatomic,strong)UIImage  *picture;
@property (nonatomic, strong) ZBLookImagesView *lookImagesView;
@end

@implementation ShopEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"评价晒单";
    [self createUI];
    self.picture = [UIImage imageNamed:@"shaitu"];
    [self.imageArray addObject:self.picture];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    rightBtn.tintColor = JHshopMainColor;
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(NSMutableArray *)imageArray{
    
    if (_imageArray == nil) {
        _imageArray  = [[NSMutableArray alloc]init];
    }
    
    
    return _imageArray;
}
-(void)rightBtnClick:(UIBarButtonItem *)btn{
    LFLog(@"evnet:%ld",(long)sta.count);
    if (textview.text.length == 0) {
        [self presentLoadingTips:@"请您输入评论内容"];
        return;
    }
    [self presentLoadingStr:@"请稍后"];
    [self UploadDatagoodsEvaluation];
}

-(void)BtnClick:(UIButton *)btn event:(id)evnet{
    LFLog(@"evnet:%@",evnet);

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count) {
        return self.dataArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *Identifier = [NSString stringWithFormat:@"confirmCell%ld",(long)indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
        return cell;
    
    
}

-(void)createUI{

    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 74, 80, 80)];
    imageview.backgroundColor =[UIColor grayColor];
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self.view addSubview:imageview];
    
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(100, 86, 40, 21)];
    lb.text = @"评分";
    [self.view addSubview:lb];
    
    sta = [[starView alloc] initWithFrame:CGRectMake(140, 86, 150, 150)];
    sta.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sta];
    [self tz_addPopGestureToView:sta];
    textview = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(0, 164, SCREEN.size.width, 100)];
    textview.placeholder = @"写下购买体会和使用感受来帮助其他的小伙伴吧~";
    textview.backgroundColor = JHColor(238, 238, 238);
    [self.view addSubview:textview];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-40)/3, (SCREEN.size.width-40)/3);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 284, SCREEN.size.width, (SCREEN.size.width-40)/3) collectionViewLayout:flowLayout];
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor clearColor]];
    
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.collectionview];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.userInteractionEnabled = YES;
    imageview.image = self.imageArray[indexPath.row];
    UIButton *btn = [[UIButton alloc]init];

    [btn setImage:[UIImage imageNamed:@"icon_shanchu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageclick:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    imageview.tag = indexPath.row + 55;

    //    if (!(indexPath.row == self.imageArray.count - 1)) {
    //
    //    }
    btn.tag = indexPath.row + 22;
    [cell.contentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
    }];
    if (![imageview.image isEqual:self.picture]) {
        [imageview addSubview:btn];
        [imageview addGestureRecognizer:tap];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.width.offset(30);
            make.height.offset(30);
            make.right.offset(0);
        }];
    }

    
    return cell;
    
}

-(void)buttonclick:(UIButton *)button{
    
    if (self.imageArray.count <= 4) {
        
        
    }
    [self.imageArray removeObjectAtIndex:button.tag - 22];
    //    [self.imagedata removeObjectAtIndex:button.tag - 22];
    
    if (![self.imageArray.lastObject isEqual:self.picture]) {
        [self.imageArray addObject:self.picture];
    }
    

    
    [self.collectionview reloadData];
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
    
}


-(void)imageclick:(UITapGestureRecognizer *)tap{
    
    
    
    
    if (self.lookImagesView.isHidden)
    {
        [self.lookImagesView sShow:tap.view.tag - 55];
    }
    else
    {
        [self.lookImagesView sHiden];
    }
    
    
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
    NSLog(@"imageArray:%@",self.imageArray);
    UIImage *image = self.imageArray[indexPath.row];
    if ([image isEqual:self.picture]) {
        
        if (self.imageArray.count <= 5) {
            [self choseImage];
        }else{

            [self alertController:@"提示" prompt:@"最多上传五张图片" sure:@"确定" cancel:nil success:^{
                
            } failure:^{
                
            }];
            
        }
        
        
        
    }
    
    
    
}
- (ZBLookImagesView *)lookImagesView
{
    if (!_lookImagesView)
    {
        _lookImagesView = [ZBLookImagesView initWithSupView:self.view];
        [_lookImagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.bottom.offset(0);
        }];
        [_lookImagesView sHiden];
    }
    return _lookImagesView;
}

//选择tu
-(void)choseImage{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"图库", nil];
    [sheet showInView:self.view];
    
    
    
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
        imagePickerVc.maxImagesCount = 4;
        //        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingVideo = NO;

        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
    //显示控制器
    [self presentViewController:pic animated:YES completion:nil];
}
#pragma mark  图片选择成功的方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{

    for (NSDictionary *info in infos) {
        
        NSString *file = [NSString stringWithFormat:@"%@",[info objectForKey:@"PHImageFileURLKey"]];
        LFLog(@"file:%@",file);
        file = [file stringByReplacingOccurrencesOfString:@"file:///" withString:@"/"];
        
        NSFileManager* manager = [NSFileManager defaultManager];
        
        if ([manager fileExistsAtPath:file]){
            
            LFLog(@"%f",[[manager attributesOfItemAtPath:file error:nil] fileSize]/(1024.0*1024.0)) ;
        }
        }
        [self.imageArray removeAllObjects];
        for (UIImage *im in photos) {
            [self.imageArray addObject:im];
        }
        if (self.imageArray.count < 4) {
            [self.imageArray addObject:self.picture];
        }
        
        if (self.imageArray.count >3) {
            self.collectionview.frame = CGRectMake(0, 284, SCREEN.size.width , ((SCREEN.size.width-40)/3) * 2 + 10) ;
            
        }
        
        [self.collectionview reloadData];
//        ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
//        __block float fileMB  = 0.0;
//        
//        [alLibrary assetForURL:[info objectForKey:@"PHImageFileURLKey"] resultBlock:^(ALAsset *asset)
//         {
//             ALAssetRepresentation *representation = [asset defaultRepresentation];
//             fileMB = (float)([representation size]/(1024 * 1024));
//             [self.imagedata addObject:[NSNumber numberWithFloat:fileMB]];
//             NSLog(@"size of asset in bytes: %0.2f", fileMB);
//             
//         }
//                  failureBlock:^(NSError *error)
//         {
//             
//         }];
    
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
    
//    ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
//    __block float fileMB  = 0.0;
//    
//    [alLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset)
//     {
//         ALAssetRepresentation *representation = [asset defaultRepresentation];
//         fileMB = (float)([representation size]/(1024 * 1024));
//         [self.imagedata addObject:[NSNumber numberWithFloat:fileMB]];
//         NSLog(@"size of asset in bytes: %0.2f", fileMB);
//         
//     }
//              failureBlock:^(NSError *error)
//     {
//         
//     }];
    
    editimage = [editimage fixOrientation];
    for (UIImage *image in self.imageArray) {
        if ([image isEqual:self.picture]) {
            [self.imageArray removeObject:image];
            
        }
    }
    if (self.imageArray.count < 4) {
        [self.imageArray addObject:self.picture];
    }
    
    if (self.imageArray.count >3) {
        self.collectionview.frame = CGRectMake(0, 284, SCREEN.size.width , ((SCREEN.size.width-40)/3) * 2 + 10) ;
    }

    [self.collectionview reloadData];
    [self.imageArray addObject:editimage];
    
    //移除图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - *************评价提交
-(void)UploadDatagoodsEvaluation{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSString *ip = @"119.57.138.165";
    NSString *count = [NSString stringWithFormat:@"%d",(int)sta.count];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"parent_id",textview.text,@"content",count,@"comment_rank",ip,@"ip_address",self.goods_id,@"goods_id",self.order_id,@"order_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSMutableArray *imstr = [NSMutableArray array];
    for (int i = 0;i < self.imageArray.count ; i ++) {
        UIImage *image = self.imageArray[i];
        if (![image isEqual:self.picture]) {
            
            [imstr addObject:image];
            
        }
    }

    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderEvaluateUrl) params:dt body:imstr success:^(id response) {
        [self dismissTips];
        LFLog(@"评价：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"您已评价成功"];
            [self performSelector:@selector(popviewcontroller) withObject:nil afterDelay:2.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self UploadDatagoodsEvaluation];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }


    } failure:^(NSError *error) {
        LFLog(@"评价error：%@",error);
    }];
//    LFLog(@"dt：%@",dt);
//    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderEvaluateUrl) params:dt success:^(id response) {
//        [self dismissTips];
//        LFLog(@"评价：%@",response);
//        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
//        
//        if ([str isEqualToString:@"1"]) {
//            [self presentLoadingTips:@"您已评价成功"];
//            [self performSelector:@selector(popviewcontroller) withObject:nil afterDelay:2.0];
//        }else{
//            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
//            if ([error_code isEqualToString:@"100"]) {
//                [self showLogin];
//            }
//            [self presentLoadingTips:response[@"status"][@"error_desc"]];
//        }
//    } failure:^(NSError *error) {
//        LFLog(@"评价error：%@",error);
//        [self dismissTips];
//    }];
    
    
}
-(void)popviewcontroller{
    [self.navigationController popViewControllerAnimated:YES];

}

@end
