//
//  UIView+ZFCornerRadius.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZFCornerRadius)

- (UIView *)clipCornerWithView:(UIView *)originView
                    andTopLeft:(BOOL)topLeft
                   andTopRight:(BOOL)topRight
                 andBottomLeft:(BOOL)bottomLeft
                andBottomRight:(BOOL)bottomRight;


@end
