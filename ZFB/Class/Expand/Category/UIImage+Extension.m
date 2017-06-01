//
//  UIImage+Extension.m
//  SportsFans
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 1000phone. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


+(instancetype)imageWithOriginalImageName:(NSString *)imageName{
    
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}


- (instancetype)circleImage
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)circleImage:(NSString *)image
{
    return [[self imageNamed:image] circleImage];
}
@end
