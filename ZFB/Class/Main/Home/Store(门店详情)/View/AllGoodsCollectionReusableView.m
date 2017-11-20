//
//  AllGoodsCollectionReusableView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AllGoodsCollectionReusableView.h"
@interface AllGoodsCollectionReusableView ()

@property (nonatomic, assign) StoreScreenType selectedType;
@property (nonatomic, strong) UIButton *selectBtn;

@end
@implementation AllGoodsCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        _titles = titles;
        for (int i = 0 ; i < titles.count; i++) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button = [[UIButton alloc]initWithFrame:CGRectMake(i * (KScreenW/4), 0, KScreenW/4, 44)];
            [button setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(didclickChoosed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            button.tag = 200+i;
            NSLog(@"tag === %ld ",button.tag);
            if (i == 0) {
                [self didclickChoosed:button];
            }
        }

        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

-(void)didclickChoosed:(UIButton *)sender {
    
    [_selectBtn setTitleColor:HEXCOLOR(0x8d8d8d) forState:UIControlStateNormal];
    
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

    if ([_delegate respondsToSelector:@selector(selectStoreType:)]) {
        
        [_delegate selectStoreType:_selectedType];
        
    }
  
}

@end
