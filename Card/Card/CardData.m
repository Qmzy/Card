//
//  CardData.m
//  Card
//
//  Created by D on 17/1/4.
//  Copyright © 2017年 D. All rights reserved.


#import "CardData.h"

@implementation CardData

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title
{
    if (self = [super init]) {
        
        self.imageName  = imageName;
        self.title      = title;
        
        self.joinNumber = [NSString stringWithFormat:@"已有%d人参加", arc4random()%2000 + 50];
        self.planLength = [NSString stringWithFormat:@"方案周期：%d天", arc4random()%20 + 10];
    }
    return self;
}

@end
