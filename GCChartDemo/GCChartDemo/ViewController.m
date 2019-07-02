//
//  ViewController.m
//  GCChartDemo
//
//  Created by 古创 on 2019/5/13.
//  Copyright © 2019年 GC. All rights reserved.
//

#import "ViewController.h"
#import "PieChartViewController.h"
#import "ColumnChartViewController.h"
#import "LineChartViewController.h"
#import "CircleRingChartViewController.h"
#import "NegativeColumnChartViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(70, 100, 50, 50)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"扇形图" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(170, 100, 50, 50)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"柱状图" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(btnAction2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(270, 100, 50, 50)];
    btn3.backgroundColor = [UIColor redColor];
    [btn3 setTitle:@"折线图" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(btnAction3) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(70, 200, 50, 50)];
    btn4.backgroundColor = [UIColor redColor];
    [btn4 setTitle:@"圆环图" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn4];
    [btn4 addTarget:self action:@selector(btnAction4) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(170, 200, 80, 50)];
    btn5.backgroundColor = [UIColor redColor];
    [btn5 setTitle:@"负轴柱状图" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn5];
    [btn5 addTarget:self action:@selector(btnAction5) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnAction1 {
    PieChartViewController *pieChartVC = [[PieChartViewController alloc] init];
    [self.navigationController pushViewController:pieChartVC animated:YES];
}

- (void)btnAction2 {
    ColumnChartViewController *columnChartVC = [[ColumnChartViewController alloc] init];
    [self.navigationController pushViewController:columnChartVC animated:YES];
}

- (void)btnAction3 {
    LineChartViewController *columnChartVC = [[LineChartViewController alloc] init];
    [self.navigationController pushViewController:columnChartVC animated:YES];
}

- (void)btnAction4 {
    CircleRingChartViewController *columnChartVC = [[CircleRingChartViewController alloc] init];
    [self.navigationController pushViewController:columnChartVC animated:YES];
}

- (void)btnAction5 {
    NegativeColumnChartViewController *columnChartVC = [[NegativeColumnChartViewController alloc] init];
    [self.navigationController pushViewController:columnChartVC animated:YES];
}


@end
