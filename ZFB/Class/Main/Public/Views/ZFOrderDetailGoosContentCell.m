//
//  ZFOrderDetailGoosContentCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFOrderDetailGoosContentCell.h"

@implementation ZFOrderDetailGoosContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle       = UITableViewCellSelectionStyleNone;

}

-(void)setGoodlist:(DetailGoodslist *)goodlist
{
    _goodlist =  goodlist;
    
    self.lb_title.text = _goodlist.goodsName;
    CGFloat purchasePrice = [_goodlist.purchasePrice floatValue];
    
    self.lb_price.text = [NSString stringWithFormat:@"¥%.2f",purchasePrice];
    self.lb_count.text = [NSString stringWithFormat:@"x %@",_goodlist.goodsCount];
    [self.img_orderDetailView sd_setImageWithURL:[NSURL URLWithString:_goodlist.coverImgUrl] placeholderImage:nil];
    
    if ([self isEmptyArray:goodlist.goodsProperties]) {
        NSLog(@"订单详情无规格");
        self.lb_suk.text = @"";
    }else{
        NSMutableArray * mutNameArray = [NSMutableArray array];
        for (OrderGoodsProperties * pro in goodlist.goodsProperties) {
            NSString * value =  pro.value;
            [mutNameArray addObject:value];
            NSLog(@"name = %@",value);
        }
        self.lb_suk.text = [NSString stringWithFormat:@"规格:%@",[mutNameArray componentsJoinedByString:@" "]];
    }
    
    
}

#pragma mark - 判断是不是空数组
- (BOOL)isEmptyArray:(NSArray *)array
{
    return (array.count == 0 || array == nil || [array isKindOfClass:[NSNull class]]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
