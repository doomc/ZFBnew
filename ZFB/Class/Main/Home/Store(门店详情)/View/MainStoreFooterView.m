//
//  MainStoreFooterView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "MainStoreFooterView.h"

@implementation MainStoreFooterView

-(instancetype)initWithFooterViewFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;
    }
    return self;
}

//到店逛 -- 地图
- (IBAction)NavMap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickMapNavgation)]) {
        [self.delegate didClickMapNavgation];
    }
}
//店铺信息
- (IBAction)storeMessage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickStoreInfo)]) {
        [self.delegate didClickStoreInfo];
    }
}

//联系卖家
- (IBAction)contactStore:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickContactStore)]) {
        [self.delegate didClickContactStore];
    }
}
 
@end

