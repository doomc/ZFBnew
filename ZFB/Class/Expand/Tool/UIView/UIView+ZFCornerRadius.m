//
//  UIView+ZFCornerRadius.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "UIView+ZFCornerRadius.h"

@implementation UIView (ZFCornerRadius)

- (UIView *)clipCornerWithView:(UIView *)originView
                    andTopLeft:(BOOL)topLeft
                   andTopRight:(BOOL)topRight
                 andBottomLeft:(BOOL)bottomLeft
                andBottomRight:(BOOL)bottomRight
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:originView.bounds
                                                   byRoundingCorners:(topLeft==YES ? UIRectCornerTopLeft : 0) |
                              (topRight==YES ? UIRectCornerTopRight : 0) |
                              (bottomLeft==YES ? UIRectCornerBottomLeft : 0) |
                              (bottomRight==YES ? UIRectCornerBottomRight : 0)
                                                         cornerRadii:CGSizeMake(10, 10)];
    // 创建遮罩层
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = originView.bounds;
    maskLayer.path = maskPath.CGPath;   // 轨迹
    originView.layer.mask = maskLayer;
    
    return originView;
}


@end
