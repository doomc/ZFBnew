

//
//  ZFSaleAfterContentCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSaleAfterContentCell.h"

@implementation ZFSaleAfterContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.saleAfter_btn addTarget:self action:@selector(saleAfter_btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.saleAfter_btn.layer.masksToBounds = YES;
    self.saleAfter_btn.layer.cornerRadius = 4;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

///申请售后
-(void)saleAfter_btnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(salesAfterDetailPageWithIndexPath:)]) {
        [self.delegate salesAfterDetailPageWithIndexPath:_indexPath];
    }
}
//set
-(void)setGoods:(Ordergoods *)goods
{
    _goods = goods;
    
    self.lb_goodcount.text = [NSString stringWithFormat:@"数量x%ld",goods.goodsCount];
    self.lb_title.text =  goods.goods_name;
    [self.img_saleAfter sd_setImageWithURL:[NSURL URLWithString:goods.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
    
    if ([self isEmptyArray:goods.goods_properties]) {
        
        self.lb_progrop.text = @"";
    }else{
        NSMutableArray * mutNameArray = [NSMutableArray array];
        for (OrderProper * pro in goods.goods_properties) {
            NSString * value =  pro.value;
            [mutNameArray addObject:value];
        }
        self.lb_progrop.text = [NSString stringWithFormat:@"规格:%@",[mutNameArray componentsJoinedByString:@" "]];
    }
    ///status 0 未操作 1 退货中 2 服务完成
    if (goods.status == 0) {
        
        [self.saleAfter_btn setTitle:@"申请售后" forState:UIControlStateNormal];
        self.saleAfter_btn.backgroundColor = HEXCOLOR(0xf95a70);
        [self.saleAfter_btn setTitleColor: HEXCOLOR(0xffffff) forState:UIControlStateNormal] ;

        self.saleAfter_btn.enabled = YES;
    }
    if (goods.status == 1)
    {
        [self.saleAfter_btn setTitle:@"退货中" forState:UIControlStateNormal];
        self.saleAfter_btn.backgroundColor = [UIColor whiteColor];
        [self.saleAfter_btn setTitleColor: HEXCOLOR(0xf95a70) forState:UIControlStateNormal] ;
        self.saleAfter_btn.enabled = NO;
    }
     if (goods.status == 2){
        self.saleAfter_btn.backgroundColor = [UIColor whiteColor];
        [self.saleAfter_btn setTitleColor: HEXCOLOR(0xf95a70) forState:UIControlStateNormal] ;
        self.saleAfter_btn.enabled = NO;
        [self.saleAfter_btn setTitle:@"服务完成" forState:UIControlStateNormal];

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
