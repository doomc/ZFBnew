//
//  SukItemCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SukItemCollectionViewCell.h"

@interface SukItemCollectionViewCell ()


@end

@implementation SukItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectItemColor.clipsToBounds = YES;
    self.selectItemColor.layer.cornerRadius = 4;
    self.selectItemColor.layer.borderWidth = 0.5;
    self.selectItemColor.layer.borderColor = HEXCOLOR(0x999999).CGColor;
    self.selectItemColor.userInteractionEnabled = NO;
}

 
- (void)setValueObj:(Valuelist *)valueObj
{
    _valueObj = valueObj;
    [_selectItemColor setTitle:valueObj.name forState:UIControlStateNormal] ;
    
    switch (valueObj.selectType) {
        case ValueSelectType_normal:
            [_selectItemColor setBackgroundColor:HEXCOLOR(0xffffff)];
            [_selectItemColor setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
            break;
        case ValueSelectType_selected:
            [_selectItemColor setBackgroundColor:HEXCOLOR(0xf95a70)];
            [_selectItemColor setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
            break;
        case ValueSelectType_enable:
            [_selectItemColor setBackgroundColor:HEXCOLOR(0xf5f5f5)];
            [_selectItemColor setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            break;
    }
}

 

@end
