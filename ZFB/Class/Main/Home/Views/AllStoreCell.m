//
//  AllStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AllStoreCell.h"
@interface AllStoreCell ()

@end
@implementation AllStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.img_allStoreView.clipsToBounds = YES;
    self.img_allStoreView.layer.borderWidth = 0.5;
    self.img_allStoreView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;

//    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 120, 40) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self];
 
}
-(void)setStorelist:(Findgoodslists *)Storelist
{
    _Storelist = Storelist;
    
    CGFloat juli = [_Storelist.storeDist floatValue]*0.001;
    self.lb_distance.text = [NSString stringWithFormat:@"%.2fkm",juli];
    self.lb_title.text = _Storelist.storeName;
    [self.img_allStoreView sd_setImageWithURL:[NSURL URLWithString:_Storelist.coverUrl] placeholderImage:nil];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
