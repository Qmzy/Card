//
//  CardView.m
//  Card
//
//  Created by D on 17/1/3.
//  Copyright © 2017年 D. All rights reserved.


#import "CardView.h"
#import "CardViewItem.h"
#import "Masonry.h"
#import "CardViewConstants.h"


@interface CardView ()
{
    UIPanGestureRecognizer * __pan;
    
    CardViewItem * __curItem;   // 当前页
    CardViewItem * __lastItem;  // 上一页
    
    CGFloat __curAngle;         // 当前项的旋转角度
    CGFloat __fingerPoiX;       // 手指在 X 轴方向上滑过的距离，用于判断方向：小于 0 左滑，大于0 右滑
    NSInteger __visibleIndex;   // 当前最上层可视项的索引值
    
    NSInteger __otherSubViewNum; // cardView 上非 item 子视图的个数
}
@property (nonatomic, strong) UILabel * pageControl; // 页码指示器
@property (nonatomic, strong) NSMutableDictionary * mapDict; // 映射字典。key：复用标示符，value：xib或者类名

@end



@implementation CardView

- (instancetype)init
{
    if (self = [super init]) {
    
        [self onlyOnceInitialization];
        [self repeatedlyInitialization];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self onlyOnceInitialization];
    [self repeatedlyInitialization];
}

/// 只初始化一次的变量
- (void)onlyOnceInitialization
{
    self.maxItems = 0;
    self.scaleRatio = 0.02;
    self.isNeedControl = YES;
    self.mode = CardViewItemScrollModeRemove;
    
    self.visiableItems = [NSMutableArray array];
    self.reusableItems = [NSMutableArray array];
    self.mapDict = [NSMutableDictionary dictionary];
}

/// 重复初始化的变量。reloadData 时调用
- (void)repeatedlyInitialization
{
    __visibleIndex = 0;
    __fingerPoiX = 0;
    
    [self.visiableItems removeAllObjects];
    [self.reusableItems removeAllObjects];
}

- (void)reloadData
{
    NSAssert(self.dataSource, @"卡片视图需要数据源");
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self repeatedlyInitialization];
    
    // 循环创建可视项
    for (NSInteger i = self.maxItems - 1; i > -1; i--) {
        
        CardViewItem * item = [self itemAtIndex:i];
        // 视图添加顺序与实际观测顺序相反，即先添加的在最下面
        [self addSubview:item];
        // 必须先添加再设置约束
        [item setOriginalFrameForItem:i isUpdate:NO];
        [item setTransformForItem:i];
        
        if (i == 0) {
            [item removeAlphaMaskView];
        }
        
        // 正序添加
        [self.visiableItems insertObject:item atIndex:0];
    }
    
    // 添加页码指示器
    if (self.isNeedControl) {
        [self createPageControl];
    }
    else {
        __otherSubViewNum = 0;
    }
    
    // 增加滑动手势
    [self addPanGestureRecognizer];
}

- (void)addPanGestureRecognizer
{
    if (!__pan) {
        __pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(pan:)];
    }
    if (![self.gestureRecognizers containsObject:__pan]) {
        [self addGestureRecognizer:__pan];
    }
}


#pragma mark - PageControl
/**
  *  @brief   创建页码指示器，并设置约束
  */
- (void)createPageControl
{
    _pageControl = [[UILabel alloc] init];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.textAlignment   = NSTextAlignmentCenter;
    _pageControl.font            = [UIFont systemFontOfSize:16];
    _pageControl.textColor       = [UIColor whiteColor];
    _pageControl.attributedText  = [self getPageControlAttributedText];
    [self addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker * make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@(-35));
        make.height.equalTo(@20);
    }];
}

- (void)updatePageControl
{
    if (_pageControl == nil) {
        [self createPageControl];
    }
    _pageControl.attributedText = [self getPageControlAttributedText];
}

- (NSAttributedString *)getPageControlAttributedText
{
    NSString * cur = [NSString stringWithFormat:@"%d", (int)__visibleIndex + 1];
    NSString * s = [NSString stringWithFormat:@"%@ / %d", cur, (int)[self numberOfItems]];
    
    NSMutableAttributedString * attriS = [[NSMutableAttributedString alloc] initWithString:s];
    [attriS addAttribute:NSForegroundColorAttributeName
                   value:RGB(0x75ac47)
                   range:NSMakeRange(0, cur.length)];
    
    return attriS;
}


#pragma mark - SET

- (void)setCurAngle:(CGFloat)curAngle
{
    __curAngle = curAngle;
}

/**
  *  @brief   如果需要页码指示器，那么 cardView 上除 item 外的子视图等于 1，否则为 0
  */
- (void)setIsNeedControl:(BOOL)isNeedControl
{
    _isNeedControl = isNeedControl;
    
    __otherSubViewNum = isNeedControl ? 1 : 0;
}

- (void)setMode:(CardViewItemScrollMode)mode
{
    _mode = mode;
}


#pragma mark - GET
/**
  *  @brief   判断 maxItems 的有效性，获取时需与当前项数进行比较。
  */
- (NSInteger)maxItems
{
    if (_maxItems <= 0 || _maxItems > [self numberOfItems]) {
        return [self numberOfItems];
    }
    return _maxItems;
}

- (NSInteger)numberOfItems
{
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInCardView:)]) {
        
        return [self.dataSource numberOfItemsInCardView:self];
    }
    return 0;
}

- (NSInteger)indexOfVisibleItem
{
    // 超出 [ 0     self.numberOfItems - 1 ]  范围的值进行调整
    if (__visibleIndex < 0) {
        __visibleIndex = 0;
    }
    else if (__visibleIndex > [self numberOfItems] - 1) {
        
        __visibleIndex = [self numberOfItems] - 1;
    }
    return __visibleIndex;
}

- (CGFloat)curAngle
{
    return __curAngle;
}


#pragma mark - Tool Funcs
/**
  *  @brief   指定索引项的区域大小
  */
- (CGRect)itemRectAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(cardView:rectForItemAtIndex:)]) {
        
        CGRect rect = [self.dataSource cardView:self rectForItemAtIndex:index];
        
        if (rect.size.width <= 0 || rect.size.width > W(self)) {
            rect.size.width = W(self);
        }
        if (rect.size.height <= 0 || rect.size.height > H(self)) {
            rect.size.height = H(self);
        }
        return rect;
    }
    return self.frame;
}

/**
  *  @brief   获取指定索引项
  */
- (CardViewItem *)itemAtIndex:(NSInteger)index
{
    CardViewItem * item = nil;
    
    if ([self.dataSource respondsToSelector:@selector(cardView:itemAtIndex:)]) {
        
        item = [self.dataSource cardView:self itemAtIndex:index];
    }
    
    if (item == nil) {
        item = [CardViewItem new];
    }
    item.cardView = self;
    
    return item;
}

- (void)registerXibFile:(NSString *)xibFile forItemReuseIdentifier:(NSString *)identifier
{
    // 相同 key 值，后添加会覆盖先添加的
    [self.mapDict setValue:xibFile forKey:identifier];
}

- (void)registerClass:(Class)itemClass forItemReuseIdentifier:(NSString *)identifier
{
    // 相同 key 值，后添加会覆盖先添加的
    [self.mapDict setValue:itemClass forKey:identifier];
}

/**
  *  @brief   从复用项数组中获取可复用对象，没有则新创建
  */
- (CardViewItem *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block CardViewItem * item = nil;
    
    // 有可复用项 + 剩余的项 > _maxItems
    if (self.reusableItems.count > 0 && __visibleIndex <= [self numberOfItems] - self.maxItems) {
        
        [self.reusableItems enumerateObjectsUsingBlock:^(CardViewItem * obj, NSUInteger idx, BOOL * stop) {
            
            if ([obj.reuseIdentifier isEqualToString:identifier]) {
            
                item = obj;
                *stop = YES;
            }
        }];
    }
    else {
        
        [self.mapDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL * stop) {
            
            if ([key isEqualToString:identifier]) {
                
                if ([obj isKindOfClass:[NSString class]]) {   // xib 文件
                
                    item = (CardViewItem *)[self viewFromXibFile:(NSString *)obj];
                }
                else {  // 类文件
                    item = [[(Class)obj alloc] init];
                }
                item.reuseIdentifier = key;
                
                [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(tap:)]];

                *stop = YES;
            }
        }];
    }
    return item;
}

/**
  *  @brief   存储可复用对象。同一复用标示符只能保存一个对象，且需要更新、替换
  */
- (void)addObjectToReusableItems:(CardViewItem *)item
{
    __block NSInteger existIdx = -1;
    
    [self.reusableItems enumerateObjectsUsingBlock:^(CardViewItem * obj, NSUInteger idx, BOOL * stop) {
        
        if ([obj.reuseIdentifier isEqualToString:item.reuseIdentifier]) {
            existIdx = idx;
            *stop = YES;
        }
    }];
    
    if (existIdx == -1) {
        [self.reusableItems addObject:item];
    }
    else {
        [self.reusableItems replaceObjectAtIndex:existIdx withObject:item];
    }
}

/**
  *  @brief   计算指定项的中心点
  *  @param   isDelete   是否是删除模式
  */
- (void)calculateItemCenter:(CardViewItem *)item point:(CGPoint)point isDeleteMode:(BOOL)isDelete
{
    if (__fingerPoiX < 0 || isDelete) {   // 左滑或者删除模式的右滑
    
        item.center = CGPointMake(item.center.x + point.x, item.center.y + point.y);
    }
    else if (__fingerPoiX > 0) {  // 移除模式的右滑
    
        item.center = CGPointMake(item.center.x + point.x, item.center.y - point.y);
    }
}

/**
  *  @brief   从 xib 文件获取视图对象
  */
- (UIView *)viewFromXibFile:(NSString *)xibFile
{
    NSArray * nibContents = [[NSBundle mainBundle] loadNibNamed:xibFile owner:nil options:nil];
    return [nibContents lastObject];
}


#pragma mark - Touch
/**
  *  @brief   滑动手势
  */
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    // 出现视图未加载完成的情况
    if (self.subviews.count == 0) {   return;   }

    switch (self.mode) {
        case CardViewItemScrollModeRemove: {
            
            [self panOfRemoveMode:gesture];       break;
        }
            
        case CardViewItemScrollModeDelete: {
            
            [self panOfDeleteMode:gesture];       break;
        }
        default:
            break;
    }
}

/**
  *  @brief   移除模式
  */
- (void)panOfRemoveMode:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {

        // 初始手指滑动的距离
        __fingerPoiX = 0;
        // 当前项
        __curItem = self.visiableItems[0];
        // 上一项
        __lastItem = __visibleIndex > 0 ? [self itemAtIndex:__visibleIndex - 1] : nil;
        
        if (__lastItem) {
            
            // 先添加上并设置初始位置
            [__lastItem removeAlphaMaskView];
            [self addSubview:__lastItem];
            [__lastItem setFinalFrameForItem:-1 isUpdate:NO isLeftFinal:YES];
            [__lastItem setTransformForItem:0];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint movedPoint = [gesture translationInView:self];
        
        __fingerPoiX += movedPoint.x;
        
        // 避免一个手势左右滑动，即操作了 curItem，又操作了 lastItem
        if (__fingerPoiX < 0 && __lastItem) {
            [__lastItem removeFromSuperview];
            __lastItem = nil;
        }
        
        // 左滑且未至底端
        if (__fingerPoiX < 0 && __visibleIndex < [self numberOfItems] - 1) {
            
            [self calculateItemCenter:__curItem point:movedPoint isDeleteMode:NO];
            [__curItem adjustTranslateAngle:__curItem.center.x];
        }
        // 右滑且未至顶端
        else if (__fingerPoiX > 0 && __visibleIndex > 0 && __lastItem) {
            
            [self calculateItemCenter:__lastItem point:movedPoint isDeleteMode:NO];
            [__lastItem adjustTranslateAngle:__lastItem.center.x];
        }
        
        [gesture setTranslation:CGPointZero inView:self];
        
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint vel = [gesture velocityInView:self];
        
        if (__fingerPoiX < 0 && __visibleIndex < [self numberOfItems] - 1) {  // 左滑
        
            if (vel.x < -800) {
                [self cardItemOutOfScreenEndScrollAnimation:__curItem isLeftFinal:YES isFast:YES];
            }
            else if(__fingerPoiX < -100){
                [self cardItemOutOfScreenEndScrollAnimation:__curItem isLeftFinal:YES isFast:NO];
            }
            else {
                [self cardItemToOriginalEndScrollAnimation:__curItem isFast:NO];
            }
        }
        else if (__lastItem && __fingerPoiX > 0){  // 右滑
            
            if(vel.x > 800) {
                [self cardItemToOriginalEndScrollAnimation:__lastItem isFast:YES];
            }
            else if (__fingerPoiX > CARDITEM_RIGHT_RESPONDLENGTH){
                [self cardItemToOriginalEndScrollAnimation:__lastItem isFast:NO];
            }
            else {
                [self cardItemOutOfScreenEndScrollAnimation:__lastItem isLeftFinal:YES isFast:NO];
            }
        }
        else {
            // 只对当前可视视图进行纠错
            [self cardItemToOriginalEndScrollAnimation:__curItem isFast:NO];
        }
    }
}

/**
  *  @brief   删除模式
  */
- (void)panOfDeleteMode:(UIPanGestureRecognizer *)gesture
{
    if (__visibleIndex == [self numberOfItems] - 1) {   return;   }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
    
        __curItem = self.visiableItems[0];
        // 初始手指滑动的距离
        __fingerPoiX = 0;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint movedPoint = [gesture translationInView:self];
        __fingerPoiX += movedPoint.x;

        [self calculateItemCenter:__curItem point:movedPoint isDeleteMode:YES];
        [__curItem adjustTranslateAngle:__curItem.center.x];

        [gesture setTranslation:CGPointZero inView:self];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint vel = [gesture velocityInView:self];
     
        if (vel.x < -800) {   // 左侧快速删除
            [self cardItemOutOfScreenEndScrollAnimation:__curItem isLeftFinal:YES isFast:YES];
        }
        else if(__fingerPoiX < -100){   // 左侧慢速删除
            [self cardItemOutOfScreenEndScrollAnimation:__curItem isLeftFinal:YES isFast:NO];
        }
        else if (vel.x > 800){  // 右侧快速删除
            [self cardItemOutOfScreenEndScrollAnimation:__curItem isLeftFinal:NO isFast:YES];
        }
        else if (__fingerPoiX > 100) {  // 右侧慢速删除
            [self cardItemOutOfScreenEndScrollAnimation:__curItem isLeftFinal:NO isFast:YES];
        }
        else {   // 弹回
            [self cardItemToOriginalEndScrollAnimation:__curItem isFast:NO];
        }
    }
}

/**
  *  @brief   手势停止运动，目标项运动至屏幕外。
  *  @attention   移除模式：左滑删除、右滑弹回；删除模式：左滑删除、右滑删除
  *  @param   isLeft   yes - 左侧屏幕外    no - 右侧屏幕外
  *  @param   isFast   yes - 快速滑动    no - 慢速
  */
- (void)cardItemOutOfScreenEndScrollAnimation:(CardViewItem *)item isLeftFinal:(BOOL)isLeft isFast:(BOOL)isFast
{
    CGFloat animationDuration = isFast ? 0.15 : 0.3;
    
    BOOL isCur = [item isEqual:__curItem];
    
    // 左滑删除：先添加未展示的卡片
    if (isCur && __visibleIndex + self.maxItems < [self numberOfItems]) {
        
        // 新项索引值
        NSInteger index = __visibleIndex + self.maxItems;
        
        CardViewItem * newItem = [self itemAtIndex:index];
        newItem.hidden = YES;
        // 添加遮层
        [newItem addAlphaMaskView];
        [self addSubview:newItem];
        // 放置最底下
        [self sendSubviewToBack:newItem];
        // 设置初始位置
        [newItem setOriginalFrameForItem:index isUpdate:NO];
        [newItem setTransformForItem:self.maxItems - 1];
        
        [self.visiableItems addObject:newItem];
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [item setFinalFrameForItem:-1 isUpdate:YES isLeftFinal:isLeft];
        
        // 左滑删除，则需要剩余页缩放；右滑弹回则不处理
        if (isCur) {
            
            // 如果是当前图片操作，先删除 lastItem
            if (__lastItem) {
                [__lastItem removeFromSuperview];
                __lastItem = nil;
            }
            
            // 循环遍历底下的页面，放大上移.（此处可能存在：剩余项数 < _maxItems 的情况，所以使用 self.subviews.count）
            for (NSInteger i = 1; i < self.subviews.count - __otherSubViewNum && i < self.visiableItems.count; i++) {
                
                CardViewItem * nextItem = self.visiableItems[i];
                
                if (i < self.subviews.count - 1 - __otherSubViewNum || __visibleIndex + self.maxItems >= [self numberOfItems]) {
                    
                    [nextItem setTransformForItem:i - 1];
                    
                    if (i == 1) {
                        [nextItem removeAlphaMaskView];
                    }
                }
                else {
                    nextItem.hidden = NO;
                }
            }
            
            __visibleIndex++;
            
            if (self.isNeedControl) {
                [self updatePageControl];
            }
        }
        
    } completion:^(BOOL finished) {
        
        if (isCur) {
            [item removeFromSuperview];
            [self addObjectToReusableItems:item];
            [self.visiableItems removeObject:item];
        }
        
        __curItem = nil;
        
        if (__lastItem) {  // 如果是右滑弹回，释放内存
            [__lastItem removeFromSuperview];
            __lastItem = nil;
        }
    }];
}

/**
  *  @brief   手势停止运动，目标项运动至原始位置。
  *  @attention   移除模式：左滑弹回、右滑查看上一张卡片；删除模式：左滑弹回、右滑弹回
  *  @param   isFast   yes - 快速滑动     no - 慢速
  */
- (void)cardItemToOriginalEndScrollAnimation:(CardViewItem *)item isFast:(BOOL)isFast
{
    BOOL isLast = [item isEqual:__lastItem];
    
    CGFloat animationDuration = isFast ? 0.15 : 0.3;
    
    __block CardViewItem * hiddenItem = nil;

    [UIView animateWithDuration:animationDuration animations:^{

        [item setOriginalFrameForItem:-1 isUpdate:YES];
        
        // 如果是上一页覆盖上来，则需要剩余页缩放；如果是当前页还原则不处理
        if (isLast) {
            
            for (NSInteger i = 0; i < self.subviews.count - 1 - __otherSubViewNum && i < self.visiableItems.count; i++) {
                
                CardViewItem * nextItem = self.visiableItems[i];
                
                if (i == 0) {
                    [nextItem addAlphaMaskView];
                }
                
                // 已显示了足够多的项时，直接移除最底下的项
                if (i == self.maxItems - 1) {
                    
                    nextItem.alpha = 0;
                    hiddenItem = nextItem;
                }
                else {
                    [nextItem setTransformForItem:i + 1];
                }
            }
            
            __visibleIndex--;
            
            if (self.isNeedControl) {
                [self updatePageControl];
            }
        }
        
    } completion:^(BOOL finished) {
        
        if (hiddenItem) {
            [hiddenItem removeFromSuperview];
            hiddenItem.alpha = 1;
            [self.visiableItems removeObject:hiddenItem];
            [self addObjectToReusableItems:hiddenItem];
        }
        if (isLast) {
            [self.visiableItems insertObject:item atIndex:0];
        }
        else if (__lastItem){  // 如果是操作当前页，删除 lastItem
            [__lastItem removeFromSuperview];
            __lastItem = nil;
        }
        __curItem = nil;
    }];
}

/**
  *  @brief   点击手势（选中）
  */
- (void)tap:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(cardView:didSelectItemAtIndex:)]) {
        
        [self.delegate cardView:self didSelectItemAtIndex:__visibleIndex];
    }
}

@end


ItemEdges CardViewItemEdgesMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    ItemEdges edge;
    edge.top = top;
    edge.left = left;
    edge.right = right;
    edge.bottom = bottom;
    return edge;
}


