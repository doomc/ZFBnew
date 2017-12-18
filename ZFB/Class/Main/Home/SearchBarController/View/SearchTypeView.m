//
//  SearchTypeView.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchTypeView.h"
@interface SearchTypeView()

@end

@implementation SearchTypeView

-(instancetype)initWithSearchTypeViewFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SearchTypeView" owner:self options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}
/**
 品牌选择

 @param sender sender
 */
- (IBAction)brandListAction:(id)sender {
    
    [self selectType:sender AndTag:_searchType];

    [_priceBtn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_salesBtn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_salesBtn  setImage:[UIImage imageNamed:@"arrowdown_black"] forState:UIControlStateNormal];//正常
    [_priceBtn  setImage:[UIImage imageNamed:@"arrowdown_black"] forState:UIControlStateNormal];//正常

}
/**
 价格排序
 
 @param sender sender
 */
- (IBAction)priceSortAction:(id)sender {
    [self selectType:sender AndTag:_searchType];
    [_brandBtn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_salesBtn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_brandBtn  setImage:[UIImage imageNamed:@"arrowdown_black"] forState:UIControlStateNormal];//正常
    [_salesBtn  setImage:[UIImage imageNamed:@"arrowdown_black"] forState:UIControlStateNormal];//正常
}

/**
 销量排序
 
 @param sender sender
 */
- (IBAction)salesSortAction:(id)sender {

    [self selectType:sender AndTag:_searchType];
    [_brandBtn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_priceBtn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_brandBtn  setImage:[UIImage imageNamed:@"arrowdown_black"] forState:UIControlStateNormal];//正常
    [_priceBtn  setImage:[UIImage imageNamed:@"arrowdown_black"] forState:UIControlStateNormal];//正常

}


-(void)selectType:(UIButton *)sender AndTag:(NSInteger)tag
{
    [sender setTitleColor:HEXCOLOR(0xf95a70) forState:UIControlStateNormal];
    [sender  setImage:[UIImage imageNamed:@"arrowdown_red"] forState:UIControlStateNormal];//正常
    NSInteger selectTag = sender.tag;
    
    switch (selectTag) {
        case 1000:
            _searchType  = GoodsSearchTypeBand;//品牌哦
            break;
        case 1001:
            _searchType  = GoodsSearchTypePrice;//价格

            break;
        case 1002:
            _searchType  = GoodsSearchTypeSales;//销售

            break;
 
    }
    
    if ([self.delegate respondsToSelector:@selector(selectGoodsSearchType:  )]) {
        [self.delegate selectGoodsSearchType:_searchType ];
    }
}



@end
