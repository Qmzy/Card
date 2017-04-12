//  卡片项
//  CardViewItem.h
//  Card
//
//  Created by D on 17/1/3.
//  Copyright © 2017年 D. All rights reserved.


#import <UIKit/UIKit.h>

@class CardView;
@interface CardViewItem : UIView

@property (nonatomic, copy) NSString * reuseIdentifier;  // 复用标示符
@property (nonatomic, weak) CardView * cardView;

/// 移除
- (void)addAlphaMaskView;
/// 添加半透明遮罩层
- (void)removeAlphaMaskView;

/// 设置 item 的初始位置与约束
- (void)setOriginalFrameForItem:(NSInteger)index
                       isUpdate:(BOOL)isUpdate;

/// 设置 item 的最终位置与约束
- (void)setFinalFrameForItem:(NSInteger)index
                    isUpdate:(BOOL)isUpdate
                 isLeftFinal:(BOOL)isLeft;

/// 设置 item 的放射变换
- (void)setTransformForItem:(NSInteger)index;

/// 计算、调整 item 的旋转角度
- (void)adjustTranslateAngle:(CGFloat)centerX;

@end
