//
//  CardViewItem.h
//  Card
//
//  Created by D on 17/1/3.
//  Copyright © 2017年 D. All rights reserved.


#import <UIKit/UIKit.h>

@interface CardViewItem : UIView

@property (nonatomic, copy) NSString * reuseIdentifier;  // 复用标示符

- (void)addAlphaMaskView;
- (void)removeAlphaMaskView;

@end
