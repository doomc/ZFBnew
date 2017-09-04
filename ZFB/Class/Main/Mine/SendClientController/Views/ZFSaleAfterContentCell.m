

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
    self.saleAfter_btn.clipsToBounds = YES;
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
    [self.img_saleAfter sd_setImageWithURL:[NSURL URLWithString:goods.coverImgUrl] placeholderImage:[UIImage imageNamed:@"errorImage"]];
    ///status 0 未操作 1 退货中 2 服务完成
    if (goods.status == 0) {
        
        
    }else if (goods.status == 1)
    {
        [self.saleAfter_btn setTitle:@"退货中" forState:UIControlStateNormal];
        self.saleAfter_btn.backgroundColor = [UIColor whiteColor];
        [self.saleAfter_btn setTitleColor: HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal] ;
        self.saleAfter_btn.enabled = NO;
    }
    else{
        self.saleAfter_btn.backgroundColor = [UIColor whiteColor];
        [self.saleAfter_btn setTitleColor: HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal] ;
        self.saleAfter_btn.enabled = NO;
        [self.saleAfter_btn setTitle:@"服务完成" forState:UIControlStateNormal];

    }
    NSLog(@"图片地址 ====== %@",goods.coverImgUrl);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
