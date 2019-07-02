//
//  PieChartViewController.m
//  PieChartTest
//
//  Created by 古创 on 2019/5/8.
//  Copyright © 2019年 chuang. All rights reserved.
//

#import "PieChartViewController.h"
#import "PieChartView.h"

@interface PieChartViewController ()

@property (nonatomic,strong) PieChartView *pieChartView;
@property (nonatomic,strong) PieChartView *pieChartView2;
@property (nonatomic,strong) PieChartView *pieChartView3;
@property (nonatomic,strong) PieChartView *pieChartView4;
@property (nonatomic,assign) BOOL isBtnClicked;

@end

@implementation PieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    self.pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) atPostiion:LegendPositionTop withNameArray:@[@"一工区",@"二工区",@"三工区"] andDataArray:@[@"100",@"100",@"100"]];
    self.pieChartView.pieDataUnit = @"元";
//    self.pieChartView.showPercentage = YES;
    //    self.pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    self.pieChartView.backgroundColor = [UIColor whiteColor];
    //    self.pieChartView.legendPostion = LegendPositionTop;
    //    NSArray *arr = @[@"一工区",@"二工区",@"三工区"];
    //    self.pieChartView.legendNameArray = arr;
    [self.view addSubview:self.pieChartView];
    [self.pieChartView resetData];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 80, 21)];
    btn1.backgroundColor = [UIColor cyanColor];
    [btn1 setTitle:@"重设数据" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
    
    self.pieChartView2 = [[PieChartView alloc] initWithFrame:CGRectMake(0, 321, self.view.frame.size.width, 200) atPostiion:LegendPositionBottom withNameArray:@[@"一工区",@"二工区",@"三工区"] andInsideDataArray:@[@"100",@"100",@"100"] andOutsideDataArray:@[@"100",@"100",@"100"]];
    self.pieChartView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pieChartView2];
    self.pieChartView2.pieDataNameArray = @[@"一小队",@"二小队",@"三小队"];
    self.pieChartView2.pieDataUnit = @"元";
    self.pieChartView2.showPercentage = YES;
    [self.pieChartView2 resetData];
    
    self.pieChartView3 = [[PieChartView alloc] initWithFrame:CGRectMake(0, 525, self.view.frame.size.width / 2 - 5, 200)];
    self.pieChartView3.backgroundColor = [UIColor whiteColor];
    self.pieChartView3.isDoubleCircle = NO;
    self.pieChartView3.legendPostion = LegendPositionTop;
    self.pieChartView3.legendNameArray = @[@"一工区",@"二工区",@"三工区"];
    self.pieChartView3.pieDataArray = @[@"100",@"100",@"100"];
    self.pieChartView3.radius = 35;
    self.pieChartView3.pieDataUnit = @"元";
    [self.view addSubview:self.pieChartView3];
    [self.pieChartView3 resetData];
    
    self.pieChartView4 = [[PieChartView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 5, 525, self.view.frame.size.width / 2 - 5, 200)];
    self.pieChartView4.backgroundColor = [UIColor cyanColor];
    self.pieChartView4.isDoubleCircle = YES;
    self.pieChartView4.legendPostion = LegendPositionBottom;
    self.pieChartView4.legendNameArray = @[@"一工区",@"二工区",@"三工区"];
    self.pieChartView4.pieInsideDataArray = @[@"100",@"100",@"100"];
    self.pieChartView4.pieOutsideDataArray = @[@"100",@"100",@"100"];
    self.pieChartView4.radius = 80;
    [self.view addSubview:self.pieChartView4];
    [self.pieChartView4 resetData];
    
    
}

- (void)btnAction1 {
    if (!self.isBtnClicked) {
        self.pieChartView.legendNameArray = @[@"一工区",@"二工区",@"三工区",@"四工区",@"五工区"];
        self.pieChartView.pieDataArray = @[@"100",@"200",@"300",@"100",@"100"];
        self.pieChartView2.pieInsideDataArray = @[@"100",@"300",@"500"];
        self.pieChartView2.pieOutsideDataArray = @[@"100",@"300",@"500"];
        self.pieChartView3.pieDataArray = @[@"100",@"200",@"300"];
        self.pieChartView4.pieInsideDataArray = @[@"100",@"200",@"300"];
        self.pieChartView4.pieOutsideDataArray = @[@"100",@"200",@"300"];
    } else {
        self.pieChartView.legendNameArray = @[@"一工区",@"二工区",@"三工区"];
        self.pieChartView.pieDataArray = @[@"100",@"100",@"100"];
        self.pieChartView2.pieInsideDataArray = @[@"100",@"100",@"100"];
        self.pieChartView2.pieOutsideDataArray = @[@"100",@"100",@"100"];
        self.pieChartView3.pieDataArray = @[@"100",@"100",@"100"];
        self.pieChartView4.pieInsideDataArray = @[@"100",@"100",@"100"];
        self.pieChartView4.pieOutsideDataArray = @[@"100",@"100",@"100"];
    }
    [self.pieChartView resetData];
    [self.pieChartView2 resetData];
    [self.pieChartView3 resetData];
    [self.pieChartView4 resetData];
    self.isBtnClicked = !self.isBtnClicked;
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
