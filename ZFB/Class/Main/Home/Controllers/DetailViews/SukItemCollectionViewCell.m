//
//  SukItemCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SukItemCollectionViewCell.h"

@interface SukItemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectItemColor;

@end

@implementation SukItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectItemColor.clipsToBounds = YES;
    self.selectItemColor.layer.cornerRadius = 2;
    self.selectItemColor.layer.borderWidth = 0.5;
    self.selectItemColor.layer.borderColor = HEXCOLOR(0xA7A7A7).CGColor;
    self.selectItemColor.userInteractionEnabled = NO;
}


- (void)setValueObj:(Valuelist *)valueObj
{
    _valueObj = valueObj;
    [_selectItemColor setTitle:valueObj.name forState:UIControlStateNormal] ;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        [_selectItemColor setBackgroundColor:HEXCOLOR(0xfe6d6a)];
        [_selectItemColor setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        
    }else{
        [_selectItemColor setBackgroundColor:HEXCOLOR(0xffffff)];
        [_selectItemColor setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    }
}

@end
