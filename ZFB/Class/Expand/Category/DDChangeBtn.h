//
//  DDChangeBtn.h
//  zfb
//
//  Created by  展富宝  on 2017/8/7.
//  Copyright © 2017年 com.zfb. All rights reserved.


#import <UIKit/UIKit.h>

@interface DDChangeBtn : UIButton

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, assign) CGRect titleF;

@property (nonatomic, assign) BOOL noLeft;

@property (nonatomic, assign) CGFloat margin;

- (void)changeFrame:(CGSize)imageSize margin:(CGFloat)margin;

- (void)changeFrame:(CGSize)imageSize;

@end
