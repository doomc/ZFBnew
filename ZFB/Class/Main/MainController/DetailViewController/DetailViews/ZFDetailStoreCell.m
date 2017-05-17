//
//  ZFDetailStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFDetailStoreCell.h"

@implementation ZFDetailStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ZFDetailStoreCell" owner:self options:nil].lastObject;
        
    }
    
    return self;
}

@end
