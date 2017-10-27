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
 
    self.store_listView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.store_listView.contentMode = UIViewContentModeScaleToFill;
}
 

-(void)setFindgoodslist:(Findgoodslist *)findgoodslist
{
    _findgoodslist = findgoodslist;
    self.lb_distence.text = [NSString stringWithFormat:@"%@公里",findgoodslist.storeDist];
    self.lb_collectNum.text = [NSString stringWithFormat:@"%ld",_findgoodslist.likeNum];
    self.store_listTitle.text = _findgoodslist.storeName;
    [self.store_listView sd_setImageWithURL:[NSURL URLWithString:_findgoodslist.coverUrl] placeholderImage:[UIImage imageNamed:@"720x300"]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
