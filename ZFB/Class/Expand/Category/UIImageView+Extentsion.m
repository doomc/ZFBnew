//
//  UIImageView+Extentsion.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "UIImageView+Extentsion.h"

@implementation UIImageView (Extentsion)


- (void)setHeaderUrl:(NSString *)url
{
    [self setCircleHeaderUrl:url];
}

- (void)setCircleHeaderUrl:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_studio_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        self.image = [image circleImage];
    }];
}
- (void)setHeaderUrl:(NSString *)url withplaceholderImageName:(NSString *)placeholderImageName
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        self.image = [image circleImage];
    }];
    
}
@end
