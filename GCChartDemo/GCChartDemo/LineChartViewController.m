//
//  LineChartViewController.m
//  LineChartTest
//
//  Created by 古创 on 2019/5/13.
//  Copyright © 2019年 GC. All rights reserved.
//

#import "LineChartViewController.h"
#import "LineChartView.h"

@interface LineChartViewController ()

@property (nonatomic,strong) LineChartView *lineChartView;
@property (nonatomic,strong) LineChartView *lineChartView2;
@property (nonatomic,assign) BOOL isBtnClicked;

@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.lineChartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) andDataNameArray:@[@"一工区",@"二工区",@"三工区",@"项目部",@"一大队",@"二中队",@"三小队"] andDataArray:@[@"121",@"137",@"215",@"258",@"65",@"78",@"47"] andLineColor:@"#404040"];
    [self.view addSubview:self.lineChartView];
    self.lineChartView.backgroundColor = [UIColor whiteColor];
    self.lineChartView.showDataHorizontalLine = YES;
    self.lineChartView.lineWidth = 1;
//    self.lineChartView.lineColor = @"#dcdcdc";
    self.lineChartView.isSmooth = NO;
    self.lineChartView.isFillWithColor = NO;
    self.lineChartView.showDataLabel = YES;
    [self.lineChartView resetData];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 80, 21)];
    btn1.backgroundColor = [UIColor cyanColor];
    [btn1 setTitle:@"重设数据" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineChartView2 = [[LineChartView alloc] initWithFrame:CGRectMake(0, 321, self.view.frame.size.width, 200)];
    [self.view addSubview:self.lineChartView2];
    self.lineChartView2.backgroundColor = [UIColor whiteColor];
    self.lineChartView2.showDataHorizontalLine = YES;
    self.lineChartView2.lineWidth = 1;
    self.lineChartView2.isSmooth = NO;
    self.lineChartView2.isSingleLine = NO;
    self.lineChartView2.dataArray = @[@[@"121",@"137",@"215",@"258",@"65",@"78]",@"47"],@[@"150",@"167",@"168",@"120",@"100",@"20",@"179"],@[@"50",@"67",@"68",@"20",@"10",@"10",@"79"]];
    self.lineChartView2.dataNameArray = @[@"一工区",@"二工区",@"三工区",@"项目部",@"一大队",@"二中队",@"三小队"];
    self.lineChartView2.legendPostion = LegendPositionTop;
    self.lineChartView2.legendNameArray = @[@"收入",@"支出",@"总收支"];
//    self.lineChartView2.legendColorArray = @[@"#36d7a9",@"#898989",@"#dcdcdc"];
    self.lineChartView2.isSmooth = NO;
    self.lineChartView2.showDataLabel = NO;
    [self.lineChartView2 resetData];
    
}

- (void)btnAction1 {
    if (!self.isBtnClicked) {
        self.lineChartView.isSmooth = YES;
        self.lineChartView.isFillWithColor = YES;
        self.lineChartView.fillColor = @"#f9856c";
        self.lineChartView.fillAlpha = 0.3;
//        self.lineChartView.dataArray = @[@"78",@"44",@"99",@"321",@"248",@"100",@"41"];
        self.lineChartView2.dataArray = @[@[@"121",@"137",@"215",@"258",@"65",@"78]",@"47"],@[@"150",@"167",@"168",@"120",@"100",@"20",@"179"]];
        self.lineChartView2.legendNameArray = @[@"收入",@"支出"];
        self.lineChartView2.legendPostion = LegendPositionBottom;
        self.lineChartView2.isSmooth = YES;
        self.lineChartView2.showDataLabel = YES;
    } else {
        self.lineChartView.isSmooth = NO;
        self.lineChartView.isFillWithColor = NO;
//        self.lineChartView.dataArray = @[@"121",@"137",@"215",@"258",@"65",@"78",@"47"];
        self.lineChartView2.dataArray = @[@[@"121",@"137",@"215",@"258",@"65",@"78]",@"47"],@[@"150",@"167",@"168",@"120",@"100",@"20",@"179"],@[@"50",@"67",@"68",@"20",@"10",@"10",@"79"]];
        self.lineChartView2.legendNameArray = @[@"收入",@"支出",@"总收支"];
        self.lineChartView2.legendPostion = LegendPositionTop;
        self.lineChartView2.isSmooth = NO;
        self.lineChartView2.showDataLabel = NO;
    }
    
    [self.lineChartView resetData];
    [self.lineChartView2 resetData];
    self.isBtnClicked = !self.isBtnClicked;
}

@end
