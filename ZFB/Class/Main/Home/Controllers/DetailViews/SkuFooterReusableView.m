//
//  SkuFooterReusableView.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SkuFooterReusableView.h"
@interface SkuFooterReusableView ()

{
    NSInteger num ;
}

@end
@implementation SkuFooterReusableView


/**
 
 增加数量
 @param sender sender
 */
- (IBAction)addAction:(id)sender {
 
    
    num  = num + 1 ;
    
    _lb_count.text = [NSString stringWithFormat:@"%ld",(long)num];
    [self.countDelegate addCount:num];
    
}
/**
 
 减少
 @param sender reduceAction
 */
- (IBAction)reduceAction:(id)sender {
    
    if ((num - 1) <= 1|| num == 1) {
        NSLog(@"超出范围");
        
    }else{
        
        num  = num -1;
    }
    _lb_count.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    [self.countDelegate addCount:num];
    
}



@end
