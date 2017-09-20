//
//  SelectTimeCollectionCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SelectTimeCollectionCell.h"

@implementation SelectTimeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _lb_name.layer.cornerRadius = 4;
    _lb_name.layer.masksToBounds = YES;
}

@end
