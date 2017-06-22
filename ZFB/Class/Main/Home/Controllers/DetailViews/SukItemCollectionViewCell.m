//
//  SukItemCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SukItemCollectionViewCell.h"

@implementation SukItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectItemColor.clipsToBounds = YES;
    self.selectItemColor.layer.cornerRadius = 2;
    self.selectItemColor.layer.borderWidth = 0.5;
    self.selectItemColor.layer.borderColor = HEXCOLOR(0xA7A7A7).CGColor;
 
    [_selectItemColor addTarget:self action:@selector(selectItemColor:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)selectItemColor:(UIButton *)sender{
     
    if ([self.itemDelegate respondsToSelector:@selector(selectedButton:)]) {
        [self.itemDelegate selectedButton:sender];
    }
}
@end
