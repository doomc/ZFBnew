//
//  SearchStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchStoreCell.h"

@implementation SearchStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setStorelist:(Findgoodslist *)storelist
{
    _storelist = storelist;
    self.lb_distance.text = [NSString stringWithFormat:@"%@公里", storelist.storeDist ];
    self.lb_title.text = storelist.storeName;
    [self.img_allStoreView sd_setImageWithURL:[NSURL URLWithString:storelist.coverUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
    
}


@end
