//
//  SatisfactionViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/17.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "SatisfactionViewController.h"
#import "ChoiceCollectionViewCell.h"
#import "ChoiceModel.h"
#import "UIView+TransitionAnimation.h"
#import "SurveyResultsViewController.h"
#import "HPGrowingTextView.h"
#import "SatisfactionListViewController.h"
//#import "OptionModel.h"
@interface SatisfactionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,HPGrowingTextViewDelegate>{
    UILabel *DetailLb;
}
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)NSMutableArray *choiceArr;
@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic,strong) UIView *begainview;

@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UIButton *previousBtn;
@property(nonatomic,strong)UILabel *pageLabe;
@property(nonatomic,strong)UIView *footview;
@property(nonatomic,strong) UIImageView *imageview;
@property(nonatomic,strong) UIImageView *subimageview;
@property(nonatomic,strong) HPGrowingTextView *opinionText;
@property(nonatomic,strong) NSString *voteid;
//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;
@end

@implementation SatisfactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    if (self.type_id) {
        self.navigationBarTitle = @"问卷测评";
    }else if (self.type) {
        self.navigationBarTitle = @"问卷测评";
    }else {
        self.navigationBarTitle = @"社区共建调查";
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createBegainview];
    [self upDataforproblem];
}

//创建开始页
-(void)createBegainview{
    
    self.begainview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height)];
    self.begainview.userInteractionEnabled = YES;
    [self.view addSubview:self.begainview];
    self.begainview.backgroundColor = [UIColor whiteColor];
    DetailLb = [[UILabel alloc]init];
    
    DetailLb.numberOfLines = 0;
    DetailLb.textColor = JHColor(102, 102, 102);
    DetailLb.font = [UIFont systemFontOfSize:15];
    [self.begainview addSubview: DetailLb];
    
    UIImageView *begainimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 150-64, SCREEN.size.width, 150)];
    begainimage.userInteractionEnabled = YES;
    begainimage.image = [UIImage imageNamed:@"kaishi_manyidudiaocha"];
    [_begainview addSubview:begainimage];
    
    UIButton *begainbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN.size.width  * 67/150, 10, SCREEN.size.width  * 0.4, 60)];
    
    [begainbtn addTarget:self action:@selector(begainBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    //    begainbtn.backgroundColor = [UIColor redColor];
    [begainimage addSubview:begainbtn];
    
    
    
}

-(void)viewDidLayoutSubviews{
    
    
    
}
//点击开始
-(void)begainBtnclick:(UIButton *)btn{
    
    LFLog(@"点击开始");
    
    [self.begainview.window addTransitionAnimationWithDuration:1.0 type:TransitionPageCurl subType:FROM_BOTTOM];
    self.begainview.hidden = YES;
    //    [self.begainview removeFromSuperview];
    
    [self createFootview];
    [self createCollectionview];
    if (self.choiceArr) {
        self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50 + 5, 44)];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.rightBtn setTitle:@"提交" forState:UIControlStateSelected];
        [self.rightBtn setTitle:@"下一页" forState:UIControlStateNormal];
        if (self.choiceArr.count <= 1) {
            self.rightBtn.selected = YES;
        }
        [self.rightBtn setTitleColor:JHshopMainColor forState:UIControlStateSelected];
        [self.rightBtn setTitleColor:JHshopMainColor forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(rightBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        //            UIBarButtonItem * barbtn = [[UIBarButtonItem alloc] initWithImage:navigationBarRightItem style:UIBarButtonItemStylePlain target:self action:@selector(rightBaritemBtn:)];
        //            barbtn.tintColor = JHdeepColor;
        UIBarButtonItem * barbtn = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        self.navigationItem.rightBarButtonItem = barbtn;
    }
    
}
-(void)rightBtnclick:(UIButton *)btn{
    if (!btn.selected) {
        [self nextClick:nil];
    }else{
        [self subBtnclick:nil];
    }
}
- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}
- (NSMutableArray *)choiceArr
{
    if (_choiceArr == nil) {
        _choiceArr = [[NSMutableArray alloc]init];
    }
    return _choiceArr;
}

-(void)createFootview{
    
    self.footview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 122, SCREEN.size.width, 122)];
    //    self.footview.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.footview];
    
    _imageview = [[UIImageView alloc]init];
    _imageview.userInteractionEnabled = YES;
    _imageview.image = [UIImage imageNamed:@"dibeijing_manyidudiaocha"];
    CGFloat ht = SCREEN.size.width  * _imageview.image.size.height/_imageview.image.size.width + [UIImage imageNamed:@"xiayiye_manyidudiaocha"].size.height/2;
    [self.footview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(ht);
    }];
    
    [self.footview addSubview:_imageview];
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.top.equalTo(self.footview.mas_top).offset([UIImage imageNamed:@"xiayiye_manyidudiaocha"].size.height/2);
        
    }];
    //    _subimageview = [[UIImageView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
    //    _subimageview.image = [UIImage imageNamed:@"dibeijing_manyidudiaocha"];
    
    self.nextBtn = [[UIButton alloc]init];
    [self.nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn setImage:[UIImage imageNamed:@"xiayiye_manyidudiaocha"] forState:UIControlStateNormal];
    [self.footview addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.equalTo(_imageview.mas_top);
        
        
    }];
    
    self.pageLabe = [[UILabel alloc]init];
    self.pageLabe.font = [UIFont systemFontOfSize:14];
    //    self.pageLabe.backgroundColor = [UIColor redColor];
    [self.footview addSubview:self.pageLabe];
    [self.pageLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.footview.mas_centerX);
        make.centerY.equalTo(_imageview.mas_top);
        //        make.width.offset(30);
        //        make.height.offset(20);
    }];
    if (self.choiceArr.count) {
        self.pageLabe.text = [NSString stringWithFormat:@"1/%d",(int)self.choiceArr.count];
    }
    self.previousBtn = [[UIButton alloc]init];
    [self.previousBtn addTarget:self action:@selector(previousBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.previousBtn setImage:[UIImage imageNamed:@"fanhui_manyidudiaocha"] forState:UIControlStateNormal];
    [self.footview addSubview:_previousBtn];
    [_previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.centerY.equalTo(_imageview.mas_top);
        
    }];
}
-(void)UpdateConstraint{
    CGFloat ht = SCREEN.size.width  * _imageview.image.size.height/_imageview.image.size.width + [UIImage imageNamed:@"xiayiye_manyidudiaocha"].size.height/2;
    [self.footview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ht);
    }];
    
    [_imageview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(SCREEN.size.width  * _imageview.image.size.height/_imageview.image.size.width);
    }];
    
    
}

-(void)nextClick:(UIButton *)btn{
    NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
    if (currentIndex +1 < self.choiceArr.count) {
        self.rightBtn.selected = NO;
        if (currentIndex +1 == self.choiceArr.count) {
            self.rightBtn.selected = YES;
        }
        currentIndex += 1;
    }else{
        self.rightBtn.selected = YES;
        [self scrollViewDidEndDecelerating:self.collectionview];
        return;
    }
    self.pageLabe.text = [NSString stringWithFormat:@"%d/%d",(int)currentIndex + 1,(int)self.choiceArr.count];
    NSIndexPath * index = [NSIndexPath indexPathForRow:currentIndex  inSection:0];
    [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}
-(void)previousBtnClick:(UIButton *)btn{
    NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
    if (currentIndex > 0) {
        currentIndex -= 1;
    }else if (currentIndex + 1 == self.choiceArr.count){
        [self scrollViewDidEndDecelerating:self.collectionview];
    }else{
        
        return;
    }
    self.pageLabe.text = [NSString stringWithFormat:@"%d/%d",(int)currentIndex +1,(int)self.choiceArr.count];
    NSIndexPath * index = [NSIndexPath indexPathForRow:currentIndex  inSection:0];
    [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}
-(void)createCollectionview{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.itemSize = CGSizeMake(SCREEN.size.width - 1, SCREEN.size.height-100);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    
    self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height - 100) collectionViewLayout:flowLayout];
    //    self.collectionview.panEnabled = YES;
    self.collectionview.pagingEnabled = YES;
    self.collectionview.dataSource=self;
    //    self.collectionview.scrollEnabled = YES;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.delegate=self;
    self.collectionview.showsHorizontalScrollIndicator = NO;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"opinionCell"];
    [self.collectionview registerClass:[ChoiceCollectionViewCell class] forCellWithReuseIdentifier:@"ChoiceCollectionViewCell"];
    
    [self.view addSubview:self.collectionview];
    [self tz_addPopGestureToView:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(64);
        make.bottom.equalTo(self.footview.mas_top);
    }];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:self.collectionview];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    CGPoint pInView = [self.view convertPoint:self.collectionview.center toView:self.collectionview];
    //    // 获取这一点的indexPath
    //    NSIndexPath *indexPathNow = [self.collectionview indexPathForItemAtPoint:pInView];
    //    // 赋值给记录当前坐标的变量
    //
    
    if (scrollView == self.collectionview) {
        NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
        NSLog(@"contentOffset:%f",self.collectionview.contentOffset.x);
        NSLog(@"currentIndex:%ld",(long)currentIndex);
        if (currentIndex > 0) {
            if ([self.choiceArr[currentIndex - 1] isKindOfClass:[JSONModel class]]) {
                ChoiceModel *choiceModel = self.choiceArr[currentIndex - 1];
                NSString * is_continue = @"1";//不继续
                LFLog(@"choiceModel:%@",choiceModel);
                for (OptionModel *opmodel in choiceModel.option) {
                    if ([opmodel.is_check isEqualToString:@"1"]) {//1 选择
                        is_continue = @"0";
                        if (choiceModel.is_required == 1) {//意见必填
                            if (opmodel.opinion == 1) {//显示意见的时候
                                if (!choiceModel.opinioncontent || choiceModel.opinioncontent.length == 0) {//必填 为空的时候
                                    is_continue = @"2";
                                }
                            }
                            
                        }
                    }
                }
                
                
                if (![is_continue isEqualToString:@"0"]) {
                    if ([is_continue isEqualToString:@"1"]) {
                        [self presentLoadingTips:@"请选择您的答案！"];
                    }else if ([is_continue isEqualToString:@"2"]){
                        [self presentLoadingTips:@"请填写原因！"];
                    }
                    
                    NSIndexPath * index = [NSIndexPath indexPathForRow:currentIndex -1  inSection:0];
                    [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                    return;
                }
            }
            
        }
        if ((currentIndex +1) == self.choiceArr.count) {
            _nextBtn.hidden = YES;
            _rightBtn.selected = YES;
            //            _pageLabe.hidden = YES;
            //        _previousBtn.hidden = YES;
            [_previousBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(_imageview.mas_top).offset(self.footview.frame.size.height/2);
                
            }];
            _imageview.image = [UIImage imageNamed:@"tijiao_manyidudiaocha"];
            [self UpdateConstraint];
            
            UIButton *subbtn = [self.view viewWithTag:222];
            if (subbtn == nil) {
                subbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN.size.width  * 0.6, 10, SCREEN.size.width  * 0.4 - 15, 60)];
                subbtn.tag = 222;
                [subbtn addTarget:self action:@selector(subBtnclick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            subbtn.backgroundColor = [UIColor clearColor];
            [_imageview addSubview:subbtn];
            
        }else{
            _rightBtn.selected = NO;
            _nextBtn.hidden = NO;
            _pageLabe.hidden = NO;
            //        _previousBtn.hidden = NO;
            [_previousBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(_imageview.mas_top);
                
            }];
            [_imageview removeAllSubviews];
            _imageview.image = [UIImage imageNamed:@"dibeijing_manyidudiaocha"];
            [self UpdateConstraint];
        }
        self.pageLabe.text = [NSString stringWithFormat:@"%d/%d",(int)currentIndex + 1,(int)self.choiceArr.count];
    }
    
    
    
}

//提交
-(void)subBtnclick:(UIButton *)btn{
    [self.view endEditing:YES];
    [self submitforproblem];
}
#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.choiceArr.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.001;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *image = [UIImage imageNamed:@"dibeijing_manyidudiaocha"];
    if (indexPath.row + 1 == self.choiceArr.count) {
        image = [UIImage imageNamed:@"tijiao_manyidudiaocha"];
    }
    float img_height = SCREEN.size.width  * image.size.height/image.size.width + [UIImage imageNamed:@"xiayiye_manyidudiaocha"].size.height/2;
    
    return CGSizeMake(SCREEN.size.width - 1,SCREEN.size.height - img_height);
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.choiceArr[indexPath.item] isKindOfClass:[JSONModel class]]) {
        static NSString * CellIdentifier = @"ChoiceCollectionViewCell";
        ChoiceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        //    for (id subView in cell.contentView.subviews) {
        //        [subView removeFromSuperview];
        //    }
        [cell.contentView removeAllSubviews];
        cell.item = indexPath.item ;
        
        cell.model = self.choiceArr[indexPath.item];
        
        [cell setSelectblock:^(NSString *str,NSInteger index,NSString *is_radio) {
            
            LFLog(@"selectBtn:%@",str);
            ChoiceModel *mo = self.choiceArr[indexPath.item];
            NSMutableArray *muarr = [[NSMutableArray alloc]init];
            for (OptionModel *opmodel in mo.option) {
                if ([opmodel.id isEqualToString:str]) {
                    if ([is_radio isEqualToString:@"1"]) {
                        
                        opmodel.is_check = @"1";
                        
                    }else{
                        if ([opmodel.is_check isEqualToString:@"0"]) {
                            opmodel.is_check = @"1";
                        }else{
                            opmodel.is_check = @"0";
                        }
                    }
                }else{
                    
                    if ([is_radio isEqualToString:@"1"]) {
                        opmodel.is_check = @"0";
                    }
                }
                
                [muarr addObject:opmodel];
            }
            mo.option = muarr;
            cell.model = mo;
            [self.choiceArr replaceObjectAtIndex:indexPath.item withObject:mo];
            
        }];
        cell.opinionText.delegate = self;
        
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"opinionCell" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    UILabel *tiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN.size.width - 20, 40)];
    tiLabel.textColor = JHmiddleColor;
    tiLabel.font = [UIFont systemFontOfSize:15];
    tiLabel.attributedText = [@"请写下您对我们工作的意见或建议，谢谢！" AttributedString:@"（选填项）" backColor:nil uicolor:[UIColor redColor] uifont:[UIFont systemFontOfSize:13]];
    
    tiLabel.numberOfLines = 0;
    [cell.contentView addSubview:tiLabel];
    if (_opinionText == nil) {
        _opinionText = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(10, 50, SCREEN.size.width - 20, 160)];
        _opinionText.backgroundColor = JHbgColor;
        //        _opinionText.placeholder = @"请输入您的意见（选填项）";
        //        _opinionText.placeholderColor = [UIColor redColor];
        _opinionText.layer.borderColor = [JHBorderColor CGColor];
        _opinionText.layer.borderWidth = 1;
        _opinionText.layer.cornerRadius = 5;
        _opinionText.layer.masksToBounds = YES;
        
    }
    [cell.contentView addSubview:_opinionText];
    return cell;
    
    
}

-(void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView{
    if ([growingTextView isFirstResponder]) {
        ChoiceCollectionViewCell *cell = (ChoiceCollectionViewCell *)growingTextView.superview.superview.superview.superview;
        NSIndexPath *indexpath = [self.collectionview indexPathForCell:cell];
        
        ChoiceModel *model = self.choiceArr[indexpath.item];
        model.opinioncontent = growingTextView.text;
        LFLog(@"indexpath.row:%ld",(long)indexpath.row);
        LFLog(@"model:%@",model);
    }
}
#pragma mark 数据请求
- (void)upDataforproblem{
    
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.strid) {
        [dt setObject:self.strid forKey:@"id"];
    }
    if (self.type) {
        [dt setObject:self.type forKey:@"stfctype"];
    }
    if (self.type_id) {
        [dt setObject:self.type_id forKey:@"type_id"];
    }
    LFLog(@"满意度dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,SatisfactionDetailUrl) params:dt success:^(id response) {
        [_collectionview.mj_header endRefreshing];
        [_collectionview.mj_footer endRefreshing];
        [self dismissTips];
        LFLog(@"满意度:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.voteid = response[@"data"][@"id"];
            [self.choiceArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"][@"subject"]) {
                ChoiceModel *model = [[ChoiceModel alloc]initWithDictionary:dt error:nil];
                [self.choiceArr addObject:model];
            }
            if ([[NSString stringWithFormat:@"%@",response[@"data"][@"opinion"]] isEqualToString:@"1"]) {//填写意见
                [self.choiceArr addObject:@"1"];
            }
            DetailLb.text  = [NSString stringWithFormat:@"%@",response[@"data"][@"detail"]];
            if (!self.type) {
                self.navigationBarTitle = [NSString stringWithFormat:@"%@",response[@"data"][@"title"]];
            }
            [DetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.top.offset(10);
                //        make.height.offset(SCREEN.size.height - 150-64);
                make.height.offset(([DetailLb.text selfadap:15 weith:20].height + 20) < (SCREEN.size.height - 150-64) ?([DetailLb.text selfadap:15 weith:20].height + 20):(SCREEN.size.height - 150-64));
            }];
            [self.collectionview reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self upDataforproblem];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}



#pragma mark 数据提交
- (void)submitforproblem{
    
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.type_id) {
        [dt setObject:self.type_id forKey:@"type_id"];
    }
    NSMutableString *subject = [NSMutableString string];
    //ChoiceCollectionViewCell
    NSArray* cellArr = self.collectionview.visibleCells;
    LFLog(@"self.choiceArr:%@",self.choiceArr);
    for (int i = 0; i < self.choiceArr.count; i ++) {
        if ([self.choiceArr[i] isKindOfClass:[JSONModel class]]) {
            ChoiceCollectionViewCell *cell = [[ChoiceCollectionViewCell alloc]init];
            if (i < cellArr.count) {
                cell = cellArr[i];
            }
            ChoiceModel *mo = self.choiceArr[i];
            //            NSString *datakey = [NSString string];
            BOOL isSelect = YES;//是否答题完成
            [subject appendFormat:@"%@_",mo.subject_id];
            if ([mo.is_radio isEqualToString:@"1"]) {//单选
                for (OptionModel *opmodel in mo.option) {
                    if ([opmodel.is_check isEqualToString:@"1"]) {
                        isSelect = NO;
                        if (opmodel.opinion ==1) {
                            if (mo.is_required == 1) {
                                if (mo.opinioncontent == nil || mo.opinioncontent.length == 0) {
                                    [self presentLoadingTips:@"请填写不满意意见！"];
                                    NSIndexPath * index = [NSIndexPath indexPathForRow:i  inSection:0];
                                    [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                                    return;
                                }
                                
                            }
                            NSData *encodeData = [mo.opinioncontent dataUsingEncoding:NSUTF8StringEncoding];
                            NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
                            [subject appendFormat:@"%@-%@",opmodel.id,base64String];
                        }else{
                            [subject appendFormat:@"%@",opmodel.id];
                        }
                        
                        //                        datakey = [NSString stringWithFormat:@"%@",opmodel.id];
                    }
                }
            }else{
                BOOL isfirst = YES;
                for (OptionModel *opmodel in mo.option) {
                    if ([opmodel.is_check isEqualToString:@"1"]) {
                        if ([opmodel.option isEqualToString:@"1"]) {
                            if (opmodel.opinion ==1) {
                                if (mo.is_required == 1) {
                                    if (mo.opinioncontent == nil || mo.opinioncontent.length == 0) {
                                        [self presentLoadingTips:@"请填写不满意意见！"];
                                        NSIndexPath * index = [NSIndexPath indexPathForRow:i  inSection:0];
                                        [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                                        return;
                                    }
                                    
                                }
                                NSData *encodeData = [mo.opinioncontent dataUsingEncoding:NSUTF8StringEncoding];
                                NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
                                [subject appendFormat:@"%@-%@",opmodel.id,base64String];
                            }else{
                                [subject appendFormat:@"%@",opmodel.id];
                            }
                        }else{
                            [subject appendFormat:@"%@、",opmodel.id];
                        }
                        
                        if (isfirst) {
                            //                            datakey = [NSString stringWithFormat:@"%@",opmodel.id];
                            isfirst = NO;
                            isSelect = NO;
                        }else{
                            isSelect = NO;
                            //                            datakey = [datakey stringByAppendingFormat:@",%@",opmodel.id];
                        }
                        
                    }
                }
                NSRange deleteRange = {[subject length] -1,1};
                [subject deleteCharactersInRange:deleteRange];
                
            }
            
            if (i < self.choiceArr.count -([self.choiceArr.lastObject isKindOfClass:[NSString class]] ? 2 :1)) {
                [subject appendString:@","];
            }
            
            if (isSelect) {
                [self presentLoadingTips:@"请完成所有选项~"];
                NSIndexPath * index = [NSIndexPath indexPathForRow:i  inSection:0];
                [self.collectionview scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                return;
            }
        }
        //        [dt setObject:datakey forKey:data];
        
    }
    if ([self.choiceArr.lastObject isKindOfClass:[NSString class]]) {
        if (self.opinionText) {
            NSData *encodeData = [self.opinionText.text dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
            [dt setObject:base64String  forKey:@"opinion"];
        }
    }
    [dt setObject:subject  forKey:@"subject"];
    [dt setObject:self.voteid  forKey:@"voteid"];
    if (self.type) {
        [dt setObject:self.type forKey:@"stfctype"];
    }
    LFLog(@"提交结果dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,SatisfactionSubmitUrl) params:dt success:^(id response) {
        LFLog(@"提交结果：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self dismissTips];
            if (self.type) {
                [self createAlertion:@"谢谢您的参与" str:@"您已完成问卷的测评"];
            }else {
                [self createAlertion:@"谢谢您的参与" str:@"您已完成问卷的调查"];
            }
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}

//警告框
-(void)createAlertion:(NSString *)str1 str:(NSString *)str2{
    
    UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:str1 message:str2 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *vcArr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[SatisfactionListViewController class]]) {
                [self.navigationController popViewControllerAnimated:NO];
                SurveyResultsViewController *hot = [[SurveyResultsViewController alloc]init];
                hot.strid = self.strid;
                hot.type_id = self.type_id;
                [vc.navigationController pushViewController:hot animated:YES];
            }
        }
        
        
    }];
    
    [alertcontro addAction:okAction];
    
    [self presentViewController:alertcontro animated:YES completion:nil];
    
    
}


//-(BOOL)fd_interactivePopDisabled{
//
//    return YES;
//}



@end

