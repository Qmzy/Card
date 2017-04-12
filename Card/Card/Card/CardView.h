//
//  CardView.h
//  Card
//
//  Created by D on 17/1/3.
//  Copyright © 2017年 D. All rights reserved.


#import <UIKit/UIKit.h>

@class CardView;
@protocol CardViewDelegate <NSObject>
@optional
/**   选中某项   **/
- (void)cardView:(CardView *)cardView didSelectItemAtIndex:(NSInteger)index;
@end



@class CardViewItem;
@protocol CardViewDataSource <NSObject>
@required
/**   总项数   **/
- (NSInteger)numberOfItemsInCardView:(CardView *)cardView;
/**   指定索引下的项   **/
- (CardViewItem *)cardView:(CardView *)cardView itemAtIndex:(NSInteger)index;

@optional
/**
  *  @brief   指定索引下的项的区域大小
  *  @attention   Xcode 8 下未布局完成时 frame = { {0， 0} { 1000， 1000}}
                                自测阶段，设置rect = { {0，0} { 280，400} } ，调用 [self layoutIfNeeded] 之后，高度正确（400），但宽度错误（600）
  */
- (CGRect)cardView:(CardView *)cardView rectForItemAtIndex:(NSInteger)index;
@end



/**   卡片项滚动模式   **/
typedef NS_ENUM(NSInteger, CardViewItemScrollMode){
    
    CardViewItemScrollModeDelete,   // 删除，不可恢复
    CardViewItemScrollModeRemove,   // 移除，可恢复
};



struct CardViewItemEdges {
    
    CGFloat top, left, bottom, right;
};
typedef struct CardViewItemEdges ItemEdges;

ItemEdges CardViewItemEdgesMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);



@interface CardView : UIView

@property (nonatomic, weak) id <CardViewDataSource> dataSource;
@property (nonatomic, weak) id <CardViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger numberOfItems;        // （只读）总项数
@property (nonatomic, readonly) NSInteger indexOfVisibleItem;   // （只读）当前可视范围顶层的项索引

@property (nonatomic, strong) NSMutableArray * visiableItems; // 可视项数组
@property (nonatomic, strong) NSMutableArray * reusableItems; // 复用项数组。满足多个复用标示符
@property (nonatomic, assign) NSInteger maxItems;  // 可视范围内的项数。0 - 默认值。不限制    n - 具体数目
@property (nonatomic, assign) CGFloat scaleRatio;  // 层级缩放比例。默认 0.02
@property (nonatomic, assign) CGFloat curAngle;    // 当前项的旋转角度
@property (nonatomic, assign) BOOL isNeedControl;  // 是否需要页码指示器。默认 YES
@property (nonatomic, assign) ItemEdges itemEdge;  // 用于项的约束。优先于 frame 使用（暂未实现）
@property (nonatomic, assign) CardViewItemScrollMode mode;  // 滚动模式。默认 remove

/**
  *  @brief   刷新数据
  */
- (void)reloadData;
/**
  *  @brief   返回指定索引下的项
  */
- (CardViewItem *)itemAtIndex:(NSInteger)index;
/**
  *  @brief   指定索引项的区域大小
  */
- (CGRect)itemRectAtIndex:(NSInteger)index;
/**
  *  @brief   获取复用对象
  */
- (CardViewItem *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
/**
  *  @brief   注册
  *  @param   xibFile   xib 文件名
  *  @param   identifier   复用标示符
  */
- (void)registerXibFile:(NSString *)xibFile forItemReuseIdentifier:(NSString *)identifier;

- (void)registerClass:(Class)itemClass forItemReuseIdentifier:(NSString *)identifier;
@end
