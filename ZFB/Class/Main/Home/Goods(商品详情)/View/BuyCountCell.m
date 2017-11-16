//
//  BuyCountCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BuyCountCell.h"

@implementation BuyCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


/**
 
 增加数量
 @param sender sender
 */
- (IBAction)addAction:(id)sender {
    
    
    _num ++ ;
    
    _lb_count.text = [NSString stringWithFormat:@"%ld",(long)_num];
    [self.delegate addCount:_num];
    
}
/**
 
 减少
 @param sender reduceAction
 */
- (IBAction)reduceAction:(id)sender {
    
    if ((_num - 1) < 1|| _num == 1) {
        NSLog(@"超出范围");
        
    }else{
        
        _num --;
    }
    _lb_count.text = [NSString stringWithFormat:@"%ld",(long)_num];
    
    [self.delegate addCount:_num];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
