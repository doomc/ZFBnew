//
//  UIImageView+ZFCornerRadius.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZFCornerRadius)

- (UIImageView *)CreateImageViewWithFrame:(CGRect)rect
                            andBackground:(CGColorRef)color
                                andRadius:(CGFloat)radius;

@end
