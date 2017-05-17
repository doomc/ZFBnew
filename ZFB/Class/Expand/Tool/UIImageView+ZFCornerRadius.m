//
//  UIImageView+ZFCornerRadius.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "UIImageView+ZFCornerRadius.h"

@implementation UIImageView (ZFCornerRadius)

- (UIImageView *)CreateImageViewWithFrame:(CGRect)rect
                            andBackground:(CGColorRef)color
                                andRadius:(CGFloat)radius{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIGraphicsBeginImageContext(imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();   // 设置上下文
    CGContextSetLineWidth(context, 1);                  // 边框大小
    CGContextSetStrokeColorWithColor(context, color);   // 边框颜色
    CGContextSetFillColorWithColor(context, color);     // 填充颜色
    
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextMoveToPoint(context, x+width, y+radius/2);
    CGContextAddArcToPoint(context, x+width, y+height, x+width-radius/2, y+height, radius);
    CGContextAddArcToPoint(context, x, y+height, x, y+height-radius/2, radius);
    CGContextAddArcToPoint(context, x, y, x+radius/2, y, radius);
    CGContextAddArcToPoint(context, x+width, y, x+width, y+radius/2, radius);
    CGContextDrawPath(context, kCGPathFillStroke);
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageView;
}

@end
