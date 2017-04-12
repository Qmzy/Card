//
//  CardItem2.m
//  Card
//
//  Created by D on 17/1/6.
//  Copyright © 2017年 D. All rights reserved.


#import "CardItem2.h"


@interface CardItem2 ()

@property (weak, nonatomic) IBOutlet UIView * bgView;
@property (weak, nonatomic) IBOutlet UIView * alphaMaskView;

@end


@implementation CardItem2

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius  = 10;
    
    self.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset  = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.15;
    self.layer.shadowRadius  = 2;
}

- (void)addAlphaMaskView
{
    self.alphaMaskView.alpha = 0.1;
}

- (void)removeAlphaMaskView
{
    self.alphaMaskView.alpha = 0;
}

@end
