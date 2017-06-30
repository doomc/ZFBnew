//
//  ZFSaleAfterTopView.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  申请售后  和 进度查询view

#import <UIKit/UIKit.h>
@protocol ZFSaleAfterTopViewDelegate <NSObject>

-(void)sendAtagNum :(NSInteger)tagNum;


@end

@interface ZFSaleAfterTopView : UIView

@property(nonatomic,assign)id <ZFSaleAfterTopViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)arr;

@end
