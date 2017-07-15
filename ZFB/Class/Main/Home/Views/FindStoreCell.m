//
//  FindStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FindStoreCell.h"

@implementation FindStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    
}
 

-(void)setFindgoodslist:(FindStoreGoodslist *)findgoodslist
{
    _findgoodslist = findgoodslist;
    
    CGFloat juli = [_findgoodslist.storeDist floatValue]*0.001;
    self.lb_distence.text = [NSString stringWithFormat:@"%.2f公里",juli];
    self.lb_collectNum.text = [NSString stringWithFormat:@"%ld",_findgoodslist.likeNum];
    self.store_listTitle.text = _findgoodslist.storeName;
    [self.store_listView sd_setImageWithURL:[NSURL URLWithString:_findgoodslist.coverUrl] placeholderImage:nil];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
