//
//  CircleRingChartView.h
//  GCChartDemo
//
//  Created by 古创 on 2019/6/5.
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

@interface CircleRingChartView : UIView

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
 数据数组
 */
@property (nonatomic,strong) NSArray *pieDataArray;

/**
 圆环半径
 */
@property (nonatomic,assign) CGFloat radius;

/**
 圆环线宽
 */
@property (nonatomic,assign) CGFloat lineWidth;

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
 是否允许点击
 */
@property (nonatomic,assign) BOOL touchEnable;

/**
 中心标题
 */
@property (nonatomic,copy) NSString *centerTitle;

/**
 初始化圆环

 @param frame frame
 @param legendPostion 图例位置
 @param nameArray 图例名称数组
 @param dataArray 数据数组
 @param radius 圆环半径
 @param lineWidth 圆环线宽
 */
- (instancetype)initWithFrame:(CGRect)frame atPostiion:(LegendPosition)legendPostion withNameArray:(NSArray *)nameArray andDataArray:(NSArray *)dataArray andRadius:(CGFloat)radius andLineWidth:(CGFloat)lineWidth;

/**
 重设数据（更新数据后重新设置饼图）
 */
- (void)resetData;

@end

NS_ASSUME_NONNULL_END
