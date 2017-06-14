//
//  AllStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AllStoreCell.h"
@interface AllStoreCell ()<DidChangedStarDelegate>

@end
@implementation AllStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img_allStoreView.clipsToBounds = YES;
    self.img_allStoreView.layer.borderWidth = 0.5;
    self.img_allStoreView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    

    [self.starView initWithFrame:CGRectMake(0, 0, 125, 30) numberOfStars:5 isVariable:YES];
    self.starView.actualScore = 3;
    self.starView.fullScore = 5;
    self.starView.delegate = self;
    
}
- (void)didChangeStar {
    NSLog(@"这次星级为 %f",_starView.actualScore);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
