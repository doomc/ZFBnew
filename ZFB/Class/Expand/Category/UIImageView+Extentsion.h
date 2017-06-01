//
//  UIImageView+Extentsion.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extentsion)

// 没有占位图片
- (void)setHeaderUrl:(NSString *)url;
// 带有占位图片
- (void)setHeaderUrl:(NSString *)url withplaceholderImageName:(NSString *)placeholderImageName;


@end
