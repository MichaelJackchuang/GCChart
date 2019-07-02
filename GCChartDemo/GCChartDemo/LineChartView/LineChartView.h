//
//  LineChartView.h
//  LineChartTest
//
//  Created by 古创 on 2019/5/13.
//  Copyright © 2019年 GC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 图例位置
typedef NS_ENUM(NSInteger, LegendPosition) {
    LegendPositionNone = 0,// 无
    LegendPositionTop,// 上
    LegendPositionBottom,// 下
};

@interface LineChartView : UIView

/**
 图例位置（单线折线图没有图例）
 */
@property (nonatomic,assign) LegendPosition legendPostion;

/**
 图例名称数组
 */
@property (nonatomic,strong) NSArray *legendNameArray;

/**
 图例颜色数组（传入十六进制颜色字符串）
 */
@property (nonatomic,strong) NSArray *legendColorArray;

/**
 数据标签数组
 */
@property (nonatomic,strong) NSArray *dataNameArray;

/**
 数据数组（暂时只有正整数）当不是单条折线时为二维数组，其中每个元素数组为一条折线的数据
 */
@property (nonatomic,strong) NSArray *dataArray;

/**
 x轴标题
 */
@property (nonatomic,copy) NSString *xAxisTitle;

/**
 y轴标题
 */
@property (nonatomic,copy) NSString *yAxisTitle;

/**
 数据单位
 */
@property (nonatomic,copy) NSString *dataUnit;

/**
 是否显示数据水平线
 */
@property (nonatomic,assign) BOOL showDataHorizontalLine;

/**
 是否可以滚动 一般来说可以不用设置这个属性 当数据超过5组时可以滚动
 */
@property (nonatomic,assign) BOOL scrollEnabled;

/**
 顶点是否显示具体数据
 */
@property (nonatomic,assign) BOOL showDataLabel;

/**
 折线线宽（当设置线下面为颜色填充时此属性设置无效）
 */
@property (nonatomic,assign) CGFloat lineWidth;

/**
 是否为平滑曲线
 */
@property (nonatomic,assign) BOOL isSmooth;

/**
 是否为单条线
 */
@property (nonatomic,assign) BOOL isSingleLine;

/**
 线条颜色
 */
@property (nonatomic,copy) NSString *lineColor;

/**
 线条下部填充颜色
 */
@property (nonatomic,copy) NSString *fillColor;

/**
 线条下部填充颜色透明度
 */
@property (nonatomic,assign) CGFloat fillAlpha;

/**
 折线下部是否用颜色填充（仅单线条时此属性生效，且此属性设置为yes时线条颜色设置失效）
 */
@property (nonatomic,assign) BOOL isFillWithColor;

/**
 初始化一个单线折线图

 @param frame frame
 @param dataNameArray 数据名称数组
 @param dataArray 数据数组
 @param colorString 线条颜色
 */
- (instancetype)initWithFrame:(CGRect)frame andDataNameArray:(NSArray *)dataNameArray andDataArray:(NSArray *)dataArray andLineColor:(NSString *)colorString;

/**
 重设数据
 */
- (void)resetData;

@end

NS_ASSUME_NONNULL_END
