//
//  SearchTypeView.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchTypeView.h"

@implementation SearchTypeView
 
/**
 品牌选择

 @param sender sender
 */
- (IBAction)brandListAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(brandActionlist:)]) {
        [self.delegate brandActionlist:sender];
    }
}
/**
 价格排序
 
 @param sender sender
 */
- (IBAction)priceSortAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(priceSortAction: )]) {
        [self.delegate priceSortAction:sender];
    }
}

/**
 销量排序
 
 @param sender sender
 */
- (IBAction)salesSortAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(salesSortAction: )]) {
        [self.delegate salesSortAction:sender];
    }
}
/**
距离排序
 
 @param sender sender
 */
- (IBAction)distenceSortAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(distenceSortAction :)]) {
        [self.delegate distenceSortAction:sender];
    }
}

@end
