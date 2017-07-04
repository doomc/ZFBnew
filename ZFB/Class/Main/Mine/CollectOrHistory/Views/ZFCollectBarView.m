//
//  ZFCollectBarView.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFCollectBarView.h"

@implementation ZFCollectBarView


-(void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - 取消收藏代理

- (IBAction)cancelCollectAction:(id)sender {
    
    [self.delegate didClickCancelCollect:sender];
}

#pragma mark - 全选代理
- (IBAction)selectedAllaction:(id)sender {
    
    [self.delegate didClickSelectedAll:sender];
}



@end
