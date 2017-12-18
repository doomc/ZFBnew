//
//  SearchStoreTypeView.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchStoreTypeView.h"

@implementation SearchStoreTypeView

-(instancetype)initWithSearchStoreViewFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle ]loadNibNamed:@"SearchStoreTypeView" owner:self  options:nil].lastObject;
        self.frame = frame;
    }
    return self;
    
}
//选择品牌
- (IBAction)selectedBand:(id)sender {
    [self selectType:sender andType:_searchType];

    [_distenceBtn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_distenceBtn  setImage:[UIImage imageNamed:@"arrowdown_black"] forState:UIControlStateNormal];//正常
}

//选择距离
- (IBAction)selectDistence:(id)sender {
    [self selectType:sender andType:_searchType];

    [_brandBtn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    [_brandBtn  setImage:[UIImage imageNamed:@"arrowdown_black"] forState:UIControlStateNormal];//正常
}

-(void)selectType:(UIButton *)sender andType:(NSInteger)type
{
    [sender setTitleColor:HEXCOLOR(0xf95a70) forState:UIControlStateNormal];
    [sender  setImage:[UIImage imageNamed:@"arrowdown_red"] forState:UIControlStateNormal];//正常
    NSInteger selectTag = sender.tag;
    
    switch (selectTag) {
        case 2000:
            _searchType  = StoreSearchTypeBand;//品牌哦
            break;
        case 2001:
            _searchType  = StoreSearchTypeDistence;//距离

            break;
     }
    if ([self.delegate respondsToSelector:@selector(selectStoreSearchType:)]) {
        [self.delegate selectStoreSearchType:_searchType];
        
    }
}



@end
