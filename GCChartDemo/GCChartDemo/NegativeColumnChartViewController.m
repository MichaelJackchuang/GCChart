//
//  NegativeColumnChartViewController.m
//  GCChartDemo
//
//  Created by 古创 on 2019/7/1.
//  Copyright © 2019年 GC. All rights reserved.
//

#import "NegativeColumnChartViewController.h"
#import "ColumnChartView.h"

@interface NegativeColumnChartViewController ()

@property (nonatomic,strong) ColumnChartView *columnChartView;

@property (nonatomic,assign) BOOL isBtnClicked;

@end

@implementation NegativeColumnChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.columnChartView = [[ColumnChartView alloc] initNegativeYAxisWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 400) andDataNameArray:@[@"一工区",@"二工区",@"三工区",@"项目部",@"一大队",@"二中队",@"三小队"] andDataArray:@[@"121",@"-137",@"-215",@"258",@"-65",@"78",@"47"] andColumnColor:@"#fbca58"];
    self.columnChartView.scrollEnabled = YES;
    self.columnChartView.backgroundColor = [UIColor whiteColor];
    self.columnChartView.didHaveNegativeYAxis = YES;// 带负y轴
    self.columnChartView.showDataHorizontalLine = YES;
    self.columnChartView.showDataLabel = YES;
    self.columnChartView.isColumnGradientColor = YES;
    self.columnChartView.columnGradientColorArray = @[@"#2c8efa",@"#42cbfe"];
    [self.view addSubview:self.columnChartView];
    [self.columnChartView resetData];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 550, 80, 40)];
    btn1.backgroundColor = [UIColor cyanColor];
    [btn1 setTitle:@"重设数据" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction1 {
    if (!self.isBtnClicked) {
        self.columnChartView.columnGradientColorArray = @[@"#f6457d",@"#f88d5c"];
        self.columnChartView.dataArray = @[@"121",@"-337",@"115",@"58",@"365",@"-23",@"135"];
    } else {
        self.columnChartView.columnGradientColorArray = @[@"#2c8efa",@"#42cbfe"];
        self.columnChartView.dataArray = @[@"121",@"-137",@"-215",@"258",@"-65",@"78",@"47"];
    }
    [self.columnChartView resetData];
    self.isBtnClicked = !self.isBtnClicked;
}

@end
