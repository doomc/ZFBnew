//
//  HomePageStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HomePageStoreCell.h"

@implementation HomePageStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.lb_address.preferredMaxLayoutWidth = KScreenW - 140 - 20 - 20 - self.lb_address.width;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFindgoodslist:(Findgoodslist *)findgoodslist
{
    _findgoodslist = findgoodslist;
    self.lb_distence.text = [NSString stringWithFormat:@"%@公里",findgoodslist.storeDist];
    self.lb_collect.text = [NSString stringWithFormat:@"%ld",findgoodslist.collectCount];
    self.lb_title.text = findgoodslist.storeName;
    [self.storeImg sd_setImageWithURL:[NSURL URLWithString:findgoodslist.coverUrl] placeholderImage:[UIImage imageNamed:@"720x300"]];
    self.lb_address.text = findgoodslist.address;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
