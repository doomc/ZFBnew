//
//  AllGoodsSelectTypeCollectionCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AllGoodsSelectTypeCollectionCell.h"

@implementation AllGoodsSelectTypeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _flag = 1;//默认升序
    
}
- (IBAction)comprehensiveTarget:(id)sender {

    [self didclickChoosed:sender];
    [_price_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_sales_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_latest_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_price_btn  setImage:[UIImage imageNamed:@"price_off"] forState:UIControlStateNormal];//正常

}

- (IBAction)salesTarget:(id)sender {

    
    [self didclickChoosed:sender];
    [_price_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_latest_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_comprehensive_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_price_btn  setImage:[UIImage imageNamed:@"price_off"] forState:UIControlStateNormal];//正常

}

- (IBAction)latestTarget:(id)sender {

    
    [self didclickChoosed:sender];
    [_price_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_sales_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_comprehensive_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_price_btn  setImage:[UIImage imageNamed:@"price_off"] forState:UIControlStateNormal];//正常

}

- (IBAction)priceTarget:(UIButton*)sender {


    [_sales_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_latest_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_comprehensive_btn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    
    [self didclickChoosed:sender];

    if (_flag == 1) {//升序
        _flag = 2;
        [_price_btn  setImage:[UIImage imageNamed:@"price2"] forState:UIControlStateNormal];//升序
        return;
    }if (_flag == 2) {
        _flag = 1;
        [_price_btn  setImage:[UIImage imageNamed:@"price"] forState:UIControlStateNormal];//降序
        return;
    }

    NSLog(@" -----%ld ====",_flag);
}

//统一方法
-(void)didclickChoosed:(UIButton *)sender {
    
    [sender setTitleColor:HEXCOLOR(0xf95a70) forState:UIControlStateNormal];
    NSInteger selectTag = sender.tag;
    
    switch (selectTag) {
        case 200:
            _selectedType = StoreScreenTypeAll;//综合排序
            break;
        case 201:
            _selectedType = StoreScreenTypeSales;//销量排序
            
            break;
        case 202:
            _selectedType = StoreScreenTypelastGoods;//最新排序
            
            break;
        case 203:
            _selectedType = StoreScreenTypePrice;//价格排序
            
            break;
    }

    if ([_delegate respondsToSelector:@selector(selectStoreType:flag:)]) {

        [_delegate selectStoreType:_selectedType flag:_flag];

    }
    
}

@end
