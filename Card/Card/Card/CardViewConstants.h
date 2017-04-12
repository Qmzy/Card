//
//  CardViewConstants.h
//  Card
//
//  Created by D on 17/1/5.
//  Copyright © 2017年 D. All rights reserved.


#ifndef CardView_Constants_h
#define CardView_Constants_h

#define SELF_WEAK    __weak __typeof(self)weakSelf = self
#define SELF_STRONG  __strong __typeof(weakSelf)strongSelf = weakSelf

#define W(x)       x.frame.size.width
#define H(x)       x.frame.size.height

#define R(rgb)     (float)((rgb & 0xFF0000) >> 16) / 255.0
#define G(rgb)     (float)((rgb & 0xFF00) >> 8) / 255.0
#define B(rgb)     (float)(rgb & 0xFF) / 255.0
#define RGB(rgb)   [UIColor colorWithRed:R(rgb) green:G(rgb) blue:B(rgb) alpha:1.0]


#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height

#define CARD_ITEM_W      SCREEN_WIDTH * 62 / 75.0
#define CARD_ITEM_H      SCREEN_WIDTH / 320.0 * 400

// 右侧响应长度
#define CARDITEM_RIGHT_RESPONDLENGTH    SCREEN_WIDTH / 320.0 * 80

#endif
