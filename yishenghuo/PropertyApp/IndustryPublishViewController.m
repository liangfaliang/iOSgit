//
//  IndustryPublishViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/27.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "IndustryPublishViewController.h"
#import "ZBLookImagesView.h"
#import "MenuListViewController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "HPGrowingTextView.h"
@interface IndustryPublishViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,HPGrowingTextViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollveiw;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UITextField *tf;

@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,strong)HPGrowingTextView *tfview;

@property(nonatomic,strong)NSMutableArray  *imageArray;
@property(nonatomic,strong)NSMutableArray  *imagedata;
@property(nonatomic,strong)UIImage  *picture;
@property(nonatomic,strong)UICollectionView  *collectionview;
@property (nonatomic, strong) ZBLookImagesView *lookImagesView;

@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)NSMutableArray *colorArr;

@end

@implementation IndustryPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"发表主题";

    UIBarButtonItem *infoBtn =[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(fasongBtnClick:)];
    infoBtn.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = infoBtn;
    self.view.backgroundColor = [UIColor whiteColor];
    self.picture = [UIImage imageNamed:@"icon_add"];
    [self.imageArray addObject:self.picture];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.scrollveiw = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height)];
    self.scrollveiw.contentSize = CGSizeMake(0, 800);
    self.scrollveiw.delegate = self;
    [self.view addSubview:self.scrollveiw];
    
    [self createUI];
    [self upDataforMenu];

}

-(NSMutableArray *)imageArray{
    
    if (_imageArray == nil) {
        _imageArray  = [[NSMutableArray alloc]init];
    }
    
    
    return _imageArray;
}
-(NSMutableArray *)imagedata{
    
    if (_imagedata == nil) {
        _imagedata  = [[NSMutableArray alloc]init];
    }
    
    
    return _imagedata;
}
-(NSMutableArray *)dataArr{
    
    if (_dataArr == nil) {
        _dataArr  = [[NSMutableArray alloc]init];
    }
    
    
    return _dataArr;
}

-(NSMutableDictionary *)dit{
    
    if (_dit == nil) {
        _dit = [[NSMutableDictionary alloc]init];
    }
    
    return _dit;
}

-(NSMutableArray *)colorArr{
    
    if (_colorArr == nil) {
        _colorArr  = [[NSMutableArray alloc]init];
    }
    
    
    return _colorArr;
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

-(void)createUI{
    
    
    
    
    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN.size.width - 20, 45)];
    
    self.tf.layer.borderWidth = 1;
    self.tf.layer.cornerRadius = 5;
    self.tf.placeholder = @"标题";
    self.tf.font = [UIFont systemFontOfSize:14];
    self.tf.layer.borderColor = [[UIColor colorWithRed:235/256.0 green:236/256.0 blue:237/256.0 alpha:1.0]CGColor];
    [self.scrollveiw addSubview:self.tf];
    
    
    self.tfview = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(10, 65, SCREEN.size.width - 20, 150)];
    self.tfview.placeholder = @"说点什么……";
    self.tfview.minHeight = 150;
    
    self.tfview.layer.borderColor = [[UIColor colorWithRed:235/256.0 green:236/256.0 blue:237/256.0 alpha:1.0]CGColor];
    self.tfview.layer.borderWidth = 1;
    self.tfview.layer.cornerRadius = 5;
    self.tfview.font = [UIFont systemFontOfSize:14];
    self.tfview.textColor = [UIColor grayColor];
    self.tfview.delegate = self;
    
    [self.scrollveiw addSubview:self.tfview];
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-30)/2, (SCREEN.size.width - 30)/2);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 245, SCREEN.size.width - 20, (SCREEN.size.width-30)/2 + 10) collectionViewLayout:flowLayout];
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor clearColor]];
    
    //注册Cell，必须要有
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.scrollveiw addSubview:self.collectionview];
    self.tableview  = [[UITableView alloc]initWithFrame:CGRectMake(0, 245 + (SCREEN.size.width-30)/2 + 20 , SCREEN.size.width , SCREEN.size.height ) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource  = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.scrollveiw addSubview:self.tableview];
    
    
}

#pragma mark 发帖按钮
-(void)fasongBtnClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    LFLog(@"发送");
    if (self.tf.text.length == 0) {
        [self presentLoadingTips:@"请输入标题~~"];
    }else if ([self.tfview.text isEqualToString:@"说点什么……"]){
        
        [self presentLoadingTips:@"请输入帖子内容~~"];
        
    }else if (self.category == nil){
        
        [self presentLoadingTips:@"请选择发帖类型~~"];
        
    }else{
        
        [self postMessage];
        
    }
    
    
}
-(void)buttonclickstype:(UIButton *)btn{
    
    for (int i = 0; i< 5; i++) {
        if (btn.tag == 100 +i) {
            btn.selected = YES;
            btn.layer.borderColor = [[UIColor colorWithRed:0/256.0 green:107/256.0 blue:218/256.0 alpha:1.0]CGColor];
        }else{
            UIButton *bt = (UIButton *)[self.view viewWithTag:100 + i];
            bt.selected = NO;
            bt.layer.borderColor = [[UIColor colorWithRed:235/256.0 green:236/256.0 blue:237/256.0 alpha:1.0]CGColor];
        }
    }
    
    
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,(SCREEN.size.width-30)/2, (SCREEN.size.width - 30)/2)];
    imageview.userInteractionEnabled = YES;
    imageview.image = self.imageArray[indexPath.row];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(imageview.frame.size.width - 30, 0, 30, 30)];
    //btn.backgroundColor = [UIColor blueColor];
    [btn setImage:[UIImage imageNamed:@"icon_shanchu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageclick:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    imageview.tag = indexPath.row + 55;
    if (![imageview.image isEqual:self.picture]) {
        [imageview addSubview:btn];
        [imageview addGestureRecognizer:tap];
        
    }
    //    if (!(indexPath.row == self.imageArray.count - 1)) {
    //
    //    }
    btn.tag = indexPath.row + 22;
    [cell.contentView addSubview:imageview];
    
    
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
    
    
    if (self.imageArray.count < 3) {
        self.collectionview.frame = CGRectMake(10, 245, SCREEN.size.width - 20, (SCREEN.size.width-30)/2 + 10) ;
        self.tableview.frame = CGRectMake(0, 245 + (SCREEN.size.width-30)/2 + 20 , SCREEN.size.width , SCREEN.size.height );
        self.scrollveiw.contentSize = CGSizeMake(0, 245 + ((SCREEN.size.width-30)/2)  + 220 + 60 * self.dataArr.count);
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
            [self createAlertion:@"提示" str:@"最多上传五张图片"];
            
        }
        
        
        
    }
    
    
    
}

//警告框
-(void)createAlertion:(NSString *)str1 str:(NSString *)str2{
    
    UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:str1 message:str2 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertcontro addAction:okAction];
    
    [self presentViewController:alertcontro animated:YES completion:nil];
    
    
    
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
        ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
        __block float fileMB  = 0.0;
        
        [alLibrary assetForURL:[info objectForKey:@"PHImageFileURLKey"] resultBlock:^(ALAsset *asset)
         {
             ALAssetRepresentation *representation = [asset defaultRepresentation];
             fileMB = (float)([representation size]/(1024 * 1024));
             [self.imagedata addObject:[NSNumber numberWithFloat:fileMB]];
             NSLog(@"size of asset in bytes: %0.2f", fileMB);
             
         }
                  failureBlock:^(NSError *error)
         {
             
         }];
    }
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
    editimage = [editimage fixOrientation];
    ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
    __block float fileMB  = 0.0;
    
    [alLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset)
     {
         ALAssetRepresentation *representation = [asset defaultRepresentation];
         fileMB = (float)([representation size]/(1024 * 1024));
         [self.imagedata addObject:[NSNumber numberWithFloat:fileMB]];
         NSLog(@"size of asset in bytes: %0.2f", fileMB);
         
     }
              failureBlock:^(NSError *error)
     {
         
     }];
    
    
    for (UIImage *image in self.imageArray) {
        if ([image isEqual:self.picture]) {
            [self.imageArray removeObject:image];
            
        }
    }
    if (self.imageArray.count < 4) {
        [self.imageArray addObject:self.picture];
    }
    
    if (self.imageArray.count >2) {
        self.collectionview.frame = CGRectMake(10, 245, SCREEN.size.width - 20, ((SCREEN.size.width-30)/2) * 2 + 10) ;
        self.tableview.frame = CGRectMake(0, 245 + ((SCREEN.size.width-30)/2) * 2 + 30 , SCREEN.size.width , SCREEN.size.height );
        self.scrollveiw.contentSize = CGSizeMake(0, 245 + ((SCREEN.size.width-30)/2) * 2 + 220 + 60 * self.dataArr.count);
    }
    [self.tableview reloadData];
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
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)asset{
//    
//    [self.imageArray removeAllObjects];
//    for (UIImage *im in photos) {
//        [self.imageArray addObject:im];
//    }
//    if (self.imageArray.count < 4) {
//        [self.imageArray addObject:self.picture];
//    }
//    
//    if (self.imageArray.count >2) {
//        self.collectionview.frame = CGRectMake(10, 245, SCREEN.size.width - 20, ((SCREEN.size.width-30)/2) * 2 + 10) ;
//        self.tableview.frame = CGRectMake(0, 245 + ((SCREEN.size.width-30)/2) * 2 + 30 , SCREEN.size.width , SCREEN.size.height );
//        self.scrollveiw.contentSize = CGSizeMake(0, 245 + ((SCREEN.size.width-30)/2) * 2 + 220 + 60 * self.dataArr.count);
//    }
//    [self.tableview reloadData];
//    [self.collectionview reloadData];
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.dataArr[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    UIImageView *imageview = [self.view viewWithTag:indexPath.row + 200];
    
    
    if (imageview == nil) {
        imageview = [[UIImageView alloc]init];
        imageview.tag = indexPath.row + 200;
        [cell.contentView addSubview:imageview];
        [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageview.contentMode =  UIViewContentModeScaleAspectFill;
        imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageview.clipsToBounds  = YES;
    }
    imageview.image = [UIImage imageNamed:@"ic_arrow"];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-10);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        
    }];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = JHColor(253, 193, 103);
    }else if (indexPath.row == 1){
        cell.textLabel.textColor = JHColor(215, 123, 237);
    }else if (indexPath.row == 2){
        cell.textLabel.textColor = JHColor(110,190, 56);
    }else if (indexPath.row == 3){
        cell.textLabel.textColor = JHColor(248, 115, 115);
    }else if (indexPath.row == 4){
        cell.textLabel.textColor = JHColor(62, 147, 225);
    }else if (indexPath.row == 5){
        cell.textLabel.textColor = JHColor(253, 193, 103);
    }else if (indexPath.row == 6){
        cell.textLabel.textColor = JHColor(253, 193, 103);
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.lab.text = cell.textLabel.text;
    self.category = self.dataArr[indexPath.row][@"id"];
    [self upDataforsecondMenu:self.dataArr[indexPath.row][@"id"]];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bview = [[UIView alloc]init];
    bview.backgroundImage = [UIImage imageNamed:@"fenxiangzhibackview"];
    bview.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"fenxiangzhi"] forState:UIControlStateNormal];
//    [btn setTitle:@"分享至：" forState:UIControlStateNormal];
//    [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
    [bview addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(bview.mas_centerY);
    }];
    
    if ( self.lab == nil) {
        self.lab = [[UILabel alloc]init];
        self.lab.font = [UIFont systemFontOfSize:15];
        self.lab.textColor = JHColor(10, 100, 200);
        self.lab.textAlignment = NSTextAlignmentRight;
        
    }
    [bview addSubview:self.lab];
    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bview.mas_centerY);
        make.right.offset(-10);
        make.width.offset(200);
    }];
    return bview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 50;
}

//uitextview协议方法

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"说点什么……"]) {
        textView.text = @"";
    }
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}



-(void)textViewDidEndEditing:(UITextView *)textView{
    
    
    
    if (textView.text.length == 0) {
        textView.text = @"说点什么……";
    }
    
    
}

#pragma mark 菜单数据请求
-(void)upDataforMenu{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,IndustryCategoryUrl) params:dt success:^(id response) {
        
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.dataArr removeAllObjects];
            
            for (NSDictionary *dt in response[@"data"]) {
                [self.dataArr addObject:dt];
                
            }
            self.scrollveiw.contentSize = CGSizeMake(0, 245 + (SCREEN.size.width-20)/3-10 + 220 + 60 * self.dataArr.count);
            [self.tableview reloadData];
            
        }else{
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark 二级菜单数据请求
-(void)upDataforsecondMenu:(NSString *)parentid{
    
    NSDictionary *dt = @{@"parentid":parentid};
    [LFLHttpTool get:NSStringWithFormat(ZJBBsBaseUrl,@"8") params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            LFLog(@"二级菜单");
            
            NSMutableArray *menuarr = [[NSMutableArray alloc]init];
            for (NSDictionary *dt in response[@"note"]) {
                [menuarr addObject:dt];
            }
            
            if (menuarr.count > 0) {
                MenuListViewController *menu = [[MenuListViewController alloc]init];
                menu.dataArr = menuarr;
                [self.navigationController pushViewController:menu animated:YES];
            }else{
                
                [self.tableview reloadData];
            }
            
        }else{
            [self.tableview reloadData];
            
        }
        
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
    
}

#pragma mark 发帖
-(void)postMessage{

    [self presentLoadingTips:@"请稍后~~"];
    NSMutableArray *imstr = [NSMutableArray array];
    for (int i = 0;i < self.imageArray.count ; i ++) {
        UIImage *image = self.imageArray[i];
        if (![image isEqual:self.picture]) {
            
            [imstr addObject:image];
            
        }
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.tfview.text,@"content",self.tf.text,@"title",self.category,@"category_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"发表dt：%@",dt);

     [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,IndustryAddArticleUrl) params:dt body:imstr success:^(id response) {
        LFLog(@"发表：%@",response);
        
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            
            [self presentLoadingTips:@"发送成功~~"];
            [self performSelector:@selector(popoverAnmtion) withObject:nil afterDelay:2.0];
            
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        
        LFLog(@"error:%@",error);
    }];
    
}

-(void)popoverAnmtion{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    if (self.dit.count > 0) {
        NSString *str = self.lab.text;
        self.lab.text = [NSString stringWithFormat:@"%@ - %@",_dit[@"name"],str];
        self.category = _dit[@"id"];
        [self.tableview reloadData];
    }
    
}


@end
