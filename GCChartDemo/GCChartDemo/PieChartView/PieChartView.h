//
//  PieChartView.h
//  PieChartTest
//
//  Created by 古创 on 2019/5/7.
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

@interface PieChartView : UIView

/**
 图例位置
 */
@property (nonatomic,assign) LegendPosition legendPostion;

/**
 分组名称数组（图例名称)
 */
@property (nonatomic,strong) NSArray *legendNameArray;

/**
 扇形颜色数组（传入十六进制颜色字符串）
 */
@property (nonatomic,strong) NSArray *legendColorArray;

/**
 是否为双层饼图
 */
@property (nonatomic,assign) BOOL isDoubleCircle;

/**
 数据数组，单层饼图的时候使用这个数组
 */
@property (nonatomic,strong) NSArray *pieDataArray;

/**
 内层数据数组，双层饼图的时候使用这个数组
 */
@property (nonatomic,strong) NSArray *pieInsideDataArray;

/**
 外层数据数组，双层饼图的时候使用这个数组
 */
@property (nonatomic,strong) NSArray *pieOutsideDataArray;

/**
 单层圆环半径 或双层圆环外层半径
 */
@property (nonatomic,assign) CGFloat radius;

/**
 数据标签数组
 */
@property (nonatomic,strong) NSArray *pieDataNameArray;

/**
 数据标注单位
 */
@property (nonatomic,copy) NSString *pieDataUnit;

/**
 是否显示百分比
 */
@property (nonatomic,assign) BOOL showPercentage;

/**
 初始化单层饼图

 @param frame frame
 @param legendPostion 图例位置
 @param nameArray 图例名称数组
 @param dataArray 数据数组
 */
- (instancetype)initWithFrame:(CGRect)frame atPostiion:(LegendPosition)legendPostion withNameArray:(NSArray *)nameArray andDataArray:(NSArray *)dataArray;

/**
 初始化内外圈两层饼图

 @param frame frame
 @param legendPostion 图例位置
 @param nameArray 图例名称数组
 @param insideArray 内圈数据数组
 @param outsideArray 外圈数据数组
 */
- (instancetype)initWithFrame:(CGRect)frame atPostiion:(LegendPosition)legendPostion withNameArray:(NSArray *)nameArray andInsideDataArray:(NSArray *)insideArray andOutsideDataArray:(NSArray *)outsideArray;

/**
 重设数据（更新数据后重新设置饼图）
 */
- (void)resetData;

@end

NS_ASSUME_NONNULL_END
