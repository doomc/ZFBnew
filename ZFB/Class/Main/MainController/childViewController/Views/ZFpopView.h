//
//  ZFpopView.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZFpopViewDelegate <NSObject>


-(void)sendTitle:(NSString *)title orderType:(OrderType)type;

@end
@interface ZFpopView : UIView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@property (nonatomic, strong) NSArray *titleArray;


@property (nonatomic, assign) id<ZFpopViewDelegate> delegate;


@end
