//
//  ZFHeadViewCollectionReusableView.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFHeadViewCollectionReusableView : UICollectionReusableView

@property (strong,nonatomic) UILabel * title_lb;//店名
@property (strong,nonatomic) UILabel * address_lb;//地址
@property (copy,nonatomic) NSString * payStatus;//到店付款

@end
