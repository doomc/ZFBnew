//
//  SearchHasDataCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchHasDataCell.h"

@implementation SearchHasDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.clipsToBounds = YES;
    
}

-(void)setGoodList:(ResultFindgoodslist *)goodList
{
    _goodList= goodList;
    self.lb_Price.text = [NSString stringWithFormat:@"¥%@",goodList.priceTostr];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:goodList.coverImgUrl ] placeholderImage:[UIImage imageNamed:@"240x260"]];
    self.lb_storeName.text = goodList.storeName;
    self.lb_title.text = goodList.goodsName;
}
@end
