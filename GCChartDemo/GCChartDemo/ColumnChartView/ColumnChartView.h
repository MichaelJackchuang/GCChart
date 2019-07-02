//
//  ColumnChartView.h
//  ColumnChartTest
//
//  Created by 古创 on 2019/5/10.
//  Copyright © 2019年 chuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 图例位置
typedef NS_ENUM(NSInteger, LegendPosition) {
    LegendPositionNone = 0,// 无
    LegendPositionTop,// 上
    LegendPositionBottom,// 下
};

@interface ColumnChartView : UIView

/**
 图例位置
 */
@property (nonatomic,assign) LegendPosition legendPostion;

/**
 分组名称数组（图例名称)
 */
@property (nonatomic,strong) NSArray *legendNameArray;

/**
 数据标签数组
 */
@property (nonatomic,strong) NSArray *dataNameArray;

/**
 数据数组（暂时只有正整数）（当不是单柱时这个数组是二维数组）
 */
@property (nonatomic,strong) NSArray *dataArray;

/**
 柱体是否为渐变色
 */
@property (nonatomic,assign) BOOL isColumnGradientColor;

/**
 图例颜色数组（传入十六进制颜色字符串），也可作为柱体颜色（柱体非渐变色时使用）
 */
@property (nonatomic,strong) NSArray *legendColorArray;

/**
 柱体渐变色数组（当不是单柱时这个数组是二维数组）
 */
@property (nonatomic,strong) NSArray *columnGradientColorArray;

/**
 单柱柱体颜色（非渐变色)
 */
@property (nonatomic,copy) NSString *columnColor;

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
 柱体宽度
 */
@property (nonatomic,copy) NSString *columnWidth;

/**
 是否显示数据水平线
 */
@property (nonatomic,assign) BOOL showDataHorizontalLine;

/**
 是否可以滚动
 */
@property (nonatomic,assign) BOOL scrollEnabled;

/**
 是否为单柱(最多为4柱一组)
 */
@property (nonatomic,assign) BOOL isSingleColumn;

/**
 是否有负y轴
 */
@property (nonatomic,assign) BOOL didHaveNegativeYAxis;

/**
 每组柱体数量
 */
@property (nonatomic,assign) int numberOfColumn;

/**
 柱顶是否显示具体数据
 */
@property (nonatomic,assign) BOOL showDataLabel;

/**
 是否显示数据水平虚线
 */
@property (nonatomic,assign) BOOL showHorizontalDashLine;

/**
 初始化一个单柱柱状图

 @param frame frame
 @param dataNameArray 数据名称数组
 @param dataArray 数据数组
 */
- (instancetype)initWithFrame:(CGRect)frame andDataNameArray:(NSArray *)dataNameArray andDataArray:(NSArray *)dataArray andColumnColor:(NSString *)colorString;

/**
 初始化一个带负Y轴单柱柱状图
 
 @param frame frame
 @param dataNameArray 数据名称数组
 @param dataArray 数据数组
 */
- (instancetype)initNegativeYAxisWithFrame:(CGRect)frame andDataNameArray:(NSArray *)dataNameArray andDataArray:(NSArray *)dataArray andColumnColor:(NSString *)colorString;

/**
 重设数据
 */
- (void)resetData;

@end

NS_ASSUME_NONNULL_END
