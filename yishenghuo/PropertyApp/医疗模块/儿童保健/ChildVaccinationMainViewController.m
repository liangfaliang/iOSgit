//
//  ChildVaccinationMainViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ChildVaccinationMainViewController.h"
#import "VaccinationPlanViewController.h"
#import "ChildVaccinationRecordViewController.h"
#import "PregnantFileRecordViewController.h"
#import "SPPageMenu.h"
@interface ChildVaccinationMainViewController ()<SPPageMenuDelegate>
@property (strong,nonatomic)UISegmentedControl *segment;
@property (strong,nonatomic)NSArray *vcArray;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@end

@implementation ChildVaccinationMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.child_id) {
        [self creatSegment];
    }else{
        VaccinationPlanViewController *vacc = [[VaccinationPlanViewController alloc]init];
        vacc.child_id = self.child_id;
        PregnantFileRecordViewController *record = [[PregnantFileRecordViewController alloc]init];
//        record.child_id = self.child_id;
        self.vcArray = @[vacc,record];
        [self addChildViewController:vacc];
        [self.view addSubview:vacc.view];
        self.navigationItem.titleView = self.pageMenu;
    }
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, 200, 40) trackerStyle:SPPageMenuTrackerStyleLine];
        pageMenu.backgroundColor = [UIColor clearColor];
        pageMenu.tracker.backgroundColor = JHMedicalColor;
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        // 设置代理
        pageMenu.selectedItemTitleColor = JHmiddleColor;
        pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        pageMenu.delegate = self;
        pageMenu.VerticalLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 20)];
        pageMenu.VerticalLine.backgroundColor = JHBorderColor;
        pageMenu.dividingLine.backgroundColor = [UIColor clearColor];
        _pageMenu = pageMenu;
        [_pageMenu setItems:@[@"产检预约",@"产检记录"] selectedItemIndex:(self.selectIndex ? [self.selectIndex integerValue] :0)];
        
    }
    return _pageMenu;
}

- (void)creatSegment
{
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"接种计划",@"接种记录"] ];
    self.segment.selectedSegmentIndex = [self.selectIndex integerValue];
    self.segment.tintColor  = JHColor(68, 67, 81);
    self.segment.bounds = CGRectMake(0, 0, 120, 30);
//    self.segment.center = CGPointMake(SCREEN.size.width/2, 20);
    self.segment.layer.cornerRadius  =15;
    self.segment.layer.masksToBounds = YES;
    [self.segment addTarget:self action:@selector(segmentclick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
    VaccinationPlanViewController *vacc = [[VaccinationPlanViewController alloc]init];
    vacc.child_id = self.child_id;
    ChildVaccinationRecordViewController *record = [[ChildVaccinationRecordViewController alloc]init];
    record.child_id = self.child_id;
    self.vcArray = @[vacc,record];
    [self addChildViewController:vacc];
    [self.view addSubview:vacc.view];
}
-(void)segmentclick:(UISegmentedControl* )seg{
    UIViewController *vc = self.vcArray[1 - seg.selectedSegmentIndex];
    [vc removeFromParentViewController];
    [vc.view removeFromSuperview];
    UIViewController *vcSelect = self.vcArray[seg.selectedSegmentIndex];
    [self addChildViewController:vcSelect];
    [self.view addSubview:vcSelect.view];
    
}
-(void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    UIViewController *vc = self.vcArray[fromIndex];
    [vc removeFromParentViewController];
    [vc.view removeFromSuperview];
    UIViewController *vcSelect = self.vcArray[toIndex];
    [self addChildViewController:vcSelect];
    [self.view addSubview:vcSelect.view];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
