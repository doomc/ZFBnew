//
//  SearchTypeView.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchTypeViewDelegate <NSObject>

///品牌选择
-(void)brandActionlist:(UIButton *)button;
///价格排序
-(void)priceSortAction:(UIButton *)button;

///销量排序
-(void)salesSortAction:(UIButton *)button;

///距离排序
-(void)distenceSortAction:(UIButton *)button;


@end
@interface SearchTypeView : UIView
@property (assign , nonatomic) id <SearchTypeViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *salesBtn;
@property (weak, nonatomic) IBOutlet UIButton *distenceBtn;


@end
