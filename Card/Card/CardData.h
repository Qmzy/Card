//
//  CardData.h
//  Card
//
//  Created by D on 17/1/4.
//  Copyright © 2017年 D. All rights reserved.


#import <Foundation/Foundation.h>

@interface CardData : NSObject

@property (nonatomic, copy) NSString * imageName;  // 图片名称。实际可以为 url
@property (nonatomic, copy) NSString * title;      // 标题
@property (nonatomic, copy) NSString * joinNumber; // 参加人数
@property (nonatomic, copy) NSString * content;    // 内容
@property (nonatomic, copy) NSString * planLength; // 计划周期
@property (nonatomic, assign) NSInteger star;      // 星级

- (instancetype)initWithImageName:(NSString *)imageName
                            title:(NSString *)title;

@end

@protocol CardData <NSObject>

@end
