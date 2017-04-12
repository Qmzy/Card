//
//  CardViewItem.m
//  Card
//
//  Created by D on 17/1/3.
//  Copyright © 2017年 D. All rights reserved.


#import "CardViewItem.h"
#import "CardViewConstants.h"
#import "Masonry.h"
#import "CardView.h"


@implementation CardViewItem

- (void)addAlphaMaskView
{
    // 由子视图确定实现
}

- (void)removeAlphaMaskView
{
    // 由子视图确定实现
}

/**
  *  @brief   设置卡片项的初始位置约束
  *
  *  @param   index    索引值。 item 的索引值并不固定，用于计算 frame、scale 等值
  *  @param   isUpdate   yes - 更新位置与约束，no - 设置位置与约束
  *
  *  @attention   item 缩放时其子视图跟着缩小；还原时，如果 item 与父视图没有约束，则 item 的子视图不会还原且在滑动时界面出错
  */
- (void)setOriginalFrameForItem:(NSInteger)index isUpdate:(BOOL)isUpdate
{
    SELF_WEAK;
    if (isUpdate) {   // 更新位置代表 item 已经设置过 frame
        
        // 约束不会导致 frame 调整
        self.center = CGPointMake(W(self.cardView)/2, H(self)/2);
        self.transform = CGAffineTransformMakeRotation(0);
        
        [self mas_updateConstraints:^(MASConstraintMaker * make) {
            SELF_STRONG;
            make.centerX.equalTo(strongSelf.cardView);
            make.centerY.equalTo(@((H(strongSelf) - H(strongSelf.cardView))/2 ));
        }];
    }
    else {
        
        CGRect rect = [self.cardView itemRectAtIndex:index];
        self.center = CGPointMake(W(self.cardView) / 2, rect.size.height / 2);
        
        [self mas_makeConstraints:^(MASConstraintMaker * make) {
            SELF_STRONG;
            make.centerX.equalTo(strongSelf.cardView);
            make.centerY.equalTo(@((rect.size.height - H(strongSelf.cardView)) /2 ));
            make.width.equalTo(@(rect.size.width));
            make.height.equalTo(@(rect.size.height));
        }];
    }
}

/**
  *  @brief   设置卡片项的最终位置约束
  *
  *  @param   index    索引值。item 的索引值并不固定，用于计算 frame、scale 等值
  *  @param   isUpdate   yes - 更新位置与约束，no - 设置位置与约束
  *  @param   isLeft   yes - 最终位置在左侧    no - 最终位置在右侧
  */
- (void)setFinalFrameForItem:(NSInteger)index isUpdate:(BOOL)isUpdate isLeftFinal:(BOOL)isLeft
{
    // cx 代表 item.center.x； centerX 代表 item 与 cardView 中心点的距离
    NSInteger cx = -300;
    NSInteger centerX = cx - self.cardView.center.x;
    
    // 如图：· ← 300 →□← 300 → ·（ '·' 代表 item.center.x 位置， 300 代表距离，□ 代表 cardView 视图）
    if (!isLeft) {
        cx = -cx + W(self.cardView);    centerX = -centerX;
    }
    
    if (isUpdate) {
        
        // 设置旋转角度
        [self adjustTranslateAngle:cx];
        self.center = CGPointMake(cx, H(self)/2 + 100);
        
        [self mas_updateConstraints:^(MASConstraintMaker * make) {
            make.centerX.equalTo(@(centerX));
            make.centerY.equalTo(@(100));
        }];
    }
    else {
        CGRect rect = [self.cardView itemRectAtIndex:index];
        self.center = CGPointMake(cx, H(self.cardView)/2 + 100);
        
        [self mas_makeConstraints:^(MASConstraintMaker * make) {
            make.centerX.equalTo(@(centerX));
            make.centerY.equalTo(@(100));
            make.width.equalTo(@(rect.size.width));
            make.height.equalTo(@(rect.size.height));
        }];
    }
}

/**
  *  @brief   设置卡片项 item 的放射变换
  */
- (void)setTransformForItem:(NSInteger)index
{
    CGAffineTransform scale = CGAffineTransformMakeScale(1 - self.cardView.scaleRatio * index, 1);
    self.transform = CGAffineTransformTranslate(scale, 0, 15 * index);
}

/**
  *  @brief   计算、调整指定项的旋转角度
  *
  *  @param   centerX    item 的中心点 x 值
  */
- (void)adjustTranslateAngle:(CGFloat)centerX
{
    CGFloat angle = (centerX - W(self.cardView)/2.0) / W(self.cardView) / 4.0;
    
    self.cardView.curAngle = angle;
    
    self.transform = CGAffineTransformMakeRotation(angle);
}

@end

