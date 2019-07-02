//
//  PieChartView.m
//  PieChartTest
//
//  Created by 古创 on 2019/5/7.
//  Copyright © 2019年 chuang. All rights reserved.
//

#import "PieChartView.h"

@interface PieChartView ()

@property (nonatomic,strong) UIView *legendBgView;
@property (nonatomic,strong) NSMutableArray *colorArray;

@end

@implementation PieChartView

- (instancetype)initWithFrame:(CGRect)frame atPostiion:(LegendPosition)legendPostion withNameArray:(NSArray *)nameArray andDataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isDoubleCircle = NO;
        self.legendPostion = legendPostion;
        self.legendNameArray = nameArray;
        self.pieDataArray = dataArray;
        [self config];
        [self resetSingleCircle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame atPostiion:(LegendPosition)legendPostion withNameArray:(NSArray *)nameArray andInsideDataArray:(NSArray *)insideArray andOutsideDataArray:(NSArray *)outsideArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.isDoubleCircle = YES;
        self.legendPostion = legendPostion;
        self.legendNameArray = nameArray;
        self.pieInsideDataArray = insideArray;
        self.pieOutsideDataArray = outsideArray;
        [self config];
        [self resetDoubleCircel];
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

- (void)config {
    if (self.legendColorArray.count == 0 || self.legendColorArray.count < self.legendNameArray.count) {
        NSArray *arr = @[@"#308ff7",@"#fbca58",@"#f5447d",@"#a020f0",@"#00ffff",@"#00ff00"];
        self.colorArray = [NSMutableArray arrayWithArray:arr];
    } else {
        self.colorArray = [NSMutableArray arrayWithArray:self.legendColorArray];
    }
    if (self.radius == 0) {
        self.radius = 60;
    } else if (self.radius < 40) {
        self.radius = 40;
    } else if (self.radius * 2 > MIN(self.bounds.size.width, self.bounds.size.height) - 20 - 20 * 2) {// 极端情况 半径接近宽高较小值-20的时候 需要特殊处理 此时标注有可能超出范围而不显示或显示异常
        self.radius = (MIN(self.bounds.size.width, self.bounds.size.height) - 20 - 20 * 2) / 2;
    }  else {
        
    }
}

// 图例
- (void)resetLegend {
    // 先移除之前创建的
    for (UIView *view in self.legendBgView.subviews) {
        [view removeFromSuperview];
    }
    self.legendBgView = nil;
    [self.legendBgView removeFromSuperview];
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
            colorPoint.backgroundColor = [self colorWithHexString:self.colorArray[i]];
            colorPoint.layer.cornerRadius = 5;
            colorPoint.layer.masksToBounds = YES;
            [self.legendBgView addSubview:colorPoint];
            
            UILabel *legendTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colorPoint.frame) + 2, 0, 50, 20)];
            legendTitle.text = self.legendNameArray[i];
            legendTitle.textColor = [UIColor blackColor];
            legendTitle.font = [UIFont systemFontOfSize:12];
            [self.legendBgView addSubview:legendTitle];
        }
    }
}

- (void)resetSingleCircle {
    [self resetLegend];
    
    CGFloat pieCenterX = self.bounds.size.width / 2;
    CGFloat pieCenterY;
    if (self.legendPostion == LegendPositionTop) {
        pieCenterY = self.bounds.size.height / 2 + 10;
    } else if (self.legendPostion == LegendPositionBottom) {
        pieCenterY = self.bounds.size.height / 2 - 10;
    } else {
        pieCenterY = self.bounds.size.height / 2;
    }
    // 先移除之前创建的
    for (UIView *view in self.subviews) {
        if (view.tag == 101) {
            [view removeFromSuperview];
        }
    }
    UIView *pieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 20)];
    pieView.center = CGPointMake(pieCenterX, pieCenterY);
    pieView.tag = 101;
    pieView.backgroundColor = self.backgroundColor;//[UIColor whiteColor];
    [self addSubview:pieView];
    
    CGFloat radius = MAX(pieView.bounds.size.width, pieView.bounds.size.height);//pieView.bounds.size.width > pieView.bounds.size.height ? pieView.bounds.size.height / 2 : pieView.bounds.size.width / 2;
    
    // 背景
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) radius:radius / 2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.fillColor = [UIColor clearColor].CGColor;
    bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    bgLayer.strokeStart = 0;
    bgLayer.strokeEnd = 1;
    bgLayer.zPosition = 1;
    bgLayer.lineWidth = radius;
    bgLayer.path = bgPath.CGPath;
    
    float total = 0;
    for (NSString *str in self.pieDataArray) {
        total = total + [str floatValue];
    }
    
    // 标注
    CGFloat startAngle_p = 90;
    for (int i = 0; i < self.pieDataArray.count; i++) {
        NSString *num = self.pieDataArray[i];
        CGFloat angle = startAngle_p - [num floatValue] / 2 / total * 360;
        CGPoint pointInCenter = [self caculatePointAtCircleWithCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) andAngle:angle andRadius:self.radius];
        CGPoint pointInCenter_2 = [self caculatePointAtCircleWithCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) andAngle:angle andRadius:self.radius + self.radius / 6];
        CGPoint pointAtLabel;
        if (cosf(angle * M_PI / 180) >= -0.01) { // 偏右侧
            pointAtLabel = CGPointMake(pointInCenter_2.x + self.radius / 3, pointInCenter_2.y);
        } else { // 偏左侧
            pointAtLabel = CGPointMake(pointInCenter_2.x - self.radius / 3, pointInCenter_2.y);
        }
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:pointInCenter];
        [linePath addLineToPoint:pointInCenter_2];
        [linePath addLineToPoint:pointAtLabel];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = 0.5;
        layer.strokeColor = [self colorWithHexString:@"#dcdcdc"].CGColor;
        layer.fillColor = nil;
        layer.path = linePath.CGPath;
        [pieView.layer addSublayer:layer];
        
        UILabel *lblMark = [[UILabel alloc] init];
        if (cosf(angle * M_PI / 180) >= -0.01) { // 偏右侧
            lblMark.bounds = CGRectMake(0, 0, pieView.bounds.size.width - pointAtLabel.x - 2, 12);
        } else { // 偏左侧
            lblMark.bounds = CGRectMake(0, 0, pointAtLabel.x - 2, 12);
        }
        lblMark.textColor = [self colorWithHexString:@"#404040"];
        lblMark.font = [UIFont systemFontOfSize:10];
        lblMark.numberOfLines = 2;
        if (self.showPercentage) {
            NSString *num = self.pieDataArray[i];
            if (self.pieDataNameArray.count == 0 || self.pieDataNameArray.count != self.pieDataArray.count) {
                lblMark.text = [NSString stringWithFormat:@"%.2f%%",[num floatValue] / total];
            } else {
                lblMark.text = [NSString stringWithFormat:@"%@:%.2f%%",self.pieDataNameArray[i],[num floatValue] / total];
            }
        } else {
            if (!self.pieDataUnit) {
                self.pieDataUnit = @"";
            }
            if (self.pieDataNameArray.count == 0 || self.pieDataNameArray.count != self.pieOutsideDataArray.count) {
                lblMark.text = [NSString stringWithFormat:@"%@%@",self.pieDataArray[i],self.pieDataUnit];
            } else {
                lblMark.text = [NSString stringWithFormat:@"%@:%@%@",self.pieDataNameArray[i],self.pieDataArray[i],self.pieDataUnit];
            }
        }
//        if (!self.pieDataUnit) {
//            self.pieDataUnit = @"";
//        }
//        lblMark.text = [NSString stringWithFormat:@"%@:%@%@",self.legendNameArray[i],self.pieDataArray[i],self.pieDataUnit];
        [lblMark sizeToFit];
        [pieView addSubview:lblMark];
        if (cosf(angle * M_PI / 180) >= -0.01) { // 偏右侧
            lblMark.center = CGPointMake(pointAtLabel.x + lblMark.bounds.size.width / 2 + 2, pointAtLabel.y);
        } else { // 偏左侧
            lblMark.center = CGPointMake(pointAtLabel.x - lblMark.bounds.size.width / 2 - 2, pointAtLabel.y);
        }
        
        startAngle_p = startAngle_p - [num floatValue] / total * 360 ;
    }
    
    // 子扇区
    UIBezierPath *piePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
//    CGFloat start = 0;
//    CGFloat end = 0;
    CGFloat startAngle = -M_PI_2;
    for (int i = 0; i < self.pieDataArray.count; i++) {
        NSString *num = self.pieDataArray[i];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) radius:self.radius startAngle:startAngle endAngle:startAngle + [num floatValue] / total * M_PI * 2 clockwise:YES];
        //        path.lineWidth = 10;// 线宽与半径相同
        [path addLineToPoint:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2)];// 圆心
        [[self colorWithHexString:self.colorArray[i]] setStroke];
        [[self colorWithHexString:self.colorArray[i]] setFill];
        [path stroke];
        [path fill];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
//        layer.lineWidth = 30;
        layer.strokeColor = [UIColor whiteColor].CGColor; // 描边颜色
        layer.fillColor = [self colorWithHexString:self.colorArray[i]].CGColor; // 背景填充色
        [pieView.layer addSublayer:layer];
        
        startAngle = startAngle + [num floatValue] / total * M_PI * 2 ;
    }
    pieView.layer.mask = bgLayer;
    
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

- (void)resetDoubleCircel {
    [self resetLegend];
    
    // 饼图
    CGFloat pieCenterX = self.bounds.size.width / 2;
    CGFloat pieCenterY;
    if (self.legendPostion == LegendPositionTop) {
        pieCenterY = self.bounds.size.height / 2 + 10;
    } else if (self.legendPostion == LegendPositionBottom) {
        pieCenterY = self.bounds.size.height / 2 - 10;
    } else {
        pieCenterY = self.bounds.size.height / 2;
    }
    // 先移除之前创建的
    for (UIView *view in self.subviews) {
        if (view.tag == 101) {
            [view removeFromSuperview];
        }
    }
    UIView *pieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 20)];
    pieView.center = CGPointMake(pieCenterX, pieCenterY);
    pieView.tag = 101;
    pieView.backgroundColor = self.backgroundColor;//[UIColor whiteColor];
    [self addSubview:pieView];
    
    CGFloat radius = MAX(pieView.bounds.size.width, pieView.bounds.size.height);//pieView.bounds.size.width > pieView.bounds.size.height ? pieView.bounds.size.height / 2 : pieView.bounds.size.width / 2;
    
    // 背景
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) radius:radius / 2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.fillColor = [UIColor clearColor].CGColor;
    bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    bgLayer.strokeStart = 0;
    bgLayer.strokeEnd = 1;
    bgLayer.zPosition = 1;
    bgLayer.lineWidth = radius;
    bgLayer.path = bgPath.CGPath;
    
    // 内圈
    int insideTotal = 0;
    for (NSString *str in self.pieInsideDataArray) {
        insideTotal = insideTotal + [str floatValue];
    }
    CGFloat startAngle = 1.5 * M_PI;
    for (int i = 0; i < self.pieInsideDataArray.count; i++) {
        NSString *num = self.pieInsideDataArray[i];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) radius:self.radius / 2 startAngle:startAngle endAngle:startAngle + [num floatValue] / insideTotal * M_PI * 2 clockwise:YES];
        //        path.lineWidth = 10;// 线宽与半径相同
        if (!self.isDoubleCircle) {
            [path addLineToPoint:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2)];// 圆心
        }
        [[self colorWithHexString:self.colorArray[i]] setStroke];
        [[self colorWithHexString:self.colorArray[i]] setFill];
        [path stroke];
        [path fill];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.lineWidth = self.radius / 2;
        layer.strokeColor = [self colorWithHexString:self.colorArray[i]].CGColor; // 描边颜色
        layer.fillColor = [UIColor clearColor].CGColor; // 背景填充色
        [pieView.layer addSublayer:layer];
        
        startAngle = startAngle + [num floatValue] / insideTotal * M_PI * 2 ;
        
        // 动画
//        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        strokeAnimation.fromValue = @0;// 起始值
//        strokeAnimation.toValue = @1;// 结束值
//        strokeAnimation.duration = 0.5;// 动画持续时间
//        strokeAnimation.repeatCount = 1;// 重复次数
//        [layer addAnimation:strokeAnimation forKey:@"pieAnimation"];
    }
    
    int outsideTotal = 0;
    for (NSString *str in self.pieOutsideDataArray) {
        outsideTotal = outsideTotal + [str floatValue];
    }
    
    // 外圈
    startAngle = 1.5 * M_PI;
    for (int i = 0; i < self.pieOutsideDataArray.count; i++) {
        NSString *num = self.pieOutsideDataArray[i];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) radius:self.radius startAngle:startAngle endAngle:startAngle + [num floatValue] / outsideTotal * M_PI * 2 clockwise:YES];
//        path.lineWidth = 10;// 线宽与半径相同
//        [path addLineToPoint:pieView.center];
        [[self colorWithHexString:self.colorArray[i]] setStroke];
        [[self colorWithHexString:self.colorArray[i]] setFill];
        [path stroke];
        [path fill];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.lineWidth = self.radius / 6;
        layer.strokeColor = [self colorWithHexString:self.colorArray[i]].CGColor; // 圆环颜色
        layer.fillColor = [UIColor clearColor].CGColor; // 背景填充色
//        layer.backgroundColor = [self colorWithHexString:self.colorArray[i]].CGColor;
        [pieView.layer addSublayer:layer];
        
        startAngle = startAngle + [num floatValue] / outsideTotal * M_PI * 2 ;
        
    }
    
    // 外圈标注
    CGFloat startAngle_p = 90;
    for (int i = 0; i < self.pieOutsideDataArray.count; i++) {
        NSString *num = self.pieOutsideDataArray[i];
        CGFloat angle = startAngle_p - [num floatValue] / 2 / outsideTotal * 360;
        CGPoint pointInCenter = [self caculatePointAtCircleWithCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) andAngle:angle andRadius:self.radius+ self.radius / 12];
        CGPoint pointInCenter_2 = [self caculatePointAtCircleWithCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.bounds.size.height / 2) andAngle:angle andRadius:self.radius + self.radius / 12 + self.radius / 6];
        CGPoint pointAtLabel;
        if (cosf(angle * M_PI / 180) >= -0.01) { // 偏右侧
            pointAtLabel = CGPointMake(pointInCenter_2.x + self.radius / 3, pointInCenter_2.y);
        } else { // 偏左侧
            pointAtLabel = CGPointMake(pointInCenter_2.x - self.radius / 3, pointInCenter_2.y);
        }
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:pointInCenter];
        [linePath addLineToPoint:pointInCenter_2];
        [linePath addLineToPoint:pointAtLabel];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = 0.5;
        layer.strokeColor = [self colorWithHexString:@"#dcdcdc"].CGColor;
        layer.fillColor = nil;
        layer.path = linePath.CGPath;
        [pieView.layer addSublayer:layer];
        
        UILabel *lblMark = [[UILabel alloc] init];
        if (cosf(angle * M_PI / 180) >= -0.01) { // 偏右侧
            lblMark.bounds = CGRectMake(0, 0, pieView.bounds.size.width - pointAtLabel.x - 2, 12);
        } else { // 偏左侧
            lblMark.bounds = CGRectMake(0, 0, pointAtLabel.x - 2, 12);
        }
        lblMark.textColor = [self colorWithHexString:@"#404040"];
        lblMark.font = [UIFont systemFontOfSize:10];
        lblMark.numberOfLines = 2;
        if (self.showPercentage) {
            NSString *num = self.pieOutsideDataArray[i];
            if (self.pieDataNameArray.count == 0 || self.pieDataNameArray.count != self.pieOutsideDataArray.count) {
                lblMark.text = [NSString stringWithFormat:@"%.2f%%",[num floatValue] / outsideTotal];
            } else {
                lblMark.text = [NSString stringWithFormat:@"%@:%.2f%%",self.pieDataNameArray[i],[num floatValue] / outsideTotal];
            }
        } else {
            if (!self.pieDataUnit) {
                self.pieDataUnit = @"";
            }
            if (self.pieDataNameArray.count == 0 || self.pieDataNameArray.count != self.pieOutsideDataArray.count) {
                lblMark.text = [NSString stringWithFormat:@"%@%@",self.pieOutsideDataArray[i],self.pieDataUnit];
            } else {
                lblMark.text = [NSString stringWithFormat:@"%@:%@%@",self.pieDataNameArray[i],self.pieOutsideDataArray[i],self.pieDataUnit];
            }
        }
        
        [lblMark sizeToFit];
        [pieView addSubview:lblMark];
        if (cosf(angle * M_PI / 180) >= -0.01) { // 偏右侧
            lblMark.center = CGPointMake(pointAtLabel.x + lblMark.bounds.size.width / 2 + 2, pointAtLabel.y);
        } else { // 偏左侧
            lblMark.center = CGPointMake(pointAtLabel.x - lblMark.bounds.size.width / 2 - 2, pointAtLabel.y);
        }
        
        startAngle_p = startAngle_p - [num floatValue] / outsideTotal * 360 ;
    }
    
    pieView.layer.mask = bgLayer;
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

- (void)resetDataLabel {
    if (self.isDoubleCircle) {// 双层
        
    } else {// 单层
        float total = 0;
        for (NSString *str in self.pieDataArray) {
            total = total + [str floatValue];
        }
        UIView *pieView;
        for (UIView *view in self.subviews) {
            if (view.tag == 101) {
                pieView = view;
            }
        }
        CGFloat startAngle_p = 90;
        for (int i = 0; i < self.pieDataArray.count; i++) {
            NSString *num = self.pieDataArray[i];
            CGFloat angle = startAngle_p - [num floatValue] / 2 / total * 360;
            CGPoint pointInCenter = [self caculatePointAtCircleWithCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.center.y) andAngle:angle andRadius:self.radius];
            CGPoint pointInCenter_2 = [self caculatePointAtCircleWithCenter:CGPointMake(pieView.bounds.size.width / 2, pieView.center.y) andAngle:angle andRadius:self.radius + 5];
            
            UIBezierPath *linePath = [UIBezierPath bezierPath];
            [linePath moveToPoint:pointInCenter];
            [linePath addLineToPoint:pointInCenter_2];
            
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.lineWidth = 0.5;
            layer.strokeColor = [UIColor lightGrayColor].CGColor;
            layer.path = linePath.CGPath;
            [pieView.layer addSublayer:layer];
            
            startAngle_p = startAngle_p - [num floatValue] / total * 360 ;
        }
    }
}

#pragma mark - resetData
- (void)resetData {
    [self config];
    if (self.isDoubleCircle) {
        [self resetDoubleCircel];
    } else {
        [self resetSingleCircle];
    }
}


#pragma mark - getter
- (NSArray *)legendNameArray {
    if (!_legendNameArray) {
        _legendNameArray = [NSArray array];
    }
    return _legendNameArray;
}

- (NSArray *)legendColorArray {
    if (!_legendColorArray) {
        _legendColorArray = [NSArray array];
    }
    return _legendColorArray;
}

- (NSMutableArray *)colorArray {
    if (!_colorArray) {
        _colorArray = [NSMutableArray array];
    }
    return _colorArray;
}

- (NSArray *)pieDataArray {
    if (!_pieDataArray) {
        _pieDataArray = [NSArray array];
    }
    return _pieDataArray;
}

- (NSArray *)pieInsideDataArray {
    if (!_pieInsideDataArray) {
        _pieInsideDataArray = [NSArray array];
    }
    return _pieInsideDataArray;
}

- (NSArray *)pieOutsideDataArray {
    if (!_pieOutsideDataArray) {
        _pieOutsideDataArray = [NSArray array];
    }
    return _pieOutsideDataArray;
}

- (NSArray *)pieDataNameArray {
    if (!_pieDataNameArray) {
        _pieDataNameArray = [NSArray array];
    }
    return _pieDataNameArray;
}

#pragma mark - other
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

- (CGPoint)caculatePointAtCircleWithCenter:(CGPoint)center andAngle:(CGFloat)angle andRadius:(CGFloat)radius {
    CGFloat x = radius * cosf(angle * M_PI / 180);
    CGFloat y = radius * sinf(angle * M_PI / 180);
    return CGPointMake(center.x + x, center.y - y);
}

@end
