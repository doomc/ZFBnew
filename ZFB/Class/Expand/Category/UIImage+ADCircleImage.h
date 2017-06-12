//
//  UIImage+ADCircleImage.h
//  mkxy_cwyyxy
//
//  Created by mkxy on 17/5/17.
//  Copyright © 2017年 mkxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ADCircleImage)

//1.对象调用
-(instancetype)circleImage;
//2.类名调用
+(instancetype)imageWithName:(NSString *)name;

@end
