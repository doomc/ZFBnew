//
//  SukItemCollectionViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  sku 规则

#import <UIKit/UIKit.h>
@protocol SukItemCollectionViewDelegate <NSObject>

@optional
-(void)selectedButton:(UIButton *)button;


@end
@interface SukItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectItemColor;

@property ( nonatomic, assign) id<SukItemCollectionViewDelegate>itemDelegate;

@end
