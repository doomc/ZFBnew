//
//  SearchCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self.didClickLocation addTarget:self action:@selector(didClickLocation:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)didClickLocation:(UIButton * )sender
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
