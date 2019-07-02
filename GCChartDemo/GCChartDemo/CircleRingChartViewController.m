//
//  CircleRingChartViewController.m
//  GCChartDemo
//
//  Created by 古创 on 2019/6/5.
//  Copyright © 2019年 GC. All rights reserved.
//

#import "CircleRingChartViewController.h"
#import "CircleRingChartView.h"

@interface CircleRingChartViewController ()

@property (nonatomic,strong) CircleRingChartView *circleRingChartView;
@property (nonatomic,assign) BOOL isBtnClicked;

@end

@implementation CircleRingChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.circleRingChartView = [[CircleRingChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) atPostiion:LegendPositionTop withNameArray:@[@"一工区",@"二工区",@"三工区"] andDataArray:@[@"100",@"100",@"100"] andRadius:60 andLineWidth:20];
    self.circleRingChartView.backgroundColor = [UIColor whiteColor];
    self.circleRingChartView.showPercentage = NO;
    self.circleRingChartView.touchEnable = YES;
    self.circleRingChartView.centerTitle = @"产值";
    [self.view addSubview:self.circleRingChartView];
    [self.circleRingChartView resetData];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 80, 21)];
    btn1.backgroundColor = [UIColor cyanColor];
    [btn1 setTitle:@"重设数据" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnAction1 {
    if (!self.isBtnClicked) {
        self.circleRingChartView.pieDataArray = @[@"100",@"200",@"300"];
        self.circleRingChartView.showPercentage = YES;
    } else {
        self.circleRingChartView.pieDataArray = @[@"100",@"100",@"100"];
        self.circleRingChartView.showPercentage = NO;
    }
    [self.circleRingChartView resetData];
    self.isBtnClicked = !self.isBtnClicked;
}



@end
