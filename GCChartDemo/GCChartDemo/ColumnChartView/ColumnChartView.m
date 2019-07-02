//
//  ColumnChartView.m
//  ColumnChartTest
//
//  Created by 古创 on 2019/5/10.
//  Copyright © 2019年 chuang. All rights reserved.
//

#import "ColumnChartView.h"

@interface ColumnChartView ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *colorArray;

@property (nonatomic,strong) UIView *yAxisView;
@property (nonatomic,strong) UIView *xAxisView;

@property (nonatomic,strong) UIView *legendBgView;

@end

@implementation ColumnChartView

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andDataNameArray:(NSArray *)dataNameArray andDataArray:(NSArray *)dataArray andColumnColor:(NSString *)colorString{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataNameArray = dataNameArray;
        self.dataArray = dataArray;
        self.columnColor = colorString;
        [self config];
    }
    return self;
}

- (instancetype)initNegativeYAxisWithFrame:(CGRect)frame andDataNameArray:(NSArray *)dataNameArray andDataArray:(NSArray *)dataArray andColumnColor:(NSString *)colorString{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataNameArray = dataNameArray;
        self.dataArray = dataArray;
        self.columnColor = colorString;
        self.isSingleColumn = YES;
        [self config];
    }
    return self;
}

// 配置一些控件和数据
- (void)config {
    if (self.legendColorArray.count == 0) {
        NSArray *arr = @[@"#308ff7",@"#fbca58",@"#f5447d",@"#a020f0",@"#00ffff",@"#00ff00"];
        self.colorArray = [NSMutableArray arrayWithArray:arr];
    }
    
    if (self.columnColor.length == 0) {
        self.columnColor = @"#308ff7";// 默认颜色
    }
    
    // y轴
    self.yAxisView = [[UIView alloc] init];
    self.yAxisView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.yAxisView];
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
//    self.scrollView.scrollEnabled = self.scrollEnabled;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    
    // x轴
    self.xAxisView = [[UIView alloc] init];
    self.xAxisView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.xAxisView];
    
    if (self.isSingleColumn) {
        self.columnWidth = self.columnWidth.length == 0 ? @"20":self.columnWidth;
    } else {
        
    }
    self.columnWidth = self.columnWidth.length == 0 ? @"20":self.columnWidth;
}

#pragma mark - setUI & resetUI
// 图例
- (void)resetLegend {
    // 先移除之前创建的
    for (UIView *view in self.legendBgView.subviews) {
        [view removeFromSuperview];
    }
    [self.legendBgView removeFromSuperview];
    self.legendBgView = nil;
    if (self.legendPostion == LegendPositionNone) {// 无图例的时候
        self.legendBgView = nil;
    } else {
        self.legendBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        [self addSubview:self.legendBgView];
        switch (self.legendPostion) {
            case LegendPositionTop:
                self.legendBgView.center = CGPointMake(self.bounds.size.width / 2, 10);
                break;
            case LegendPositionBottom:
                self.legendBgView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 10);
                break;
                
            default:
                break;
        }
        for (int i = 0; i < self.legendNameArray.count; i++) {
            UIView *colorPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            colorPoint.center = CGPointMake(8 + (5 + 50 + 10) * i, 10);
            colorPoint.layer.cornerRadius = 5;
            colorPoint.layer.masksToBounds = YES;
            [self.legendBgView addSubview:colorPoint];
            if (self.isColumnGradientColor) {
                NSArray *gradientColorArr = self.columnGradientColorArray[i];
                CAGradientLayer *legendGradientLayer = [CAGradientLayer layer];
                legendGradientLayer.frame = colorPoint.bounds;
                legendGradientLayer.colors = @[(__bridge id)[self colorWithHexString:gradientColorArr[0]].CGColor,
                                               (__bridge id)[self colorWithHexString:gradientColorArr[1]].CGColor];
                legendGradientLayer.locations = @[@(0.0),@(1.0)];// 颜色变化位置
                legendGradientLayer.startPoint = CGPointMake(0, 0);
                legendGradientLayer.endPoint = CGPointMake(0, 1);
                [colorPoint.layer addSublayer:legendGradientLayer];
            } else {
                colorPoint.backgroundColor = [self colorWithHexString:self.colorArray[i]];
            }
            
            UILabel *legendTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colorPoint.frame) + 2, 0, 50, 20)];
            legendTitle.text = self.legendNameArray[i];
            legendTitle.textColor = [UIColor blackColor];
            legendTitle.font = [UIFont systemFontOfSize:12];
            [self.legendBgView addSubview:legendTitle];
        }
    }
}

- (void)resetSingleColumn { // 单柱
    // scrollView
    switch (self.legendPostion) {
        case LegendPositionNone:
            self.yAxisView.frame = CGRectMake(0, 20, 30, self.bounds.size.height - 20);
            self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height);
            break;
        case LegendPositionTop:
            self.yAxisView.frame = CGRectMake(0, 40, 30, self.bounds.size.height - 40);
            self.scrollView.frame = CGRectMake(30, 20, self.bounds.size.width - 40, self.bounds.size.height - 20);
            break;
        case LegendPositionBottom:
            self.yAxisView.frame = CGRectMake(0, 20, 30, self.bounds.size.height - 40);
            self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height - 20);
            break;
            
        default:
            self.yAxisView.frame = CGRectMake(0, 0, 30, self.bounds.size.height);
            self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height);
            break;
    }
    self.scrollView.scrollEnabled = self.scrollEnabled;
    
    // y轴设置
    for (UIView *view in self.yAxisView.subviews) {
        [view removeFromSuperview];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(29, 0, 1, self.yAxisView.bounds.size.height - 20)];
    lineView.backgroundColor = [self colorWithHexString:@"#898989"];
    [self.yAxisView addSubview:lineView];
    int maxValue = [[self.dataArray valueForKeyPath:@"@max.intValue"] intValue];// 寻找数组中的最大值
    NSInteger maxNum = [self approximateRoundNumberWithString:[NSString stringWithFormat:@"%d",maxValue]];// 取近似最大值
    NSString *str = [[NSString stringWithFormat:@"%ld",(long)maxNum] substringToIndex:1];
    int level = (int)maxNum / [str intValue]; // 数量级 整十或整百或整千等
    for (int i = 0; i < [str intValue]; i++) {
        CGFloat lblY = self.yAxisView.bounds.size.height - 28 - i * (lineView.bounds.size.height / [str intValue]);
        UILabel *lblYAxisNum = [[UILabel alloc] initWithFrame:CGRectMake(0, lblY, 29, 16)];
        lblYAxisNum.font = [UIFont systemFontOfSize:8];
        lblYAxisNum.textColor = [self colorWithHexString:@"#898989"];
        lblYAxisNum.textAlignment = NSTextAlignmentCenter;
        lblYAxisNum.text = [NSString stringWithFormat:@"%d",i * level];
        [self.yAxisView addSubview:lblYAxisNum];
    }
    UILabel *lblMax = [[UILabel alloc] initWithFrame:CGRectMake(0, -8, 29, 16)];
    lblMax.font = [UIFont systemFontOfSize:8];
    lblMax.textColor = [self colorWithHexString:@"#898989"];
    lblMax.textAlignment = NSTextAlignmentCenter;
    lblMax.text = [NSString stringWithFormat:@"%ld",(long)maxNum];
    [self.yAxisView addSubview:lblMax];
//    UILabel *lblZero = [[UILabel alloc] initWithFrame:CGRectMake(0, self.yAxisView.bounds.size.height - 28, 29, 16)];
//    lblZero.font = [UIFont systemFontOfSize:8];
//    lblZero.textColor = [self colorWithHexString:@"#898989"];
//    lblZero.textAlignment = NSTextAlignmentCenter;
//    lblZero.text = @"0";
//    [self.yAxisView addSubview:lblZero];
    
    if (self.dataArray.count <= 5) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.width);
        self.xAxisView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 20, self.scrollView.bounds.size.width, 20);
    } else {
        CGFloat groupWidth = self.scrollView.bounds.size.width / 5;
        self.scrollView.contentSize = CGSizeMake(groupWidth * self.dataArray.count, self.scrollView.bounds.size.height);
        self.xAxisView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 20, groupWidth * self.dataArray.count, 20);
    }
    
    for (UIView *view in self.xAxisView.subviews) {
        [view removeFromSuperview];
    }
    UIView *xLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.xAxisView.bounds.size.width, 1)];
    xLineView.backgroundColor = [self colorWithHexString:@"#898989"];
    [self.xAxisView addSubview:xLineView];
    
    for (UIView *view in self.scrollView.subviews) {
        if (view != self.xAxisView) {
            [view removeFromSuperview];
        }
    }
    
    // 水平虚线
    if (self.showDataHorizontalLine) {
        for (int i = 0; i < [str intValue]; i++) {
            UIView *dashlineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height - 20 - (i + 1) * ((self.yAxisView.bounds.size.height - 20) / [str intValue]), self.scrollView.contentSize.width, 1)];
            [self.scrollView addSubview:dashlineView];
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            [lineLayer setBounds:dashlineView.bounds];
            [lineLayer setPosition:CGPointMake(CGRectGetWidth(dashlineView.frame) / 2, CGRectGetHeight(dashlineView.frame) / 2)];
            lineLayer.lineWidth = 0.5;
            [lineLayer setLineDashPattern:@[@2,@1]];
            lineLayer.strokeColor = [self colorWithHexString:@"#dcdcdc"].CGColor;
            //  设置路径
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, dashlineView.bounds.size.height / 2);
            CGPathAddLineToPoint(path, NULL, dashlineView.bounds.size.width, dashlineView.bounds.size.height / 2);
            [lineLayer setPath:path];
            CGPathRelease(path);
            [dashlineView.layer addSublayer:lineLayer];
        }
    }
    
    CGFloat groupWidth = self.scrollView.bounds.size.width / 5;
    for (int i = 0; i < self.dataArray.count; i++) {
        UIView *groupCenterLineView = [[UIView alloc] initWithFrame:CGRectMake(groupWidth * i + groupWidth / 2 - 0.5, 1, 1, 5)];
        groupCenterLineView.backgroundColor = [self colorWithHexString:@"#898989"];
        [self.xAxisView addSubview:groupCenterLineView];
        UILabel *lblGroupTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, groupWidth, 14)];
        lblGroupTitle.center = CGPointMake(groupWidth * i + groupWidth / 2, 13);
        lblGroupTitle.font = [UIFont systemFontOfSize:8];
        lblGroupTitle.textColor = [self colorWithHexString:@"#898989"];
        lblGroupTitle.textAlignment = NSTextAlignmentCenter;
        lblGroupTitle.text = self.dataNameArray[i];
        [self.xAxisView addSubview:lblGroupTitle];
        
        UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groupWidth, self.scrollView.bounds.size.height - 20)];
        dataView.center = CGPointMake(groupWidth * i + groupWidth / 2, dataView.center.y);
        [self.scrollView addSubview:dataView];
        
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        [bgPath moveToPoint:CGPointMake(dataView.bounds.size.width / 2, dataView.bounds.size.height)];
        [bgPath addLineToPoint:CGPointMake(dataView.bounds.size.width / 2, 0)];
        bgPath.lineWidth = groupWidth;
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        bgLayer.fillColor = [UIColor clearColor].CGColor;
        bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        bgLayer.strokeStart = 0;
        bgLayer.strokeEnd = 1;
        bgLayer.zPosition = 1;
        bgLayer.lineWidth = groupWidth;
        bgLayer.path = bgPath.CGPath;
        dataView.layer.mask = bgLayer;
        
        NSString *num = self.dataArray[i];
        CGFloat columnHeight = (self.yAxisView.bounds.size.height - 20) * [num intValue] / maxNum;
        UIBezierPath *columnPath = [UIBezierPath bezierPath];
        [columnPath moveToPoint:CGPointMake(dataView.bounds.size.width / 2, dataView.bounds.size.height)];
        [columnPath addLineToPoint:CGPointMake(dataView.bounds.size.width / 2, dataView.bounds.size.height - columnHeight)];
        columnPath.lineWidth = [self.columnWidth intValue];
        [[self colorWithHexString:self.columnColor] setStroke];
        [[self colorWithHexString:self.columnColor] setFill];
        [columnPath stroke];
        [columnPath fill];
        
        if (self.isColumnGradientColor) {
            CAGradientLayer *columnGradientLayer = [CAGradientLayer layer];
            columnGradientLayer.frame = CGRectMake(dataView.bounds.size.width / 2 - [self.columnWidth intValue] / 2, dataView.bounds.size.height - columnHeight, [self.columnWidth intValue], columnHeight);
            columnGradientLayer.colors = @[(__bridge id)[self colorWithHexString:self.columnGradientColorArray[0]].CGColor,
                                           (__bridge id)[self colorWithHexString:self.columnGradientColorArray[1]].CGColor];
            columnGradientLayer.locations = @[@(0.0),@(1.0)];// 颜色变化位置
            columnGradientLayer.startPoint = CGPointMake(0, 0);
            columnGradientLayer.endPoint = CGPointMake(0, 1);
            [dataView.layer addSublayer:columnGradientLayer];
            
        } else {
            CAShapeLayer *columnLayer = [CAShapeLayer layer];
            columnLayer.path = columnPath.CGPath;
            columnLayer.strokeColor = [self colorWithHexString:self.columnColor].CGColor;// 描边颜色
            columnLayer.fillColor = [self colorWithHexString:self.columnColor].CGColor;
            columnLayer.lineWidth = [self.columnWidth intValue];
            [dataView.layer addSublayer:columnLayer];
        }
        
        // 显示数据具体值
        if (self.showDataLabel) {
            UILabel *dataLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dataView.bounds.size.width, 16)];
            dataLable.center = CGPointMake(dataLable.bounds.size.width / 2, dataView.bounds.size.height - columnHeight - 8);
            dataLable.font = [UIFont systemFontOfSize:8];
            dataLable.textColor = [self colorWithHexString:@"#404040"];
            dataLable.textAlignment = NSTextAlignmentCenter;
            dataLable.text = self.dataArray[i];
            [dataView addSubview:dataLable];
        }
        
        // 动画
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @0;// 起始值
        strokeAnimation.toValue = @1;// 结束值
        strokeAnimation.duration = 1;// 动画持续时间
        strokeAnimation.repeatCount = 1;// 重复次数
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        strokeAnimation.removedOnCompletion = YES;
        [bgLayer addAnimation:strokeAnimation forKey:@"pieAnimation"];
    }
}

// 非单柱
- (void)resetMultiColumns {
    
    if (self.columnGradientColorArray.count == 0) {
        self.columnGradientColorArray = @[@[@"#2c8efa",@"#42cbfe"],@[@"#f6457d",@"#f88d5c"],@[@"#ffd700",@"#ffff00"],@[@"#00cd00",@"#00ff00"]];
    } else {
        NSArray *dataArr = self.dataArray[0];
        if (self.columnGradientColorArray.count < dataArr.count) {
            self.columnGradientColorArray = @[@[@"#2c8efa",@"#42cbfe"],@[@"#f6457d",@"#f88d5c"],@[@"#ffd700",@"#ffff00"],@[@"#00cd00",@"#00ff00"]];
        }
    }
    
    [self resetLegend];
    
    // scrollView
    switch (self.legendPostion) {
        case LegendPositionNone:
            self.yAxisView.frame = CGRectMake(0, 20, 30, self.bounds.size.height - 20);
            self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height);
            break;
        case LegendPositionTop:
            self.yAxisView.frame = CGRectMake(0, 40, 30, self.bounds.size.height - 40);
            self.scrollView.frame = CGRectMake(30, 20, self.bounds.size.width - 40, self.bounds.size.height - 20);
            break;
        case LegendPositionBottom:
            self.yAxisView.frame = CGRectMake(0, 20, 30, self.bounds.size.height - 40);
            self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height - 20);
            break;
            
        default:
            self.yAxisView.frame = CGRectMake(0, 0, 30, self.bounds.size.height);
            self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height);
            break;
    }
    self.scrollView.scrollEnabled = self.scrollEnabled;
    
    // y轴设置
    for (UIView *view in self.yAxisView.subviews) {
        [view removeFromSuperview];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(29, 0, 1, self.yAxisView.bounds.size.height - 20)];
    lineView.backgroundColor = [self colorWithHexString:@"#898989"];
    [self.yAxisView addSubview:lineView];
    NSMutableArray *array = [NSMutableArray array];
    for (NSArray *arr in self.dataArray) {
        int max = [[arr valueForKeyPath:@"@max.intValue"] intValue];// 寻找数组中的最大值
        [array addObject:[NSNumber numberWithInt:max]];
    }
    int maxValue = [[array valueForKeyPath:@"@max.intValue"] intValue];// 寻找数组中的最大值;
    NSInteger maxNum = [self approximateRoundNumberWithString:[NSString stringWithFormat:@"%d",maxValue]];// 取近似最大值
    NSString *str = [[NSString stringWithFormat:@"%ld",(long)maxNum] substringToIndex:1];
    int level = (int)maxNum / [str intValue]; // 数量级 整十或整百或整千等
    for (int i = 0; i < [str intValue]; i++) {
        CGFloat lblHeight = self.yAxisView.bounds.size.height - 28 - i * (lineView.bounds.size.height / [str intValue]);
        UILabel *lblYAxisNum = [[UILabel alloc] initWithFrame:CGRectMake(0, lblHeight, 29, 16)];
        lblYAxisNum.font = [UIFont systemFontOfSize:8];
        lblYAxisNum.textColor = [self colorWithHexString:@"#898989"];
        lblYAxisNum.textAlignment = NSTextAlignmentCenter;
        lblYAxisNum.text = [NSString stringWithFormat:@"%d",i * level];
        [self.yAxisView addSubview:lblYAxisNum];
    }
    UILabel *lblMax = [[UILabel alloc] initWithFrame:CGRectMake(0, -8, 29, 16)];
    lblMax.font = [UIFont systemFontOfSize:8];
    lblMax.textColor = [self colorWithHexString:@"#898989"];
    lblMax.textAlignment = NSTextAlignmentCenter;
    lblMax.text = [NSString stringWithFormat:@"%ld",(long)maxNum];
    [self.yAxisView addSubview:lblMax];
//    UILabel *lblZero = [[UILabel alloc] initWithFrame:CGRectMake(0, self.yAxisView.bounds.size.height - 28, 29, 16)];
//    lblZero.font = [UIFont systemFontOfSize:8];
//    lblZero.textColor = [self colorWithHexString:@"#898989"];
//    lblZero.textAlignment = NSTextAlignmentCenter;
//    lblZero.text = @"0";
//    [self.yAxisView addSubview:lblZero];
    
    if (self.dataArray.count <= 5) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.width);
        self.xAxisView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 20, self.scrollView.bounds.size.width, 20);
    } else {
        CGFloat groupWidth = self.scrollView.bounds.size.width / 5;
        self.scrollView.contentSize = CGSizeMake(groupWidth * self.dataArray.count, self.scrollView.bounds.size.height);
        self.xAxisView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 20, groupWidth * self.dataArray.count, 20);
    }
    for (UIView *view in self.xAxisView.subviews) {
        [view removeFromSuperview];
    }
    UIView *xLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.xAxisView.bounds.size.width, 1)];
    xLineView.backgroundColor = [self colorWithHexString:@"#898989"];
    [self.xAxisView addSubview:xLineView];
    
    for (UIView *view in self.scrollView.subviews) {
        if (view != self.xAxisView) {
            [view removeFromSuperview];
        }
    }
    
    // 水平虚线
    if (self.showDataHorizontalLine) {
        for (int i = 0; i < [str intValue]; i++) {
            UIView *dashlineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height - 20 - (i + 1) * ((self.yAxisView.bounds.size.height - 20) / [str intValue]), self.scrollView.contentSize.width, 1)];
            [self.scrollView addSubview:dashlineView];
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            [lineLayer setBounds:dashlineView.bounds];
            [lineLayer setPosition:CGPointMake(CGRectGetWidth(dashlineView.frame) / 2, CGRectGetHeight(dashlineView.frame) / 2)];
            lineLayer.lineWidth = 0.5;
            [lineLayer setLineDashPattern:@[@2,@1]];
            lineLayer.strokeColor = [self colorWithHexString:@"#dcdcdc"].CGColor;
            //  设置路径
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, dashlineView.bounds.size.height / 2);
            CGPathAddLineToPoint(path, NULL, dashlineView.bounds.size.width, dashlineView.bounds.size.height / 2);
            [lineLayer setPath:path];
            CGPathRelease(path);
            [dashlineView.layer addSublayer:lineLayer];
        }
    }
    
    CGFloat groupWidth = self.scrollView.bounds.size.width / 5;
    for (int i = 0; i < self.dataArray.count; i++) {
        UIView *groupCenterLineView = [[UIView alloc] initWithFrame:CGRectMake(groupWidth * i + groupWidth / 2 - 0.5, 1, 1, 5)];
        groupCenterLineView.backgroundColor = [self colorWithHexString:@"#898989"];
        [self.xAxisView addSubview:groupCenterLineView];
        UILabel *lblGroupTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, groupWidth, 14)];
        lblGroupTitle.center = CGPointMake(groupWidth * i + groupWidth / 2, 13);
        lblGroupTitle.font = [UIFont systemFontOfSize:8];
        lblGroupTitle.textColor = [self colorWithHexString:@"#898989"];
        lblGroupTitle.textAlignment = NSTextAlignmentCenter;
        lblGroupTitle.text = self.dataNameArray[i];
        [self.xAxisView addSubview:lblGroupTitle];
        
        UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groupWidth, self.scrollView.bounds.size.height - 20)];
        dataView.center = CGPointMake(groupWidth * i + groupWidth / 2, dataView.center.y);
        [self.scrollView addSubview:dataView];
        
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        [bgPath moveToPoint:CGPointMake(dataView.bounds.size.width / 2, dataView.bounds.size.height)];
        [bgPath addLineToPoint:CGPointMake(dataView.bounds.size.width / 2, 0)];
        bgPath.lineWidth = groupWidth;
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        bgLayer.fillColor = [UIColor clearColor].CGColor;
        bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        bgLayer.strokeStart = 0;
        bgLayer.strokeEnd = 1;
        bgLayer.zPosition = 1;
        bgLayer.lineWidth = groupWidth;
        bgLayer.path = bgPath.CGPath;
        dataView.layer.mask = bgLayer;
        
        NSArray *arr = self.dataArray[i];
        int numInEachGroup = (int)arr.count;
        for (int j = 0; j < numInEachGroup; j++) {
            NSString *num = arr[j];
            CGFloat columnHeight = (self.yAxisView.bounds.size.height - 20) * [num intValue] / maxNum;
            UIBezierPath *columnPath = [UIBezierPath bezierPath];
            CGFloat margin = 5;
//            CGFloat columnLeft = groupWidth / 2 - [self.columnWidth intValue] / 2 - (margin / 2) * (numInEachGroup) + ([self.columnWidth intValue] / numInEachGroup + margin) * j;
            CGFloat columnLeft = groupWidth / 2 - [self.columnWidth intValue] / 2 - (margin / 2) * (numInEachGroup - 1) + ([self.columnWidth intValue] / numInEachGroup + margin) * j;
            [columnPath moveToPoint:CGPointMake(columnLeft + [self.columnWidth intValue] / numInEachGroup / 2, dataView.bounds.size.height)];
            [columnPath addLineToPoint:CGPointMake(columnLeft + [self.columnWidth intValue] / numInEachGroup / 2, dataView.bounds.size.height - columnHeight)];
            columnPath.lineWidth = [self.columnWidth intValue] / numInEachGroup;
            [[self colorWithHexString:self.columnColor] setStroke];
            [[self colorWithHexString:self.columnColor] setFill];
            [columnPath stroke];
            [columnPath fill];
            
            if (self.isColumnGradientColor) {
                NSArray *gradientColorArr = self.columnGradientColorArray[j];
                CAGradientLayer *columnGradientLayer = [CAGradientLayer layer];
                columnGradientLayer.frame = CGRectMake(columnLeft, dataView.bounds.size.height - columnHeight, [self.columnWidth intValue] / numInEachGroup, columnHeight);
                columnGradientLayer.colors = @[(__bridge id)[self colorWithHexString:gradientColorArr[0]].CGColor,
                                               (__bridge id)[self colorWithHexString:gradientColorArr[1]].CGColor];
                columnGradientLayer.locations = @[@(0.0),@(1.0)];// 颜色变化位置
                columnGradientLayer.startPoint = CGPointMake(0, 0);
                columnGradientLayer.endPoint = CGPointMake(0, 1);
                [dataView.layer addSublayer:columnGradientLayer];
                
            } else {
                CAShapeLayer *columnLayer = [CAShapeLayer layer];
                columnLayer.path = columnPath.CGPath;
                columnLayer.strokeColor = [self colorWithHexString:self.columnColor].CGColor;// 描边颜色
                columnLayer.fillColor = [self colorWithHexString:self.columnColor].CGColor;
                columnLayer.lineWidth = [self.columnWidth intValue] / numInEachGroup;
                [dataView.layer addSublayer:columnLayer];
            }
            
            // 显示数据具体值
            if (self.showDataLabel) {
                UILabel *dataLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 16)];
                dataLable.center = CGPointMake(columnLeft + [self.columnWidth intValue] / numInEachGroup / 2, dataView.bounds.size.height - columnHeight - 8);
                dataLable.font = [UIFont systemFontOfSize:7];
                dataLable.textColor = [self colorWithHexString:@"#404040"];
                dataLable.textAlignment = NSTextAlignmentCenter;
                dataLable.text = self.dataArray[i][j];
                [dataView addSubview:dataLable];
            }
        }
        
        // 动画
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @0;// 起始值
        strokeAnimation.toValue = @1;// 结束值
        strokeAnimation.duration = 1;// 动画持续时间
        strokeAnimation.repeatCount = 1;// 重复次数
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        strokeAnimation.removedOnCompletion = YES;
        [bgLayer addAnimation:strokeAnimation forKey:@"pieAnimation"];
    }
}

// 带负轴单柱
- (void)resetSingleColumnWithNegativeYAxis {
    switch (self.legendPostion) {
        case LegendPositionNone:
            self.yAxisView.frame = CGRectMake(0, 20, 30, self.bounds.size.height - 20);
            self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height);
            break;
        case LegendPositionTop:
            self.yAxisView.frame = CGRectMake(0, 40, 30, self.bounds.size.height - 40);
            self.scrollView.frame = CGRectMake(30, 20, self.bounds.size.width - 40, self.bounds.size.height - 20);
            break;
        case LegendPositionBottom:
            self.yAxisView.frame = CGRectMake(0, 20, 30, self.bounds.size.height - 40);
            self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height - 20);
            break;
            
        default:
            self.yAxisView.frame = CGRectMake(0, 0, 30, self.bounds.size.height);
            self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height);
            break;
    }
    self.scrollView.scrollEnabled = self.scrollEnabled;
    
    // y轴设置
    for (UIView *view in self.yAxisView.subviews) {
        [view removeFromSuperview];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(29, 0, 1, self.yAxisView.bounds.size.height - 20)];
    lineView.backgroundColor = [self colorWithHexString:@"#898989"];
    [self.yAxisView addSubview:lineView];
    int maxValue = [[self.dataArray valueForKeyPath:@"@max.intValue"] intValue];// 寻找数组中的最大值
    int minValue = [[self.dataArray valueForKeyPath:@"@min.intValue"] intValue];// 寻找数组中的最小值
    
    NSInteger maxNum = [self approximateRoundNumberWithString:[NSString stringWithFormat:@"%d",MAX(ABS(maxValue), ABS(minValue))]];// 取近似最大值;
    
    NSString *str = [[NSString stringWithFormat:@"%ld",(long)maxNum] substringToIndex:1];
    int level = (int)maxNum / [str intValue]; // 数量级 整十或整百或整千等
    int temp = [str intValue];

    CGFloat zeroY = 0;
    
    for (int i = 0; i < [str intValue] * 2; i++) {
        CGFloat lblY = self.yAxisView.bounds.size.height - 28 - i * (lineView.bounds.size.height / [str intValue] / 2);
        UILabel *lblYAxisNum = [[UILabel alloc] initWithFrame:CGRectMake(0, lblY, 29, 16)];
        lblYAxisNum.font = [UIFont systemFontOfSize:8];
        lblYAxisNum.textColor = [self colorWithHexString:@"#898989"];
        lblYAxisNum.textAlignment = NSTextAlignmentCenter;
        lblYAxisNum.text = [NSString stringWithFormat:@"%d",(i - temp) * level];
        [self.yAxisView addSubview:lblYAxisNum];
        if (i == temp - 1) {
            zeroY = lblY;
        }
    }
    UILabel *lblMax = [[UILabel alloc] initWithFrame:CGRectMake(0, -8, 29, 16)];
    lblMax.font = [UIFont systemFontOfSize:8];
    lblMax.textColor = [self colorWithHexString:@"#898989"];
    lblMax.textAlignment = NSTextAlignmentCenter;
    lblMax.text = [NSString stringWithFormat:@"%ld",(long)maxNum];
    [self.yAxisView addSubview:lblMax];
    
    if (self.dataArray.count <= 5) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.width);
        self.xAxisView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 20, self.scrollView.bounds.size.width, 20);
    } else {
        CGFloat groupWidth = self.scrollView.bounds.size.width / 5;
        self.scrollView.contentSize = CGSizeMake(groupWidth * self.dataArray.count, self.scrollView.bounds.size.height);
        self.xAxisView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 20, groupWidth * self.dataArray.count, 20);
    }
    
    for (UIView *view in self.xAxisView.subviews) {
        [view removeFromSuperview];
    }
    UIView *xLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.xAxisView.bounds.size.width, 1)];
    xLineView.backgroundColor = [self colorWithHexString:@"#898989"];
    [self.xAxisView addSubview:xLineView];
    
    for (UIView *view in self.scrollView.subviews) {
        if (view != self.xAxisView) {
            [view removeFromSuperview];
        }
    }
    
    // 水平虚线
    if (self.showDataHorizontalLine) {
        for (int i = 0; i < [str intValue] * 2; i++) {
            if (i == temp - 1) {
                UIView *dashlineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height - 20 - (i + 1) * ((self.yAxisView.bounds.size.height - 20) / [str intValue] / 2), self.scrollView.contentSize.width, 1)];
                [self.scrollView addSubview:dashlineView];
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                [lineLayer setBounds:dashlineView.bounds];
                [lineLayer setPosition:CGPointMake(CGRectGetWidth(dashlineView.frame) / 2, CGRectGetHeight(dashlineView.frame) / 2)];
                lineLayer.lineWidth = 1;
                lineLayer.strokeColor = [self colorWithHexString:@"#898989"].CGColor;
                //  设置路径
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL, 0, dashlineView.bounds.size.height / 2);
                CGPathAddLineToPoint(path, NULL, dashlineView.bounds.size.width, dashlineView.bounds.size.height / 2);
                [lineLayer setPath:path];
                CGPathRelease(path);
                [dashlineView.layer addSublayer:lineLayer];
            } else {
                UIView *dashlineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height - 20 - (i + 1) * ((self.yAxisView.bounds.size.height - 20) / [str intValue] / 2), self.scrollView.contentSize.width, 1)];
                [self.scrollView addSubview:dashlineView];
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                [lineLayer setBounds:dashlineView.bounds];
                [lineLayer setPosition:CGPointMake(CGRectGetWidth(dashlineView.frame) / 2, CGRectGetHeight(dashlineView.frame) / 2)];
                lineLayer.lineWidth = 0.5;
                [lineLayer setLineDashPattern:@[@2,@1]];
                lineLayer.strokeColor = [self colorWithHexString:@"#dcdcdc"].CGColor;
                //  设置路径
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL, 0, dashlineView.bounds.size.height / 2);
                CGPathAddLineToPoint(path, NULL, dashlineView.bounds.size.width, dashlineView.bounds.size.height / 2);
                [lineLayer setPath:path];
                CGPathRelease(path);
                [dashlineView.layer addSublayer:lineLayer];
            }
        }
    }
    
    CGFloat groupWidth = self.scrollView.bounds.size.width / 5;
    for (int i = 0; i < self.dataArray.count; i++) {
        UIView *groupCenterLineView = [[UIView alloc] initWithFrame:CGRectMake(groupWidth * i + groupWidth / 2 - 0.5, 1, 1, 5)];
        groupCenterLineView.backgroundColor = [self colorWithHexString:@"#898989"];
        [self.xAxisView addSubview:groupCenterLineView];
        UILabel *lblGroupTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, groupWidth, 14)];
        lblGroupTitle.center = CGPointMake(groupWidth * i + groupWidth / 2, 13);
        lblGroupTitle.font = [UIFont systemFontOfSize:8];
        lblGroupTitle.textColor = [self colorWithHexString:@"#898989"];
        lblGroupTitle.textAlignment = NSTextAlignmentCenter;
        lblGroupTitle.text = self.dataNameArray[i];
        [self.xAxisView addSubview:lblGroupTitle];
        
        UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groupWidth, self.scrollView.bounds.size.height - 20)];
        dataView.center = CGPointMake(groupWidth * i + groupWidth / 2, dataView.center.y);
        [self.scrollView addSubview:dataView];
        
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        [bgPath moveToPoint:CGPointMake(dataView.bounds.size.width / 2, dataView.bounds.size.height / 2 + 10)];
        NSString *num = self.dataArray[i];
        if ([num floatValue] > 0) {
            [bgPath addLineToPoint:CGPointMake(dataView.bounds.size.width / 2, 0)];
        } else {
            [bgPath addLineToPoint:CGPointMake(dataView.bounds.size.width / 2, dataView.bounds.size.height + 10)];
        }
        bgPath.lineWidth = groupWidth;
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        bgLayer.fillColor = [UIColor clearColor].CGColor;
        bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        bgLayer.strokeStart = 0;
        bgLayer.strokeEnd = 1;
        bgLayer.zPosition = 1;
        bgLayer.lineWidth = groupWidth;
        bgLayer.path = bgPath.CGPath;
        dataView.layer.mask = bgLayer;
        
        CGFloat columnHeight = dataView.bounds.size.height / 2 * [num intValue] / maxNum;
        if ([num intValue] < 0) {
            columnHeight = columnHeight - 1;
        }
        UIBezierPath *columnPath = [UIBezierPath bezierPath];
        [columnPath moveToPoint:CGPointMake(dataView.bounds.size.width / 2, dataView.bounds.size.height / 2 + ([num intValue] < 0 ? 11 : 10))];
        [columnPath addLineToPoint:CGPointMake(dataView.bounds.size.width / 2, dataView.bounds.size.height / 2 - columnHeight + 10)];
        columnPath.lineWidth = [self.columnWidth intValue];
        [[self colorWithHexString:self.columnColor] setStroke];
        [[self colorWithHexString:self.columnColor] setFill];
        [columnPath stroke];
        [columnPath fill];
        
        if (self.isColumnGradientColor) {
            CAGradientLayer *columnGradientLayer = [CAGradientLayer layer];
            columnGradientLayer.frame = CGRectMake(dataView.bounds.size.width / 2 - [self.columnWidth intValue] / 2, dataView.bounds.size.height / 2 - columnHeight + ([num intValue] < 0 ? 11 : 10), [self.columnWidth intValue], columnHeight);
            columnGradientLayer.colors = @[(__bridge id)[self colorWithHexString:self.columnGradientColorArray[0]].CGColor,
                                           (__bridge id)[self colorWithHexString:self.columnGradientColorArray[1]].CGColor];
            columnGradientLayer.locations = @[@(0.0),@(1.0)];// 颜色变化位置
            columnGradientLayer.startPoint = CGPointMake(0, 0);
            columnGradientLayer.endPoint = CGPointMake(0, 1);
            if ([num intValue] < 0) {
                columnGradientLayer.startPoint = CGPointMake(0, 1);
                columnGradientLayer.endPoint = CGPointMake(0, 0);
            }
            [dataView.layer addSublayer:columnGradientLayer];
            
        } else {
            CAShapeLayer *columnLayer = [CAShapeLayer layer];
            columnLayer.path = columnPath.CGPath;
            columnLayer.strokeColor = [self colorWithHexString:self.columnColor].CGColor;// 描边颜色
            columnLayer.fillColor = [self colorWithHexString:self.columnColor].CGColor;
            columnLayer.lineWidth = [self.columnWidth intValue];
            [dataView.layer addSublayer:columnLayer];
        }
        
        // 显示数据具体值
        if (self.showDataLabel) {
            UILabel *dataLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dataView.bounds.size.width, 16)];
            dataLable.center = CGPointMake(dataLable.bounds.size.width / 2, dataView.bounds.size.height / 2 - columnHeight - 8 + ([num intValue] < 0 ? 21 + 8 : 10));
            dataLable.font = [UIFont systemFontOfSize:8];
            dataLable.textColor = [self colorWithHexString:@"#404040"];
            dataLable.textAlignment = NSTextAlignmentCenter;
            dataLable.text = self.dataArray[i];
            [dataView addSubview:dataLable];
        }
        
        // 动画
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @0;// 起始值
        strokeAnimation.toValue = @1;// 结束值
        strokeAnimation.duration = 1;// 动画持续时间
        strokeAnimation.repeatCount = 1;// 重复次数
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        strokeAnimation.removedOnCompletion = YES;
        [bgLayer addAnimation:strokeAnimation forKey:@"pieAnimation"];
        
    }
}

#pragma mark - resetData
-(void)resetData {
    if (self.isSingleColumn) {
        if (self.didHaveNegativeYAxis) {
            [self resetSingleColumnWithNegativeYAxis];
        } else {
            [self resetSingleColumn];
        }
    } else {
        [self resetMultiColumns];
    }
    
}

#pragma mark - getter
- (NSArray *)legendNameArray {
    if (!_legendNameArray) {
        _legendNameArray = [NSArray array];
    }
    return _legendNameArray;
}

- (NSArray *)dataNameArray {
    if (!_dataNameArray) {
        _dataNameArray = [NSArray array];
    }
    return _dataNameArray;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (NSArray *)legendColorArray {
    if (!_legendColorArray) {
        _legendColorArray = [NSArray array];
    }
    return _legendColorArray;
}

- (NSArray *)columnGradientColorArray {
    if (!_columnGradientColorArray) {
        _columnGradientColorArray = [NSArray array];
    }
    return _columnGradientColorArray;
}
- (NSMutableArray *)colorArray {
    if (!_colorArray) {
        _colorArray = [NSMutableArray array];
    }
    return _colorArray;
}

#pragma mark - other
// 向上取整十、整百、整千等值
- (int)approximateRoundNumberWithString:(NSString *)numString {
    NSInteger length = numString.length;
    NSString *numberGrade = @"1";// 数字量级
    for (int i = 0; i < length - 1; i++) {
        numberGrade = [numberGrade stringByAppendingString:@"0"];
    }
    return ceil((double)[numString intValue] / [numberGrade intValue]) * [numberGrade intValue];
}

- (UIColor *)colorWithHexString:(NSString *)color {
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0];
}
@end
