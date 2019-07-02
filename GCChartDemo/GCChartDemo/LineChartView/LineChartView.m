//
//  LineChartView.m
//  LineChartTest
//
//  Created by 古创 on 2019/5/13.
//  Copyright © 2019年 GC. All rights reserved.
//

#import "LineChartView.h"

@interface LineChartView ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *yAxisView;
@property (nonatomic,strong) UIView *xAxisView;
@property (nonatomic,strong) UIView *dataView;
@property (nonatomic,strong) UIView *legendBgView;
@property (nonatomic,strong) NSMutableArray *pointArray;
@property (nonatomic,strong) NSMutableArray *colorArray;

@end

@implementation LineChartView

#pragma mark - init


- (instancetype)init
{
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

- (instancetype)initWithFrame:(CGRect)frame andDataNameArray:(NSArray *)dataNameArray andDataArray:(NSArray *)dataArray andLineColor:(NSString *)colorString {
    self = [super initWithFrame:frame];
    if (self) {
        self.isSingleLine = YES;
        self.dataNameArray = dataNameArray;
        self.dataArray = dataArray;
        self.lineColor = colorString;
        [self config];
    }
    return self;
}

// 配置一些默认属性
- (void)config {
    self.lineWidth = 2;
    if (self.lineColor.length == 0) {
        self.lineColor = @"#404040";
    }
    if (self.fillAlpha == 0) {
        self.fillAlpha = 1.0;
    }
    
    if (self.legendColorArray.count == 0) {
        NSArray *arr = @[@"#308ff7",@"#fbca58",@"#f5447d",@"#a020f0",@"#00ffff",@"#00ff00"];
        self.colorArray = [NSMutableArray arrayWithArray:arr];
    }
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    // y轴
    self.yAxisView = [[UIView alloc] init];
    self.yAxisView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.yAxisView];
    
    // x轴
    self.xAxisView = [[UIView alloc] init];
    self.xAxisView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.xAxisView];
    
    // 数据view
//    self.dataView = [[UIView alloc] init];
//    self.dataView.backgroundColor = [UIColor whiteColor];
//    [self.scrollView addSubview:self.dataView];
}

#pragma mark - setUI & resetUI
// 单条折线
- (void)resetSingleLine {
    self.yAxisView.frame = CGRectMake(0, 20, 30, self.bounds.size.height - 20);
    self.scrollView.frame = CGRectMake(30, 0, self.bounds.size.width - 40, self.bounds.size.height);
    
    for (UIView *view in self.yAxisView.subviews) {
        [view removeFromSuperview];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(29, 0, 1, self.yAxisView.bounds.size.height - 20)];
    lineView.backgroundColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
    [self.yAxisView addSubview:lineView];
    
    int maxValue = [[self.dataArray valueForKeyPath:@"@max.intValue"] intValue];// 寻找数组中的最大值
    NSInteger maxNum = [self approximateRoundNumberWithString:[NSString stringWithFormat:@"%d",maxValue]];// 取近似最大值
    NSString *str = [[NSString stringWithFormat:@"%ld",(long)maxNum] substringToIndex:1];
    int level = (int)maxNum / [str intValue]; // 数量级 整十或整百或整千等
    for (int i = 0; i < [str intValue]; i++) {
        CGFloat lblY = self.yAxisView.bounds.size.height - 28 - i * (lineView.bounds.size.height / [str intValue]);
        UILabel *lblYAxisNum = [[UILabel alloc] initWithFrame:CGRectMake(0, lblY, 29, 16)];
        lblYAxisNum.font = [UIFont systemFontOfSize:8];
        lblYAxisNum.textColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
        lblYAxisNum.textAlignment = NSTextAlignmentCenter;
        lblYAxisNum.text = [NSString stringWithFormat:@"%d",i * level];
        [self.yAxisView addSubview:lblYAxisNum];
    }
    UILabel *lblMax = [[UILabel alloc] initWithFrame:CGRectMake(0, -8, 29, 16)];
    lblMax.font = [UIFont systemFontOfSize:8];
    lblMax.textColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
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
    xLineView.backgroundColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
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
            lineLayer.strokeColor = [self colorWithHexString:@"#dcdcdc" andAlpha:1.0].CGColor;
            //  设置路径
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, dashlineView.bounds.size.height / 2);
            CGPathAddLineToPoint(path, NULL, dashlineView.bounds.size.width, dashlineView.bounds.size.height / 2);
            [lineLayer setPath:path];
            CGPathRelease(path);
            [dashlineView.layer addSublayer:lineLayer];
        }
    }
    
    [self.dataView removeFromSuperview];
    self.dataView = nil;
    self.dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.bounds.size.height - 20)];
    [self.scrollView addSubview:self.dataView];
    
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    [bgPath moveToPoint:CGPointMake(0, self.dataView.bounds.size.height / 2)];
    [bgPath addLineToPoint:CGPointMake(self.dataView.bounds.size.width, self.dataView.bounds.size.height / 2)];
    bgPath.lineWidth = self.dataView.bounds.size.height;
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.fillColor = [UIColor clearColor].CGColor;
    bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    bgLayer.strokeStart = 0;
    bgLayer.strokeEnd = 1;
    bgLayer.zPosition = 1;
    bgLayer.lineWidth = self.dataView.bounds.size.height;
    bgLayer.path = bgPath.CGPath;
    self.dataView.layer.mask = bgLayer;
    
    UIBezierPath *dataPath = [UIBezierPath bezierPath];
    dataPath.lineWidth = self.lineWidth;
    [[self colorWithHexString:self.lineColor andAlpha:1.0] setStroke];
    [[self colorWithHexString:self.lineColor andAlpha:1.0] setFill];
    [dataPath stroke];
    [dataPath fill];
    
    [self.pointArray removeAllObjects];
    // 起始点
    [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, self.dataView.bounds.size.height)]];
    
    CGFloat groupWidth = self.scrollView.bounds.size.width / 5;
    for (int i = 0; i < self.dataArray.count; i++) {
        UIView *groupCenterLineView = [[UIView alloc] initWithFrame:CGRectMake(groupWidth * i + groupWidth / 2 - 0.5, 1, 1, 5)];
        groupCenterLineView.backgroundColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
        [self.xAxisView addSubview:groupCenterLineView];
        
        // 分组标题
        UILabel *lblGroupTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, groupWidth, 14)];
        lblGroupTitle.center = CGPointMake(groupWidth * i + groupWidth / 2, 13);
        lblGroupTitle.font = [UIFont systemFontOfSize:8];
        lblGroupTitle.textColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
        lblGroupTitle.textAlignment = NSTextAlignmentCenter;
        lblGroupTitle.text = self.dataNameArray[i];
        [self.xAxisView addSubview:lblGroupTitle];
        
        //
        UIView *groupDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groupWidth, self.scrollView.bounds.size.height - 20)];
        groupDataView.center = CGPointMake(groupWidth * i + groupWidth / 2, groupDataView.center.y);
        [self.scrollView addSubview:groupDataView];
        
        // 具体数据
        NSString *num = self.dataArray[i];
        CGFloat pointHeight = self.dataView.bounds.size.height - (self.dataView.bounds.size.height - 20) * [num intValue] / maxNum;
        if (self.isSmooth) {// 是否为平滑曲线
            [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(groupWidth / 2 + groupWidth * i, pointHeight)]];
        } else {
            if (i == 0) {
                if (self.isFillWithColor) {
                    [dataPath moveToPoint:CGPointMake(groupWidth / 2, self.dataView.bounds.size.height)];
                    [dataPath addLineToPoint:CGPointMake(groupWidth / 2, pointHeight)];
                } else {
                    [dataPath moveToPoint:CGPointMake(groupWidth / 2, pointHeight)];
                }
            } else if (i == self.dataArray.count - 1) {
                [dataPath addLineToPoint:CGPointMake(groupWidth / 2 + groupWidth * i, pointHeight)];
                if (self.isFillWithColor) {
                    [dataPath addLineToPoint:CGPointMake(groupWidth / 2 + groupWidth * i, self.dataView.bounds.size.height)];
                }
            } else {
                [dataPath addLineToPoint:CGPointMake(groupWidth / 2 + groupWidth * i, pointHeight)];
            }
        }
    }
    
    if (self.isSmooth) {
        // 添加结束点
        [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.dataView.bounds.size.width, self.dataView.bounds.size.height)]];
        for (int i = 0; i < self.dataArray.count - 1; i++) {
            CGPoint p1 = [self.pointArray[i] CGPointValue];
            CGPoint p2 = [self.pointArray[i+1] CGPointValue];
            CGPoint p3 = [self.pointArray[i+2] CGPointValue];
            CGPoint p4 = [self.pointArray[i+3] CGPointValue];
            if (i == 0) {
                if (self.isFillWithColor) {
                    [dataPath moveToPoint:CGPointMake(groupWidth / 2, self.dataView.bounds.size.height)];
                    [dataPath addLineToPoint:p2];
                } else {
                    [dataPath moveToPoint:p2];
                    [dataPath addLineToPoint:CGPointMake(groupWidth / 2, self.dataView.bounds.size.height)];
                }
            }
            [self getControlPointOfBezierPath:dataPath andPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y];
        }
        if (self.isFillWithColor) {
            [dataPath addLineToPoint:CGPointMake(groupWidth / 2 + groupWidth * (self.dataArray.count - 1), self.dataView.bounds.size.height)];
//            [dataPath addLineToPoint:CGPointMake(groupWidth / 2, self.dataView.bounds.size.height)];
        }
    }
    
    CAShapeLayer *dataLayer = [CAShapeLayer layer];
    dataLayer.path = dataPath.CGPath;
    if (self.isFillWithColor) {
        dataLayer.strokeColor = nil;//[self colorWithHexString:self.lineColor].CGColor;
        dataLayer.fillColor = [self colorWithHexString:self.fillColor  andAlpha:self.fillAlpha].CGColor;
    } else {
        dataLayer.strokeColor = [self colorWithHexString:self.lineColor andAlpha:1.0].CGColor;
        dataLayer.fillColor = nil;//[self colorWithHexString:self.lineColor].CGColor;
    }
    dataLayer.lineWidth = self.lineWidth;
    [self.dataView.layer addSublayer:dataLayer];
    
    // 显示数据具体值
    if (self.showDataLabel) {
        for (int i = 0; i < self.dataArray.count; i++) {
            NSString *num = self.dataArray[i];
            CGFloat pointHeight = self.dataView.bounds.size.height - (self.dataView.bounds.size.height - 20) * [num intValue] / maxNum;
            UILabel *dataLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, groupWidth, 16)];
            dataLable.center = CGPointMake(groupWidth / 2 + groupWidth * i, pointHeight - 8);
            dataLable.font = [UIFont systemFontOfSize:8];
            dataLable.textColor = [self colorWithHexString:@"#404040" andAlpha:1.0];
            dataLable.textAlignment = NSTextAlignmentCenter;
            dataLable.text = self.dataArray[i];
            [self.dataView addSubview:dataLable];
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

// 多条折线
- (void)resetMultiLine {
    if (self.legendColorArray.count == 0 || self.legendColorArray.count < self.dataArray.count) {
        NSArray *arr = @[@"#308ff7",@"#fbca58",@"#f5447d",@"#a020f0",@"#00ffff",@"#00ff00"];
        self.colorArray = [NSMutableArray arrayWithArray:arr];
    } else {
        self.colorArray = [NSMutableArray arrayWithArray:self.legendColorArray];
    }
    
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
            UIView *colorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 2)];
            colorLine.center = CGPointMake(20 + (10 + 50 + 20) * i, 10);
//            colorLine.layer.cornerRadius = 5;
//            colorLine.layer.masksToBounds = YES;
            [self.legendBgView addSubview:colorLine];
            colorLine.backgroundColor = [self colorWithHexString:self.colorArray[i] andAlpha:1.0];

            UILabel *legendTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colorLine.frame) + 2, 0, 50, 20)];
            legendTitle.text = self.legendNameArray[i];
            legendTitle.textColor = [UIColor blackColor];
            legendTitle.font = [UIFont systemFontOfSize:12];
            [self.legendBgView addSubview:legendTitle];
        }
    }
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
    
    for (UIView *view in self.yAxisView.subviews) {
        [view removeFromSuperview];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(29, 0, 1, self.yAxisView.bounds.size.height - 20)];
    lineView.backgroundColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
    [self.yAxisView addSubview:lineView];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSArray *arr in self.dataArray) {
        int max = [[arr valueForKeyPath:@"@max.intValue"] intValue];// 寻找数组中的最大值
        [array addObject:[NSNumber numberWithInt:max]];
    }
    int maxValue = [[array valueForKeyPath:@"@max.intValue"] intValue];// 寻找数组中的最大值
    NSInteger maxNum = [self approximateRoundNumberWithString:[NSString stringWithFormat:@"%d",maxValue]];// 取近似最大值
    NSString *str = [[NSString stringWithFormat:@"%ld",(long)maxNum] substringToIndex:1];
    int level = (int)maxNum / [str intValue]; // 数量级 整十或整百或整千等
    for (int i = 0; i < [str intValue]; i++) {
        CGFloat lblY = self.yAxisView.bounds.size.height - 28 - i * (lineView.bounds.size.height / [str intValue]);
        UILabel *lblYAxisNum = [[UILabel alloc] initWithFrame:CGRectMake(0, lblY, 29, 16)];
        lblYAxisNum.font = [UIFont systemFontOfSize:8];
        lblYAxisNum.textColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
        lblYAxisNum.textAlignment = NSTextAlignmentCenter;
        lblYAxisNum.text = [NSString stringWithFormat:@"%d",i * level];
        [self.yAxisView addSubview:lblYAxisNum];
    }
    UILabel *lblMax = [[UILabel alloc] initWithFrame:CGRectMake(0, -8, 29, 16)];
    lblMax.font = [UIFont systemFontOfSize:8];
    lblMax.textColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
    lblMax.textAlignment = NSTextAlignmentCenter;
    lblMax.text = [NSString stringWithFormat:@"%ld",(long)maxNum];
    [self.yAxisView addSubview:lblMax];
    
    if (self.dataNameArray.count <= 5) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.width);
        self.xAxisView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 20, self.scrollView.bounds.size.width, 20);
        self.dataView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height - 20);
    } else {
        CGFloat groupWidth = self.scrollView.bounds.size.width / 5;
        self.scrollView.contentSize = CGSizeMake(groupWidth * self.dataNameArray.count, self.scrollView.bounds.size.height);
        self.xAxisView.frame = CGRectMake(0, self.scrollView.bounds.size.height - 20, groupWidth * self.dataNameArray.count, 20);
        self.dataView.frame = CGRectMake(0, 0, groupWidth * self.dataNameArray.count, self.scrollView.bounds.size.height - 20);
    }
    
    for (UIView *view in self.xAxisView.subviews) {
        [view removeFromSuperview];
    }
    UIView *xLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.xAxisView.bounds.size.width, 1)];
    xLineView.backgroundColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
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
            lineLayer.strokeColor = [self colorWithHexString:@"#dcdcdc" andAlpha:1.0].CGColor;
            //  设置路径
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, dashlineView.bounds.size.height / 2);
            CGPathAddLineToPoint(path, NULL, dashlineView.bounds.size.width, dashlineView.bounds.size.height / 2);
            [lineLayer setPath:path];
            CGPathRelease(path);
            [dashlineView.layer addSublayer:lineLayer];
        }
    }
    
    [self.dataView removeFromSuperview];
    self.dataView = nil;
    self.dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.bounds.size.height - 20)];
    [self.scrollView addSubview:self.dataView];
    
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    [bgPath moveToPoint:CGPointMake(0, self.dataView.bounds.size.height / 2)];
    [bgPath addLineToPoint:CGPointMake(self.dataView.bounds.size.width, self.dataView.bounds.size.height / 2)];
    bgPath.lineWidth = self.dataView.bounds.size.height;
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.fillColor = [UIColor clearColor].CGColor;
    bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    bgLayer.strokeStart = 0;
    bgLayer.strokeEnd = 1;
    bgLayer.zPosition = 1;
    bgLayer.lineWidth = self.dataView.bounds.size.height;
    bgLayer.path = bgPath.CGPath;
    self.dataView.layer.mask = bgLayer;
    
    CGFloat groupWidth = self.scrollView.bounds.size.width / 5;
    for (int i = 0; i < self.dataNameArray.count; i++) {
        UIView *groupCenterLineView = [[UIView alloc] initWithFrame:CGRectMake(groupWidth * i + groupWidth / 2 - 0.5, 1, 1, 5)];
        groupCenterLineView.backgroundColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
        [self.xAxisView addSubview:groupCenterLineView];
        
        // 分组标题
        UILabel *lblGroupTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, groupWidth, 14)];
        lblGroupTitle.center = CGPointMake(groupWidth * i + groupWidth / 2, 13);
        lblGroupTitle.font = [UIFont systemFontOfSize:8];
        lblGroupTitle.textColor = [self colorWithHexString:@"#898989" andAlpha:1.0];
        lblGroupTitle.textAlignment = NSTextAlignmentCenter;
        lblGroupTitle.text = self.dataNameArray[i];
        [self.xAxisView addSubview:lblGroupTitle];
        
        //
        UIView *groupDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, groupWidth, self.scrollView.bounds.size.height - 20)];
        groupDataView.center = CGPointMake(groupWidth * i + groupWidth / 2, groupDataView.center.y);
        [self.scrollView addSubview:groupDataView];
    }
    
    
    for (int i = 0; i < self.dataArray.count; i++) {
        UIBezierPath *dataPath = [UIBezierPath bezierPath];
        dataPath.lineWidth = self.lineWidth;
        [[self colorWithHexString:self.lineColor andAlpha:1.0] setStroke];
        [[self colorWithHexString:self.lineColor andAlpha:1.0] setFill];
        [dataPath stroke];
        [dataPath fill];
        NSArray *array = self.dataArray[i];
        [self.pointArray removeAllObjects];
        // 起始点
        [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, self.dataView.bounds.size.height)]];
        for (int j = 0; j < array.count; j++) {
            // 具体数据
            NSString *num = array[j];
            CGFloat pointHeight = self.dataView.bounds.size.height - (self.dataView.bounds.size.height - 20) * [num intValue] / maxNum;
            if (self.isSmooth) {// 是否为平滑曲线
                [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(groupWidth / 2 + groupWidth * j, pointHeight)]];
            } else {
                if (j == 0) {
                    [dataPath moveToPoint:CGPointMake(groupWidth / 2, pointHeight)];
                } else {
                    [dataPath addLineToPoint:CGPointMake(groupWidth / 2 + groupWidth * j, pointHeight)];
                }
            }
        }
        if (self.isSmooth) {
            // 添加结束点
            [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.dataView.bounds.size.width, self.dataView.bounds.size.height)]];
            for (int i = 0; i < array.count - 1; i++) {
                CGPoint p1 = [self.pointArray[i] CGPointValue];
                CGPoint p2 = [self.pointArray[i+1] CGPointValue];
                CGPoint p3 = [self.pointArray[i+2] CGPointValue];
                CGPoint p4 = [self.pointArray[i+3] CGPointValue];
                if (i == 0) {
                    [dataPath moveToPoint:p2];
                }
                [self getControlPointOfBezierPath:dataPath andPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y];
            }
        }
        
        CAShapeLayer *dataLayer = [CAShapeLayer layer];
        dataLayer.path = dataPath.CGPath;
        dataLayer.strokeColor = [self colorWithHexString:self.colorArray[i] andAlpha:1.0].CGColor;
        dataLayer.fillColor = nil;//[self colorWithHexString:self.lineColor andAlpha:1.0].CGColor;
        dataLayer.lineWidth = self.lineWidth;
        [self.dataView.layer addSublayer:dataLayer];
        
        // 显示数据具体值
        if (self.showDataLabel) {
            for (int k = 0; k < array.count; k++) {
                NSString *num = array[k];
                CGFloat pointHeight = self.dataView.bounds.size.height - (self.dataView.bounds.size.height - 20) * [num intValue] / maxNum;
                UILabel *dataLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, groupWidth, 16)];
                dataLable.center = CGPointMake(groupWidth / 2 + groupWidth * k, pointHeight - 8);
                dataLable.font = [UIFont systemFontOfSize:8];
                dataLable.textColor = [self colorWithHexString:@"#404040" andAlpha:1.0];
                dataLable.textAlignment = NSTextAlignmentCenter;
                dataLable.text = array[k];
                [self.dataView addSubview:dataLable];
            }
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

#pragma mark - resetData
- (void)resetData {
    if (self.isSingleLine) {
        [self resetSingleLine];
    } else {
        [self resetMultiLine];
    }
}

#pragma mark - getter
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

- (NSArray *)legendNameArray {
    if (!_legendNameArray) {
        _legendNameArray = [NSArray array];
    }
    return _legendNameArray;
}

- (NSMutableArray *)pointArray {
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (NSMutableArray *)colorArray {
    if (!_colorArray) {
        _colorArray = [NSMutableArray array];
    }
    return _colorArray;
}

- (NSArray *)legendColorArray {
    if (!_legendColorArray) {
        _legendColorArray = [NSArray array];
    }
    return _legendColorArray;
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

- (UIColor *)colorWithHexString:(NSString *)color andAlpha:(CGFloat)alpha{
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
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


/**
 传入四个点求两个控制点 （画2，3之间的曲线，需要传入1，2，3，4的坐标）
 参考自：https://www.jianshu.com/p/c33081adce28
 实在是看球不懂
 */
- (void)getControlPointOfBezierPath:(UIBezierPath *)bezierPath
                         andPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                                 x1:(CGFloat)x1 andy1:(CGFloat)y1
                                 x2:(CGFloat)x2 andy2:(CGFloat)y2
                                 x3:(CGFloat)x3 andy3:(CGFloat)y3 {
    CGFloat smooth_value = 0.6;
    CGFloat ctrl1_x;
    CGFloat ctrl1_y;
    CGFloat ctrl2_x;
    CGFloat ctrl2_y;
    CGFloat xc1 = (x0 + x1) /2.0;
    CGFloat yc1 = (y0 + y1) /2.0;
    CGFloat xc2 = (x1 + x2) /2.0;
    CGFloat yc2 = (y1 + y2) /2.0;
    CGFloat xc3 = (x2 + x3) /2.0;
    CGFloat yc3 = (y2 + y3) /2.0;
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
    ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
    ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
    ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
    ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
    
    [bezierPath addCurveToPoint:CGPointMake(x2, y2) controlPoint1:CGPointMake(ctrl1_x, ctrl1_y) controlPoint2:CGPointMake(ctrl2_x, ctrl2_y)];
}


@end
