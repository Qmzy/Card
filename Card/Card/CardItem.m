//
//  CardItem.m
//  Card
//
//  Created by D on 17/1/4.
//  Copyright © 2017年 D. All rights reserved.


#import "CardItem.h"
#import "CardData.h"
#import "CardViewConstants.h"


@interface CardItem ()

@property (weak, nonatomic) IBOutlet UIView  * bgView;
@property (weak, nonatomic) IBOutlet UIImageView * iconImageView;
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * joinNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel * contentLabel;
@property (weak, nonatomic) IBOutlet UILabel * pLengthLabel;
@property (weak, nonatomic) IBOutlet UIView  * alphaMaskView;

@end


@implementation CardItem

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius  = 10;
    
    self.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset  = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.15;
    self.layer.shadowRadius  = 2;
}

- (void)setItemWithData:(CardData *)data
{
    self.iconImageView.image = [UIImage imageNamed:data.imageName];
    self.titleLabel.text = data.title;
    
    NSMutableAttributedString * maStr = [[NSMutableAttributedString alloc] initWithString:data.joinNumber];
    [maStr addAttribute:NSForegroundColorAttributeName
                  value:RGB(0x75ac47)
                  range:NSMakeRange(2, data.joinNumber.length - 5)];
    self.joinNumberLabel.attributedText = maStr;
    
    self.contentLabel.text = data.content;
    self.pLengthLabel.text = data.planLength;
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
