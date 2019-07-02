//
//  ColumnChartViewController.m
//  ColumnChartTest
//
//  Created by 古创 on 2019/5/10.
//  Copyright © 2019年 chuang. All rights reserved.
//

#import "ColumnChartViewController.h"
#import "ColumnChartView.h"

@interface ColumnChartViewController ()

@property (nonatomic,strong) ColumnChartView *columnChartView;
@property (nonatomic,strong) ColumnChartView *columnChartView2;
@property (nonatomic,assign) BOOL isBtnClicked;

@end

@implementation ColumnChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.columnChartView = [[ColumnChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) andDataNameArray:@[@"一工区",@"二工区",@"三工区",@"项目部",@"一大队",@"二中队",@"三小队"] andDataArray:@[@"121",@"137",@"215",@"258",@"65",@"78",@"47"] andColumnColor:@"#fbca58"];
    self.columnChartView.isSingleColumn = YES;
    self.columnChartView.scrollEnabled = YES;
    self.columnChartView.backgroundColor = [UIColor whiteColor];
    self.columnChartView.isColumnGradientColor = YES;
    self.columnChartView.columnGradientColorArray = @[@"#2c8efa",@"#42cbfe"];
    [self.view addSubview:self.columnChartView];
    self.columnChartView.showDataLabel = YES;
    self.columnChartView.showDataHorizontalLine = YES;
    [self.columnChartView resetData];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 80, 21)];
    btn1.backgroundColor = [UIColor cyanColor];
    [btn1 setTitle:@"重设数据" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
    
    self.columnChartView2 = [[ColumnChartView alloc] initWithFrame:CGRectMake(0, 321, self.view.frame.size.width, 200)];
    [self.view addSubview:self.columnChartView2];
    self.columnChartView2.backgroundColor = [UIColor whiteColor];
    self.columnChartView2.isSingleColumn = NO;
    self.columnChartView2.scrollEnabled = YES;
    self.columnChartView2.isColumnGradientColor = YES;
//    self.columnChartView2.columnColor = @"#fbca58";
    self.columnChartView2.legendPostion = LegendPositionTop;
    self.columnChartView2.legendNameArray = @[@"收入金额",@"支出金额"];
//    self.columnChartView2.legendColorArray = @[@"#f88d5c",@"#42cbfe"];
    self.columnChartView2.columnGradientColorArray = @[@[@"#2c8efa",@"#42cbfe"],@[@"#f6457d",@"#f88d5c"],@[@"#00cd00",@"#00ff00"],@[@"#ffd700",@"#ffff00"]];//@[@[@"#2c8efa",@"#42cbfe"],@[@"#f6457d",@"#f88d5c"]];
    self.columnChartView2.dataNameArray = @[@"一工区",@"二工区",@"三工区",@"项目部",@"一大队",@"二中队",@"三小队"];
    self.columnChartView2.numberOfColumn = 2;
    self.columnChartView2.dataArray = @[@[@"121",@"121"],@[@"137",@"337"],@[@"215",@"115"],@[@"258",@"58"],@[@"65",@"365"],@[@"78",@"23"],@[@"47",@"135"]];
    self.columnChartView2.showDataLabel = YES;
    self.columnChartView2.showDataHorizontalLine = YES;
    [self.columnChartView2 resetData];
}

- (void)btnAction1 {
    if (!self.isBtnClicked) {
        self.columnChartView.columnGradientColorArray = @[@"#f6457d",@"#f88d5c"];
        self.columnChartView.dataArray = @[@"121",@"337",@"115",@"58",@"365",@"23",@"135"];
        self.columnChartView2.dataArray = @[@[@"121",@"121",@"221"],@[@"137",@"337",@"21"],@[@"215",@"115",@"150"],@[@"258",@"58",@"180"],@[@"65",@"365",@"89"],@[@"78",@"23",@"399"],@[@"47",@"135",@"100"]];
        self.columnChartView2.legendNameArray = @[@"收入金额",@"支出金额",@"乱写金额"];
    } else {
        self.columnChartView.columnGradientColorArray = @[@"#2c8efa",@"#42cbfe"];
        self.columnChartView.dataArray = @[@"121",@"137",@"215",@"258",@"65",@"78",@"47"];
        self.columnChartView2.dataArray = @[@[@"121",@"121"],@[@"137",@"337"],@[@"215",@"115"],@[@"258",@"58"],@[@"65",@"365"],@[@"78",@"23"],@[@"47",@"135"]];
        self.columnChartView2.legendNameArray = @[@"收入金额",@"支出金额"];
    }
    [self.columnChartView resetData];
    [self.columnChartView2 resetData];
    self.isBtnClicked = !self.isBtnClicked;
}



@end
