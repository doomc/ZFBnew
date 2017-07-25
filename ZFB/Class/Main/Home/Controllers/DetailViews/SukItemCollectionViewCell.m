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
    self.selectItemColor.layer.cornerRadius = 2;
    self.selectItemColor.layer.borderWidth = 0.5;
    self.selectItemColor.layer.borderColor = HEXCOLOR(0xA7A7A7).CGColor;
    self.selectItemColor.userInteractionEnabled = NO;
}

-(void)setSkuValueoObj:(SkuValulist *)skuValueoObj
{
    _skuValueoObj = skuValueoObj;
//    [_selectItemColor setTitle:skuValueoObj.nameId forState:UIControlStateNormal] ;

    
}
- (void)setValueObj:(Valuelist *)valueObj
{
    _valueObj = valueObj;
    [_selectItemColor setTitle:valueObj.name forState:UIControlStateNormal] ;
}

- (void)setIsSelecteditems:(BOOL)isSelecteditems
{
    _isSelecteditems = isSelecteditems;
    if (_isSelecteditems) {
        [_selectItemColor setBackgroundColor:HEXCOLOR(0xfe6d6a)];
        [_selectItemColor setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        
    }else{
        [_selectItemColor setBackgroundColor:HEXCOLOR(0xffffff)];
        [_selectItemColor setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    }
}

@end
