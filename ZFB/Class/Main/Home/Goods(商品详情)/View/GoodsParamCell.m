//
//  GoodsParamCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "GoodsParamCell.h"

@implementation GoodsParamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//图文详情
- (IBAction)detaiContent:(UIButton*)sender {
    NSLog(@"图文详情");

    [_btn_param setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    [_btn_promiss setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    [self didChoosed:sender];

}
//规格参数
- (IBAction)skuParamContent:(UIButton*)sender {
    NSLog(@"规格参数");
    [_btn_detail setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    [_btn_promiss setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    [self didChoosed:sender];

}
//商家承诺
- (IBAction)promissContent:(UIButton*)sender {
    NSLog(@"商家承诺");
    [_btn_detail setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    [_btn_param setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];

    [self didChoosed:sender];

}

-(void)didChoosed:(UIButton *)button
{
    [button setTitleColor:HEXCOLOR(0xf95a70) forState:UIControlStateNormal];
    NSInteger tag = button.tag;
    
    switch (tag) {
        case 300:
            _goodsParamType = GoodsParamTypeDetailContent;
            break;
        case 301:
            _goodsParamType = GoodsParamTypeSkuParam;

            break;
        case 302:
            _goodsParamType = GoodsParamTypePromiss;

            break;

    }
    if ([self.delegate respondsToSelector:@selector(didClickGoodsType:)]) {
        [self.delegate didClickGoodsType:_goodsParamType];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
