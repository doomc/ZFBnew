//
//  SukItemCollectionViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  sku 规则

#import <UIKit/UIKit.h>
#import "DetailGoodsModel.h"
#import "SkuMatchModel.h"

@interface SukItemCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Valuelist   * valueObj;

@property (strong, nonatomic) SkuValulist * skuValueoObj;

@property (weak, nonatomic) IBOutlet UIButton *selectItemColor;


@end
